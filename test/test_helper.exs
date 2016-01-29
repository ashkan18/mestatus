ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Mestatus.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Mestatus.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Mestatus.Repo)

