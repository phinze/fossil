defmodule Fossil.PageController do
  use Fossil.Web, :controller

  import Ecto.Query

  def index(conn, params) do
    page = from(i in Fossil.GithubIssue, select: i)
      |> Fossil.Repo.paginate

    render conn, :index,
      issues: page.entries,
      page: page,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
  end
end
