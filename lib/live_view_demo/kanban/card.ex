defmodule LiveViewDemo.Kanban.Card do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveViewDemo.Kanban.{Stage, Position}

  schema "cards" do
    field :name, :string
    timestamps()
    belongs_to(:stage, Stage)
    field(:position, :integer)
  end

  @doc false
  def create_changeset(card, attrs) do
    card
    |> cast(attrs, [:name, :stage_id])
    |> validate_required([:name, :stage_id])
    |> Position.insert_at_bottom(:stage_id)
  end
end
