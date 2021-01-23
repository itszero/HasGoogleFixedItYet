Sequel.migration do
  change do
    create_table(:translations) do
      primary_key :id
      String :english_word, null: false
      String :zhtw_word, null: false
      DateTime :first_seen_at, null: false
      DateTime :last_seen_at, null: false
    end
  end
end
