defmodule Fossil.GithubIssueController do
  use Fossil.Web, :controller

  alias Fossil.GithubIssue

  plug :scrub_params, "github_issue" when action in [:create, :update]

  def index(conn, _params) do
    github_issues = Repo.all(GithubIssue)
    render(conn, "index.json", github_issues: github_issues)
  end

  def create(conn, %{"github_issue" => github_issue_params}) do
    changeset = GithubIssue.changeset(%GithubIssue{}, github_issue_params)

    case Repo.insert(changeset) do
      {:ok, github_issue} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", github_issue_path(conn, :show, github_issue))
        |> render("show.json", github_issue: github_issue)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Fossil.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    github_issue = Repo.get!(GithubIssue, id)
    render(conn, "show.json", github_issue: github_issue)
  end

  def update(conn, %{"id" => id, "github_issue" => github_issue_params}) do
    github_issue = Repo.get!(GithubIssue, id)
    changeset = GithubIssue.changeset(github_issue, github_issue_params)

    case Repo.update(changeset) do
      {:ok, github_issue} ->
        render(conn, "show.json", github_issue: github_issue)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Fossil.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    github_issue = Repo.get!(GithubIssue, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(github_issue)

    send_resp(conn, :no_content, "")
  end
end
