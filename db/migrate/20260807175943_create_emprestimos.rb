class CreateEmprestimos < ActiveRecord::Migration[8.1]
  def change
    create_table :emprestimos do |t|
      t.references :usuario, null: false, foreign_key: true
      t.references :livro, null: false, foreign_key: true
      t.date :data_emprestimo
      t.date :data_devolucao_prevista
      t.string :status

      t.timestamps
    end
  end
end
