defmodule LiveViewDemo.Kanban.Card do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveViewDemo.Kanban.{Stage, Position}

  schema "cards" do
    field :name, :string
    field :pricePerUnit, :float
    field :price, :float
    field :quantity, :integer
    timestamps()
    belongs_to(:stage, Stage)
    field(:position, :integer)
  end

  @doc false
  def create_changeset(card, attrs) do
    card
    |> cast(attrs, [:name, :pricePerUnit, :price, :quantity, :stage_id])
    |> validate_required([:name, :stage_id])
    |> Position.insert_at_bottom(:stage_id)
  end

  def update_changeset(card, attrs) do
    card
    |> cast(attrs, [:name, :stage_id, :position])
    |> validate_required([:name, :stage_id, :position])
    |> Position.recompute_positions(:stage_id)
  end
end
