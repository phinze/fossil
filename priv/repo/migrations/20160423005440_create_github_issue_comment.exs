defmodule Fossil.Repo.Migrations.CreateGithubIssueComment do
  use Ecto.Migration

  def change do
    create table(:github_issue_comments) do
      add :github_id, :integer
      add :author_username, :text
      add :body, :text
      add :github_issue_id, references(:github_issues, on_delete: :nothing)

      timestamps
    end
    create index(:github_issue_comments, [:github_issue_id])

  end
end
