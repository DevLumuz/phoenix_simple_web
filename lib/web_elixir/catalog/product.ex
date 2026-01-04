defmodule WebElixir.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field(:name, :string)
    field(:description, :string)
    field(:price, :decimal)
    field(:stock, :integer, default: 0)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :stock])
    |> validate_required([:name, :price])
    |> validate_length(:name, min: 2, max: 100)
    |> validate_number(:price, greater_than: 0, less_than: 1_000_000_000)
    |> validate_number(:stock, greater_than_or_equal_to: 0, less_than: 1_000_000_000)
  end
end
