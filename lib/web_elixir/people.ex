defmodule WebElixir.People do
  import Ecto.Query, warn: false
  alias WebElixir.Repo
  alias WebElixir.People.Person

  def list_people do
    Repo.all(from(p in Person, order_by: [desc: p.inserted_at]))
  end

  def get_person!(id), do: Repo.get!(Person, id)

  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  def update_person(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end

  def delete_person(%Person{} = person) do
    Repo.delete(person)
  end

  def change_person(%Person{} = person, attrs \\ %{}) do
    Person.changeset(person, attrs)
  end
end
