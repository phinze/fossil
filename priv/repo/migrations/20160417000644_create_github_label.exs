defmodule Fossil.Repo.Migrations.CreateGithubLabel do
  use Ecto.Migration

  def change do
    create table(:github_labels) do
      add :name, :text
      add :color, :text

      timestamps
    end

  end
end
