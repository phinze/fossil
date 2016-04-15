defmodule Fossil.GithubIssueTest do
  use Fossil.ModelCase

  alias Fossil.GithubIssue

  @valid_attrs %{body: "some content", raw_data: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GithubIssue.changeset(%GithubIssue{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GithubIssue.changeset(%GithubIssue{}, @invalid_attrs)
    refute changeset.valid?
  end
end
