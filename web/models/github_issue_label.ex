defmodule Fossil.GithubIssueLabel do
  use Fossil.Web, :model

  schema "github_issues_github_labels" do
    belongs_to :github_issue, Fossil.GithubIssue
    belongs_to :github_label, Fossil.GithubLabel

    timestamps
  end

  @required_fields ~w()
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
