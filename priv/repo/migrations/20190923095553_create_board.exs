defmodule Kanban.Repo.Migrations.CreateBoard do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :name, :string
      timestamps()
    end

    create table(:stages) do
      add :name, :string
      add :board_id, references(:boards, on_delete: :delete_all), null: false
      add :position, :integer, null: false
      timestamps()
    end

    create(index(:stages, :position))

    create table(:cards) do
      add :name, :string
      add(:stage_id, references(:stages, on_delete: :delete_all), null: false)
      add :position, :integer, null: false

      timestamps()
    end

    # TODO: fix Position to respect this constraint :
    # create(index(:cards, [:stage_id, :position], unique: true))
    create(index(:cards, :position))
  end
end
