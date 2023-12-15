defmodule Stub1Test do
  use ExUnit.Case, async: true

  test "stub" do
    Req.Stub.stub_default(Hello.Stub)

    assert Hello.hello().body == "hello"

    Task.async(fn ->
      assert Hello.hello().body == "hello"
    end)
    |> Task.await()
  end
end
