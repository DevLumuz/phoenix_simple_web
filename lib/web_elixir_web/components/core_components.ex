defmodule WebElixirWeb.CoreComponents do
  use Phoenix.Component
  use Gettext, backend: WebElixirWeb.Gettext

  alias Phoenix.LiveView.JS

  attr(:id, :string, default: nil)
  attr(:flash, :map, default: %{})

  def flash_group(assigns) do
    ~H"""
    <div id={@id || "flash-group"}>
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />
    </div>
    """
  end

  attr(:id, :string, default: nil)
  attr(:flash, :map, default: %{})
  attr(:title, :string, default: nil)
  attr(:kind, :atom, values: [:info, :error])
  attr(:rest, :global)

  slot(:inner_block)

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      class={[
        "fixed top-4 right-4 z-50 w-80 p-4 rounded-lg shadow-lg",
        @kind == :info && "bg-green-100 text-green-800 border border-green-200",
        @kind == :error && "bg-red-100 text-red-800 border border-red-200"
      ]}
      role="alert"
      {@rest}
    >
      <p :if={@title} class="font-semibold"><%= @title %></p>
      <p><%= msg %></p>
      <button type="button" class="absolute top-2 right-2" aria-label="close" phx-click={JS.hide(to: "##{@id}")}>✕</button>
    </div>
    """
  end

  attr(:for, :any, required: true)
  attr(:as, :any, default: nil)

  attr(:rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart)
  )

  slot(:inner_block, required: true)
  slot(:actions)

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="space-y-4">
        <%= render_slot(@inner_block, f) %>
        <div :for={action <- @actions} class="mt-6 flex justify-end gap-4">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end

  attr(:id, :any, default: nil)
  attr(:name, :any)
  attr(:label, :string, default: nil)
  attr(:value, :any)
  attr(:type, :string, default: "text")
  attr(:field, Phoenix.HTML.FormField)
  attr(:errors, :list, default: [])
  attr(:checked, :boolean)
  attr(:prompt, :string, default: nil)
  attr(:options, :list)
  attr(:multiple, :boolean, default: false)

  attr(:rest, :global,
    include:
      ~w(accept autocomplete cols disabled form max maxlength min minlength pattern placeholder readonly required rows size step)
  )

  slot(:inner_block)

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div>
      <.label for={@id}><%= @label %></.label>
      <select id={@id} name={@name} class="mt-1 block w-full rounded-md border-gray-300" multiple={@multiple} {@rest}>
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
      </select>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div>
      <.label for={@id}><%= @label %></.label>
      <textarea id={@id} name={@name} class="mt-1 block w-full rounded-md border-gray-300 min-h-[100px]" {@rest}><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(assigns) do
    ~H"""
    <div>
      <.label for={@id}><%= @label %></.label>
      <input type={@type} name={@name} id={@id} value={Phoenix.HTML.Form.normalize_value(@type, @value)} class="mt-1 block w-full rounded-md border-gray-300" {@rest} />
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  attr(:for, :string, default: nil)
  slot(:inner_block, required: true)

  def label(assigns) do
    ~H"""
    <label for={@for} class="block text-sm font-medium text-gray-700">
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  slot(:inner_block, required: true)

  def error(assigns) do
    ~H"""
    <p class="mt-1 text-sm text-red-600"><%= render_slot(@inner_block) %></p>
    """
  end

  attr(:type, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(disabled form name value))

  slot(:inner_block, required: true)

  def button(assigns) do
    ~H"""
    <button type={@type} class={["px-4 py-2 text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700", @class]} {@rest}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  defp translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(WebElixirWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(WebElixirWeb.Gettext, "errors", msg, opts)
    end
  end
end
