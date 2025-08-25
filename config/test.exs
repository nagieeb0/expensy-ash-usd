import Config
config :ash, policies: [show_policy_breakdowns?: true], disable_async?: true

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :expensy, Expensy.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "expensy_ash_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
# config :ash, :disable_async?, true
# config :ash, :missed_notifications, :ignore

config :expensy, ExpensyWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ZyRa+4kWCLS2gDa4Vq72ncfO12NNbbkJPv72kzhmCF82d985QIT/BpzMFyP2MZ5b",
  server: false

# In test we don't send emails
config :expensy, Expensy.Mailer, adapter: Swoosh.Adapters.Test

config :elixir, :compiler, warnings_as_errors: false

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
