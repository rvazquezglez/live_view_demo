defmodule LiveViewDemo.Kanban do
  import Ecto.Query

  alias LiveViewDemo.Repo
  alias LiveViewDemo.Kanban.{Board, Stage, Card}

  def get_board!() do
    stage_query =
      from s in Stage,
        order_by: s.position,
        preload: [
          cards:
            ^from(c in Card,
              order_by: :position
            )
        ]

    Board
    |> preload(stages: ^stage_query)
    |> first()
    |> Repo.one!()
  end

  def create_board(attrs) do
    %Board{}
    |> Board.changeset(attrs)
    |> Repo.insert()
  end

  def create_stage(attrs) do
    %Stage{}
    |> Stage.create_changeset(attrs)
    |> Repo.insert()
  end

  def get_card!(id) do
    Repo.get(Card, id)
  end

  def create_card(attrs) do
    %Card{}
    |> Card.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_card(card, attrs) do
    card
    |> Card.update_changeset(attrs)
    |> Repo.update()
    |> notify_subscribers([:card, :updated])
  end

  @topic "board"

  def subscribe do
    Phoenix.PubSub.subscribe(LiveViewDemo.PubSub, @topic)
  end

  defp notify_subscribers({:ok, result}, event) do
    Phoenix.PubSub.broadcast(LiveViewDemo.PubSub, @topic, {__MODULE__, event, result})

    Phoenix.PubSub.broadcast(
      LiveViewDemo.PubSub,
      @topic <> "#{result.id}",
      {__MODULE__, event, result}
    )

    {:ok, result}
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}
end
