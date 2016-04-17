defmodule Mix.Tasks.Fossil.Sync do
  use Mix.Task

  @shortdoc "Sync GitHub issues from API to local postgres instance"

  def run(_) do
    Mix.Task.run "app.start", []
    Fossil.IssueSyncer.sync_all
  end
end
