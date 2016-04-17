defmodule Fossil.GithubLabelView do
  use Fossil.Web, :view

  def render("index.json", %{github_labels: github_labels}) do
    %{data: render_many(github_labels, Fossil.GithubLabelView, "github_label.json")}
  end

  def render("show.json", %{github_label: github_label}) do
    %{data: render_one(github_label, Fossil.GithubLabelView, "github_label.json")}
  end

  def render("github_label.json", %{github_label: github_label}) do
    %{id: github_label.id,
      name: github_label.name,
      color: github_label.color}
  end
end
