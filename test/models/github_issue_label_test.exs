defmodule Fossil.GithubIssueLabelTest do
  use Fossil.ModelCase

  alias Fossil.GithubIssueLabel

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GithubIssueLabel.changeset(%GithubIssueLabel{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GithubIssueLabel.changeset(%GithubIssueLabel{}, @invalid_attrs)
    refute changeset.valid?
  end
end
