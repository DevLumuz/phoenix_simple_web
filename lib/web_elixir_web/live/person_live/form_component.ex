defmodule WebElixirWeb.PersonLive.FormComponent do
  use WebElixirWeb, :live_component

  alias WebElixir.People

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h2 class="text-2xl font-bold text-white mb-2"><%= @title %></h2>
      <p class="text-gray-400 mb-6">Los cambios se validan en tiempo real</p>

      <.form
        for={@form}
        id="person-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-5"
      >
        <div>
          <label class="block text-sm font-medium text-gray-300 mb-2">Nombre *</label>
          <input type="text" name={@form[:name].name} value={@form[:name].value}
            class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-cyan-500 focus:border-transparent transition"
            placeholder="Ej: Juan Pérez" phx-debounce="300" />
          <p :for={msg <- @form[:name].errors} class="mt-1 text-sm text-red-400"><%= elem(msg, 0) %></p>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-300 mb-2">Email *</label>
          <input type="email" name={@form[:email].name} value={@form[:email].value}
            class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-cyan-500 focus:border-transparent transition"
            placeholder="correo@ejemplo.com" phx-debounce="300" />
          <p :for={msg <- @form[:email].errors} class="mt-1 text-sm text-red-400"><%= elem(msg, 0) %></p>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-300 mb-2">Edad</label>
            <input type="number" name={@form[:age].name} value={@form[:age].value} min="1" max="150"
              class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-cyan-500 focus:border-transparent transition"
              placeholder="25" phx-debounce="300" />
            <p :for={msg <- @form[:age].errors} class="mt-1 text-sm text-red-400"><%= elem(msg, 0) %></p>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-300 mb-2">Teléfono</label>
            <input type="tel" name={@form[:phone].name} value={@form[:phone].value}
              class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-cyan-500 focus:border-transparent transition"
              placeholder="+52 123 456 7890" phx-debounce="300" />
          </div>
        </div>

        <button type="submit" phx-disable-with="Guardando..." class="w-full bg-gradient-to-r from-cyan-500 to-blue-500 text-white py-3 rounded-xl font-semibold hover:opacity-90 transition shadow-lg shadow-cyan-500/25 mt-6 disabled:opacity-50">
          Guardar Persona
        </button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{person: person} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(People.change_person(person))
     end)}
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset = People.change_person(socket.assigns.person, person_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"person" => person_params}, socket) do
    save_person(socket, socket.assigns.action, person_params)
  end

  defp save_person(socket, :edit, person_params) do
    case People.update_person(socket.assigns.person, person_params) do
      {:ok, person} ->
        notify_parent({:saved, person})

        {:noreply,
         socket
         |> put_flash(:info, "Persona actualizada")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_person(socket, :new, person_params) do
    case People.create_person(person_params) do
      {:ok, person} ->
        notify_parent({:saved, person})

        {:noreply,
         socket
         |> put_flash(:info, "Persona creada")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
