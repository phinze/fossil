defmodule Fossil.Repo.Migrations.CreateGithubIssue do
  use Ecto.Migration

  def change do
    create table(:github_issues) do
      add :title, :text
      add :body, :text
      add :number, :integer
      add :raw_data, :map

      timestamps
    end

    create unique_index(:github_issues, [:number])
  end
end
