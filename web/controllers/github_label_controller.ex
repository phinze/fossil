defmodule Fossil.GithubLabelController do
  use Fossil.Web, :controller

  alias Fossil.GithubLabel

  plug :scrub_params, "github_label" when action in [:create, :update]

  def index(conn, _params) do
    github_labels = Repo.all(GithubLabel)
    render(conn, "index.json", github_labels: github_labels)
  end

  def create(conn, %{"github_label" => github_label_params}) do
    changeset = GithubLabel.changeset(%GithubLabel{}, github_label_params)

    case Repo.insert(changeset) do
      {:ok, github_label} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", github_label_path(conn, :show, github_label))
        |> render("show.json", github_label: github_label)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Fossil.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    github_label = Repo.get!(GithubLabel, id)
    render(conn, "show.json", github_label: github_label)
  end

  def update(conn, %{"id" => id, "github_label" => github_label_params}) do
    github_label = Repo.get!(GithubLabel, id)
    changeset = GithubLabel.changeset(github_label, github_label_params)

    case Repo.update(changeset) do
      {:ok, github_label} ->
        render(conn, "show.json", github_label: github_label)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Fossil.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    github_label = Repo.get!(GithubLabel, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(github_label)

    send_resp(conn, :no_content, "")
  end
end
