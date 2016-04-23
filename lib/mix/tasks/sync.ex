defmodule Mix.Tasks.Fossil.Sync do
  use Mix.Task
  require Logger

  @shortdoc "Sync GitHub issues from API to local postgres instance"

  def run(_) do
    Mix.Task.run "app.start", []
    Logger.info "Syncing Issues"
    # Fossil.IssueSyncer.sync_all
    Logger.info "Syncing Issue Comments"
    Fossil.IssueCommentSyncer.sync_all
  end
end
