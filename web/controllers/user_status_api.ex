defmodule Mestatus.UserStatusApi do
  use Mestatus.Web, :controller
  require Logger

  alias Mestatus.UserStatus
  
  plug :check_token
  
  def create(conn, %{"text" => text, "user_name" => username}) do
    Logger.info text
    [command, app, note] = String.split(text, ~r{\s}, trim: true, parts: 3)
    message = case command do
      x when x in ~w(intervened done) ->
        params = %{status: command, app: app, note: note, username: username}
        changeset = UserStatus.changeset(%UserStatus{}, params)

        case Repo.insert(changeset) do
          {:ok, user_status} ->
            if user_status.status == 'intervened' do
              "Sorry that you are blocked, let me know once you are unblocked."
            else
              "Stored your new status."
            end
            
          {:error, changeset} ->
            "There was an issue with setting status."
        end
      "status" ->
        # show current status
        Repo.all(UserStatus.latest_status)
        "Current staus" 
      _ ->
        "Unknown command"
    end
    response = %{
              response_type: "in_channel",
              text: message
            }
    json conn, response
  end

  defp check_token(conn, _) do
    token = conn.params["token"]
    unless token && token == Application.get_env(:mestatus, :slack)[:token] do
      conn |> put_status(400) |> halt
    else
      conn
    end
  end
end