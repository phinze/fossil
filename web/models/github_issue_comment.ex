defmodule Fossil.GithubIssueComment do
  use Fossil.Web, :model

  schema "github_issue_comments" do
    field :github_id, :integer
    field :author_username, :string
    field :body, :string
    belongs_to :github_issue, Fossil.GithubIssue

    timestamps
  end

  @required_fields ~w(github_id author_username body)
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
