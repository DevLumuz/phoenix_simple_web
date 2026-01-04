defmodule WebElixirWeb.ProductHTML do
  use WebElixirWeb, :html

  embed_templates("product_html/*")

  attr(:changeset, Ecto.Changeset, required: true)
  attr(:action, :string, required: true)

  def product_form(assigns)
end
