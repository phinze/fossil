defmodule Fossil.Repo.Migrations.CreateGithubIssueLabel do
  use Ecto.Migration

  def change do
    create table(:github_issues_github_labels) do
      add :github_issue_id, references(:github_issues)
      add :github_label_id, references(:github_labels)

      timestamps
    end
    create index(:github_issues_github_labels, [:github_issue_id])
    create index(:github_issues_github_labels, [:github_label_id])

  end
end
