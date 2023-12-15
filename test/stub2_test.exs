defmodule Stub2Test do
  use ExUnit.Case, async: true

  test "stub" do
    Hello.stub(fn conn ->
      Plug.Conn.send_resp(conn, 200, "hello 2")
    end)

    assert Hello.hello().body == "hello 2"

    Task.async(fn ->
      assert Hello.hello().body == "hello 2"
    end)
    |> Task.await()
  end
end
