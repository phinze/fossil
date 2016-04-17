defmodule Fossil.GithubSync do
  use GenServer
  require Logger
  alias Fossil.GithubIssue

  @sleep_seconds 5

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, sleep_time)
    {:ok, state}
  end

  def handle_info(:work, state) do
    Process.send_after(self(), :work, sleep_time)
    {:noreply, state}
  end

  defp sleep_time do
    @sleep_seconds * 1000
  end
end
