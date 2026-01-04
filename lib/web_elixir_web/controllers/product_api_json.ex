defmodule WebElixirWeb.ProductAPIJSON do
  alias WebElixir.Catalog.Product

  def index(%{products: products}) do
    %{data: for(product <- products, do: data(product))}
  end

  def show(%{product: product}) do
    %{data: data(product)}
  end

  defp data(%Product{} = product) do
    %{
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      stock: product.stock,
      inserted_at: product.inserted_at,
      updated_at: product.updated_at
    }
  end
end
