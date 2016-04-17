defmodule Fossil.GithubLabelControllerTest do
  use Fossil.ConnCase

  alias Fossil.GithubLabel
  @valid_attrs %{color: "some content", name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, github_label_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    github_label = Repo.insert! %GithubLabel{}
    conn = get conn, github_label_path(conn, :show, github_label)
    assert json_response(conn, 200)["data"] == %{"id" => github_label.id,
      "name" => github_label.name,
      "color" => github_label.color}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, github_label_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, github_label_path(conn, :create), github_label: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(GithubLabel, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, github_label_path(conn, :create), github_label: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    github_label = Repo.insert! %GithubLabel{}
    conn = put conn, github_label_path(conn, :update, github_label), github_label: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(GithubLabel, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    github_label = Repo.insert! %GithubLabel{}
    conn = put conn, github_label_path(conn, :update, github_label), github_label: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    github_label = Repo.insert! %GithubLabel{}
    conn = delete conn, github_label_path(conn, :delete, github_label)
    assert response(conn, 204)
    refute Repo.get(GithubLabel, github_label.id)
  end
end
