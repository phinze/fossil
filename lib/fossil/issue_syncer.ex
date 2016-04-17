defmodule Fossil.IssueSyncer do
  require Logger
  alias Fossil.GithubIssue

  def sync_all do
    settings = Application.get_env(:fossil, :github_settings)
    client = Tentacat.Client.new(%{access_token: settings[:token]})
    [owner, repo] = String.split(settings[:repo], "/")

    # Tentacat.Issues.Label.list(owner, repo, client)
    # |> Enum.map(&sync_label/1)

    Tentacat.Issues.list(owner, repo, client)
    |> Enum.map(&sync_issue/1)
  end

  def sync_issue(issue_data) do
    Logger.info("Syncing issue: #{issue_data["number"]}")
    case Fossil.Repo.get_by(GithubIssue, number: issue_data["number"]) do
      nil -> %GithubIssue{}
      issue -> issue
    end
    |> GithubIssue.changeset(issue_data)
    |> Fossil.Repo.insert_or_update
  end
end
