defmodule Fossil.GithubLabelTest do
  use Fossil.ModelCase

  alias Fossil.GithubLabel

  @valid_attrs %{color: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GithubLabel.changeset(%GithubLabel{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GithubLabel.changeset(%GithubLabel{}, @invalid_attrs)
    refute changeset.valid?
  end
end
