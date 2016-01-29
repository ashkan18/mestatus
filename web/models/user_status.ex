defmodule Mestatus.UserStatus do
  use Mestatus.Web, :model
  
  schema "user_statuses" do
    field :username, :string
    field :status, :string
    field :app, :string
    field :note, :string

    timestamps
  end

  @required_fields ~w(username status app)
  @optional_fields ~w(note)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:status, ~w(intervened done))
  end

  def latest_status do
    from u in Mestatus.UserStatus,
    distinct: u.username,
    order_by: [u.username, desc: :inserted_at]
  end
end
