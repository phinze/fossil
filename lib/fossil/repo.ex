defmodule Fossil.Repo do
  use Ecto.Repo, otp_app: :fossil

  use Scrivener, page_size: 10
end
