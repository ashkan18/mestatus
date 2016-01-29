defmodule Mestatus.Router do
  use Mestatus.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    #plug :check_slack_token
  end

  # Other scopes may use custom stacks.
  scope "/api", Mestatus do
    pipe_through :api
    resources "/user_statuses", UserStatusApi, [:create]
  end
end
