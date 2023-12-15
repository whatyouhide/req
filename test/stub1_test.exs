defmodule Stub1Test do
  use ExUnit.Case, async: true

  setup do
    Hello.stub(Hello.DefaultStub)
  end

  test "stub" do
    assert Hello.hello().body == "hello"

    Task.async(fn ->
      assert Hello.hello().body == "hello"
    end)
    |> Task.await()
  end
end
