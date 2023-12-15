defmodule Req.Stub do
  if Code.ensure_loaded?(Plug.Test) do
    def defstub(stub) do
      Mox.defmock(stub, for: Req.Stub.API)
    end
  else
    def defstub(_stub) do
      Logger.error("""
      Could not find mox dependency. Please add it:

          {:mox, "~> 1.0"}
      """)

      raise "missing mox dependency"
    end
  end

  def stub(stub, plug) when is_function(plug, 1) do
    Mox.stub(stub, :call, plug)
    :ok
  end

  def stub(stub, plug) when is_atom(plug) do
    Mox.stub(stub, :call, &plug.call(&1, []))
    :ok
  end
end

defmodule Req.Stub.Plug do
  @moduledoc false

  def init(stub), do: stub

  def call(conn, stub) do
    stub.call(conn)
  rescue
    Mox.UnexpectedCallError ->
      raise "no stub defined for #{inspect(stub)} in process #{inspect(self())}"
      :ok
  end
end

defmodule Req.Stub.API do
  @moduledoc false

  @callback call(Plug.Conn.t()) :: Plug.Conn.t()
end
