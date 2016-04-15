defmodule Fossil.GithubIssueControllerTest do
  use Fossil.ConnCase

  alias Fossil.GithubIssue
  @valid_attrs %{body: "some content", raw_data: "some content", title: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, github_issue_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    github_issue = Repo.insert! %GithubIssue{}
    conn = get conn, github_issue_path(conn, :show, github_issue)
    assert json_response(conn, 200)["data"] == %{"id" => github_issue.id,
      "title" => github_issue.title,
      "body" => github_issue.body,
      "raw_data" => github_issue.raw_data}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, github_issue_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, github_issue_path(conn, :create), github_issue: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(GithubIssue, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, github_issue_path(conn, :create), github_issue: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    github_issue = Repo.insert! %GithubIssue{}
    conn = put conn, github_issue_path(conn, :update, github_issue), github_issue: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(GithubIssue, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    github_issue = Repo.insert! %GithubIssue{}
    conn = put conn, github_issue_path(conn, :update, github_issue), github_issue: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    github_issue = Repo.insert! %GithubIssue{}
    conn = delete conn, github_issue_path(conn, :delete, github_issue)
    assert response(conn, 204)
    refute Repo.get(GithubIssue, github_issue.id)
  end
end
