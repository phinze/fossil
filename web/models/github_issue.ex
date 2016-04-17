defmodule Fossil.GithubIssue do
  use Fossil.Web, :model

  schema "github_issues" do
    field :title, :string
    field :body, :string
    field :number, :integer
    field :raw_data, :map

    timestamps
  end

  @required_fields ~w(number title body)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:number)
  end
end
