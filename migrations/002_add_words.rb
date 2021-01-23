Sequel.migration do
  change do
    create_table(:words) do
      primary_key :id
      String :english_word, null: false
      String :correct_zhtw_word, null: false
    end
  end
end
