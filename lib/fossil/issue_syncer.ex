defmodule Fossil.IssueSyncer do
  require Logger
  alias Fossil.GithubIssue
  alias Fossil.GithubLabel

  def sync_all do
    settings = Application.get_env(:fossil, :github_settings)
    client = Tentacat.Client.new(%{access_token: settings[:token]})
    [owner, repo] = String.split(settings[:repo], "/")

    Tentacat.Issues.list(owner, repo, client)
    |> Enum.map(&sync_issue/1)
  end

  def sync_issue(issue_data) do
    number = issue_data["number"]
    Logger.info("Syncing issue: #{number}")
    result =
      case Fossil.Repo.get_by(GithubIssue, number: number) do
        nil -> %GithubIssue{}
        issue -> issue
      end
      |> GithubIssue.changeset(issue_data)
      |> Fossil.Repo.insert_or_update

    case result do
      {:ok, issue} ->
        Logger.info("Success! Issue #{number} has ID: #{issue.id}")
        sync_labels(issue_data)
      {:error, changeset} ->
        Logger.info("Oh no! Issue #{number} has errors: #{inspect changeset.errors}")
    end
  end

  def sync_labels(issue_data) do
    issue_data["labels"]
    |> Enum.map(&sync_label/1)
  end

  def sync_label(label_data) do
    name = label_data["name"]
    Logger.info("Syncing label: #{name}")
    result =
      case Fossil.Repo.get_by(GithubLabel, name: name) do
        nil -> %GithubLabel{}
        label -> label
      end
      |> GithubLabel.changeset(label_data)
      |> Fossil.Repo.insert_or_update

    case result do
      {:ok, label} ->
        Logger.info("Success! Label #{name} has ID: #{label.id}")
      {:error, changeset} ->
        Logger.info("Oh no! Label #{name} has errors: #{inspect changeset.errors}")
    end
  end
end
