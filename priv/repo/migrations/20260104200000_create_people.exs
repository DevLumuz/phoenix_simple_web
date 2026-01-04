defmodule WebElixir.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :age, :integer
      add :phone, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:people, [:email])
  end
end
