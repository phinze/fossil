defmodule Fossil.IssueCommentSyncer do
  require Logger

  alias Fossil.GithubIssueComment

  def sync_all do
    settings = Application.get_env(:fossil, :github_settings)
    client = Tentacat.Client.new(%{access_token: settings[:token]})
    [owner, repo] = String.split(settings[:repo], "/")

    Tentacat.Issues.Comments.list_all(owner, repo, client)
    |> Enum.map(&sync_comment/1)
  end

  def sync_comment(comment_data) do
    github_id = comment_data["id"]
    issue_id = issue_id_from_comment_url(comment_data["html_url"])
    Logger.info("Syncing issue comment: #{github_id}")
    result =
      case Fossil.Repo.get_by(GithubIssueComment, github_id: github_id) do
        nil -> %GithubIssueComment{}
        comment -> comment
      end
      |> GithubIssueComment.changeset(%{
        github_id: github_id,
        body: comment_data["body"],
        author_username: comment_data["user"]["login"],
        github_issue_id: issue_id,
      })
      |> Fossil.Repo.insert_or_update

    case result do
      {:ok, comment} ->
        Logger.info("Success! Issue comment #{github_id} has ID: #{comment.id}")
      {:error, changeset} ->
        Logger.info("Oh no! Issue #{github_id} has errors: #{inspect changeset.errors}")
    end
  end

  defp issue_id_from_comment_url(url) do
    issue_id = List.last(String.split(
      URI.parse(url).path, "/"))
    Logger.info("issue ID: #{issue_id}")
    issue_id
  end
end
