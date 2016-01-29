defmodule Mestatus.UserStatusApi do
  use Mestatus.Web, :controller
  require Logger

  alias Mestatus.UserStatus
  
  #plug :check_token
  
  def create(conn, %{"text" => text, "user_name" => username}) do
    [command, app, note] = String.split(text, ~r{\s}, trim: true, parts: 3)
    message = case command do
      x when x in ~w(intervened done) ->
        params = %{status: command, app: app, note: note, username: username}
        changeset = UserStatus.changeset(%UserStatus{}, params)

        case Repo.insert(changeset) do
          {:ok, user_status} ->
            case user_status.status do
              "intervened" ->
                "Sorry that you are blocked, let me know once you are unblocked by sending done."
              "done" ->
                "Glad to hear you are back to normal life :shark:"
              _ ->
                "Stored your new status."
            end
            
          {:error, changeset} ->
            "There was an issue with setting status."
        end
      "current" ->
        # show current status
        statuses = Repo.all(UserStatus.latest_status)
        for us <- statuses, into: "", do: "#{us.username} is #{us.status} on #{us.app} note: #{us.note}/n"
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