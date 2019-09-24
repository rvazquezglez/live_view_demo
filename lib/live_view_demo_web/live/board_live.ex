defmodule LiveViewDemoWeb.BoardLive do
  use Phoenix.LiveView

  alias LiveViewDemo.Kanban

  def render(assigns) do
    ~L"""
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
    {:ok, assign(socket, :board, Kanban.get_board!())}
  end
end
