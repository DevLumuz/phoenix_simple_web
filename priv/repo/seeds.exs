# Script for populating the database.
#
# You can run it as:
#     mix run priv/repo/seeds.exs

alias WebElixir.Repo
alias WebElixir.Catalog.Product

products = [
  %{name: "Laptop Pro", description: "Laptop de alto rendimiento", price: Decimal.new("1299.99"), stock: 10},
  %{name: "Mouse Inalámbrico", description: "Mouse ergonómico bluetooth", price: Decimal.new("29.99"), stock: 50},
  %{name: "Teclado Mecánico", description: "Teclado RGB switches azules", price: Decimal.new("89.99"), stock: 25}
]

for product <- products do
  Repo.insert!(%Product{
    name: product.name,
    description: product.description,
    price: product.price,
    stock: product.stock
  })
end

IO.puts("Seeds inserted successfully!")
