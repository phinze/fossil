defmodule Fossil.GithubIssueView do
  use Fossil.Web, :view

  def render("index.json", %{github_issues: github_issues}) do
    %{data: render_many(github_issues, Fossil.GithubIssueView, "github_issue.json")}
  end

  def render("show.json", %{github_issue: github_issue}) do
    %{data: render_one(github_issue, Fossil.GithubIssueView, "github_issue.json")}
  end

  def render("github_issue.json", %{github_issue: github_issue}) do
    %{id: github_issue.id,
      title: github_issue.title,
      body: github_issue.body,
      raw_data: github_issue.raw_data}
  end
end
