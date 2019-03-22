# The :shared mode allows a process to share
# its connection with any other process automatically
Ecto.Adapters.SQL.Sandbox.mode(Database.Repo, { :shared, self() })

ExUnit.start()
