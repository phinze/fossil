defmodule Fossil.IssueSyncer do
  require Logger
  alias Fossil.GithubIssue
  alias Fossil.GithubIssueLabel
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
        sync_labels(issue_data["labels"], issue)
      {:error, changeset} ->
        Logger.info("Oh no! Issue #{number} has errors: #{inspect changeset.errors}")
    end
  end

  def sync_labels(labels_data, issue) do
    labels_data
    |> Enum.map(&sync_label/1)
    |> Enum.map(fn(result) -> Tuple.append(result, issue) end)
    |> Enum.map(&associate_label/1)
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

    result
  end

  def associate_label({:error, _, _}) do
     # noop
  end

  def associate_label({:ok, label, issue}) do
    Logger.info("Associating label: #{label.name} with issue #{issue.number}")
    result =
      case Fossil.Repo.get_by(
          GithubIssueLabel,
          github_issue_id: issue.id,
          github_label_id: label.id,
      ) do
        nil -> %GithubIssueLabel{}
        issue_label -> issue_label
      end
      |> GithubIssueLabel.changeset(%{
        github_issue_id: issue.id,
        github_label_id: label.id,
      })
      |> Fossil.Repo.insert_or_update

    case result do
      {:ok, issue_label} ->
        Logger.info("Success! Association has ID: #{issue_label.id}")
      {:error, changeset} ->
        Logger.info("Oh no! Association has errors: #{inspect changeset.errors}")
    end

  end
end
