defmodule Mestatus.UserStatusTest do
  use Mestatus.ModelCase

  alias Mestatus.UserStatus

  @valid_attrs %{status: "some content", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserStatus.changeset(%UserStatus{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserStatus.changeset(%UserStatus{}, @invalid_attrs)
    refute changeset.valid?
  end
end
