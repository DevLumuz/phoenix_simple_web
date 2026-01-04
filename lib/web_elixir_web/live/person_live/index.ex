defmodule WebElixirWeb.PersonLive.Index do
  use WebElixirWeb, :live_view

  alias WebElixir.People
  alias WebElixir.People.Person

  @impl true
  def mount(_params, _session, socket) do
    people = People.list_people()

    {:ok,
     socket
     |> assign(:people_count, length(people))
     |> stream(:people, people)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Persona")
    |> assign(:person, People.get_person!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Nueva Persona")
    |> assign(:person, %Person{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Personas (LiveView)")
    |> assign(:person, nil)
  end

  @impl true
  def handle_info({WebElixirWeb.PersonLive.FormComponent, {:saved, person}}, socket) do
    {:noreply,
     socket
     |> update(:people_count, &(&1 + 1))
     |> stream_insert(:people, person, at: 0)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = People.get_person!(id)
    {:ok, _} = People.delete_person(person)

    {:noreply,
     socket
     |> update(:people_count, &(&1 - 1))
     |> stream_delete(:people, person)}
  end
end
