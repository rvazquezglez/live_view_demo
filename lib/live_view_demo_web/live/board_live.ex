defmodule LiveViewDemoWeb.BoardLive do
  use Phoenix.LiveView

  alias LiveViewDemo.Kanban

  def render(assigns) do
    ~L"""

    <div class="section" phx-hook="Board">
      <%= for stage <- @board.stages do %>
        <div data-stage-id="<%= stage.id %>" class="stage">
          <div class="stage__header draggable-handle">
            <div class="stage__name"><%= stage.name %></div>
            <div class="stage__counter"><%= length(stage.cards) %> items</div>
            <div class="stage__counter">Total <%= Number.Currency.number_to_currency( Enum.reduce(stage.cards, 0, fn(current, accumulator) -> accumulator + current.price end) ) %></div>
          </div>

          <ul data-stage-id="<%= stage.id %>" class="stage__cards ordered-items clearfix">
            <%= for {card, i} <- Enum.with_index(stage.cards) do %>
              <li data-card-id="<%= card.id %>" class="card <%=Enum.at(["blue", "purple", "pink", "orange", "yellow"], rem(i, 5))%>">
                <div class="padding">
                  <div class="number-box">
                    <div class="number-box-outter"></div>
                    <div class="number-box-inner"></div>
                    <div class="number text-center text-white"><span class="id-item-quantity"><%= card.quantity%></span></div>
                  </div>
                  <span class="text-black"><span class="id-item-name"><%= card.name %></span></span><br/>
                  &#64; <span class="id-item-price"><%= Number.Currency.number_to_currency(card.pricePerUnit)%></span> each
                  <span class="total text-black"><span class="id-item-total"><%= Number.Currency.number_to_currency(card.price)%></span></span>
                </div>
              </li>
            <% end %>
          </ul>
        </div>
      <% end %>
    </div>
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

  def handle_event("update_stage", %{"stage" => stage_attrs}, socket) do
    stage = Kanban.get_stage!(stage_attrs["id"])

    case Kanban.update_stage(stage, stage_attrs) do
      {:ok, _updated_stage} ->
        {:noreply, update(socket, :board, fn _ -> Kanban.get_board!() end)}

      {:error, changeset} ->
        {:noreply, {:error, %{message: changeset.message}, socket}}
    end
  end

  def handle_info({Kanban, [_, :updated], _}, socket) do
    {:noreply, assign(socket, :board, Kanban.get_board!())}
  end
end
