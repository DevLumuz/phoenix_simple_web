defmodule WebElixir.People.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field(:name, :string)
    field(:email, :string)
    field(:age, :integer)
    field(:phone, :string)

    timestamps(type: :utc_datetime)
  end

  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :email, :age, :phone])
    |> validate_required([:name, :email])
    |> validate_length(:name, min: 2, max: 100)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "debe ser un email válido")
    |> validate_number(:age, greater_than: 0, less_than: 150)
    |> unique_constraint(:email)
  end
end
