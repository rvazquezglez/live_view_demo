defmodule LiveViewDemoWeb.BoardLive do
  use Phoenix.LiveView

  alias LiveViewDemo.Kanban

  def render(assigns) do
    ~L"""

    <h2><%= @board.name %></h2>

    <section class="board" phx-hook="Board">
      <%= for stage <- @board.stages do %>
        <div class="stage">
          <div class="stage__header">
            <div class="stage__name"><%= stage.name %></div>
            <div class="stage__counter"><%= length(stage.cards) %></div>
          </div>

          <ul data-stage-id="<%= stage.id %>" class="stage__cards">
            <%= for card <- stage.cards do %>
              <li data-card-id="<%= card.id %>" class="card">
                <div class="card__name"><%= card.name %></div>
              </li>
            <% end %>
          </ul>
        </div>
      <% end %>
    </section>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: Kanban.subscribe()
    {:ok, assign(socket, :board, Kanban.get_board!())}
  end

  def handle_event("update_card", %{"card" => card_attrs}, socket) do
    card = Kanban.get_card!(card_attrs["id"])

    case Kanban.update_card(card, card_attrs) do
      {:ok, _updated_card} ->
        {:noreply, update(socket, :board, fn _ -> Kanban.get_board!() end)}

      {:error, changeset} ->
        {:noreply, {:error, %{message: changeset.message}, socket}}
    end
  end

  def handle_info({Kanban, [:card, :updated], _}, socket) do
    {:noreply, assign(socket, :board, Kanban.get_board!())}
  end
end
