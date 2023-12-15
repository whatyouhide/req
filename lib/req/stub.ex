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

  def defstub_default(stub, plug) do
    defstub(stub)
    Req.Stub.Server.put_default(stub, plug)
  end

  def stub_default(stub) do
    case Req.Stub.Server.fetch_default(stub) do
      {:ok, plug} ->
        Mox.stub(stub, :call, plug)

      :error ->
        raise "missing default for stub #{inspect(stub)}"
    end

    :ok
  end

  def stub(stub, plug) do
    Mox.stub(stub, :call, plug)
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

defmodule Req.Stub.Server do
  @moduledoc false

  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def put_default(stub, plug) do
    Agent.update(__MODULE__, &Map.put(&1, stub, plug))
  end

  def fetch_default(stub) do
    Agent.get(__MODULE__, &Map.fetch(&1, stub))
  end
end
