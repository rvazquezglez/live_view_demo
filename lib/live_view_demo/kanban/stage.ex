defmodule LiveViewDemo.Kanban.Stage do
  use Ecto.Schema
  import Ecto.Changeset
  alias LiveViewDemo.Kanban.{Position, Board, Card}

  schema "stages" do
    field :name, :string
    field :position, :integer
    timestamps()
    belongs_to :board, Board
    has_many :cards, Card
  end

  @doc false
  def create_changeset(stage, attrs) do
    stage
    |> cast(attrs, [:name, :board_id])
    |> validate_required([:name, :board_id])
    |> Position.insert_at_bottom(:board_id)
  end
end
