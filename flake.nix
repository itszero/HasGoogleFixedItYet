{
  description = "Has Google Fixed It Yet — tracks Google Translate fixes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      # Defined as a function of pkgs so the overlay composes with downstream
      # nixpkgs overrides (e.g. a consumer pinning a different nodejs).
      mkPackages =
        pkgs:
        let
          ruby = pkgs.ruby_3_4;

          gems = pkgs.bundlerEnv {
            name = "hgfiy-gems";
            inherit ruby;
            gemfile = ./Gemfile;
            lockfile = ./Gemfile.lock;
            gemset = ./gemset.nix;
            groups = [
              "default"
              "production"
            ];
          };

          # snowpack 3.8.6 pins esbuild ~0.9.0, but yarnConfigHook skips lifecycle
          # scripts so the platform-specific binary is never fetched. Build the
          # matching esbuild version from source and drop it in before building.
          esbuild_0_9 = pkgs.buildGoModule rec {
            pname = "esbuild";
            version = "0.9.7";
            src = pkgs.fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              rev = "v${version}";
              hash = "sha256-7O5utKEHjqHxNDRxVvIw/jJGqnfIVsXKnxVAEuxP5/A=";
            };
            vendorHash = "sha256-2ABWPqhK2Cf4ipQH7XvRrd+ZscJhYPc3SV2cGT0apdg=";
          };

          frontend = pkgs.stdenv.mkDerivation (finalAttrs: {
            pname = "hgfiy-frontend";
            version = "0";
            src = ./frontend;

            yarnOfflineCache = pkgs.fetchYarnDeps {
              yarnLock = finalAttrs.src + "/yarn.lock";
              hash = "sha256-vEQb0qUYH3qzAK/V9Fc0B7tF5IpgkEimGr3TcnylBxE=";
            };

            nativeBuildInputs = [
              pkgs.nodejs
              pkgs.yarn
              pkgs.yarnConfigHook
              pkgs.yarnBuildHook
            ];

            yarnConfigHookExtraArgs = [ "--ignore-scripts" ];

            preBuild = ''
              install -m755 ${esbuild_0_9}/bin/esbuild node_modules/esbuild/bin/esbuild
            '';

            installPhase = ''
              runHook preInstall
              mv build $out
              runHook postInstall
            '';
          });

          # Stage the runtime tree: ruby sources + migrations + public/ symlink to the built frontend.
          appRoot = pkgs.runCommand "hgfiy-root" { } ''
            mkdir -p $out
            cp ${./server.rb}  $out/server.rb
            cp ${./update.rb}  $out/update.rb
            cp ${./seed.rb}    $out/seed.rb
            cp ${./db.rb}      $out/db.rb
            cp ${./config.ru}  $out/config.ru
            cp -r ${./migrations} $out/migrations
            ln -s ${frontend} $out/public
          '';
        in
        {
          hgfiy = pkgs.writeShellApplication {
            name = "hgfiy";
            runtimeInputs = [ gems ];
            text = ''
              cd ${appRoot}
              exec thin start "$@"
            '';
          };

          hgify-update = pkgs.writeShellApplication {
            name = "hgify-update";
            runtimeInputs = [
              gems
              gems.wrappedRuby
            ];
            text = ''
              cd ${appRoot}
              exec ruby update.rb "$@"
            '';
          };
        };
    in
    {
      overlays.default = final: _prev: mkPackages final;

      nixosModules.default = import ./nixos-module.nix { inherit self; };
      nixosModules.hgfiy = self.nixosModules.default;
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        ps = mkPackages pkgs;
      in
      {
        packages = ps // {
          default = ps.hgfiy;
        };
      }
    );
}
