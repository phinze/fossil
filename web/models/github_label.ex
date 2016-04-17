defmodule Fossil.GithubLabel do
  use Fossil.Web, :model

  schema "github_labels" do
    field :name, :string
    field :color, :string

    timestamps
  end

  @required_fields ~w(name color)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
