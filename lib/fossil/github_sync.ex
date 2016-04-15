defmodule Fossil.GithubSync do
  use GenServer

  @sleep_seconds 5

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, sleep_time)
    {:ok, state}
  end

  def handle_info(:work, state) do
    settings = Application.get_env(:fossil, :github_settings)
    client = Tentacat.Client.new(%{access_token: settings[:token]})
    [owner, repo] = String.split(settings[:repo], "/")
    issues = Tentacat.Issues.list(owner, repo, client)
    issues |> Enum.take(5) |> Enum.each(fn issue_data ->
      issue = Fossil.Repo.get_by(Fossil.GithubIssue, number: issue_data["number"])
      if issue == nil do
        issue = %Fossil.GithubIssue{
          number: issue_data["number"],
          title: issue_data["title"],
          body: issue_data["body"],
          raw_data: issue_data,
        }
      end
      Fossil.Repo.insert_or_update!(issue.changeset)
    end)
    Process.send_after(self(), :work, sleep_time)
    {:noreply, state}
  end

  defp sleep_time do
    @sleep_seconds * 1000
  end
end
