# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :fossil, Fossil.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "cAPmhcL6QiekKqUcHqcOreGf5COra0hOJ9MUSFd1ogYKHxNmRQ+ocVNLB+vji+ZR",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Fossil.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :fossil, :github_settings,
  token: System.get_env("GITHUB_TOKEN"),
  repo: System.get_env("GITHUB_REPO")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :scrivener_html,
  routes_helper: Fossil.Router.Helpers

config :tentacat,
  request_options: [
    recv_timeout: 60000,
  ],
  pagination: :stream
