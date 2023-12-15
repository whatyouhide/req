# A dummy API client that can be globally configured to be in "stub" mode.
#
# This is only useful when we can't easily pass options to Req.
# Otherwise, pass `plug: plug`.
defmodule Hello do
  def hello(options \\ []) do
    Req.new(
      stub: stub(),
      url: "https://example.com"
    )
    |> Req.request!(options)
  end

  @stub Hello.Stub

  defp stub do
    Application.get_env(:hello, :stub) == true && @stub
  end

  def stub(plug) do
    Req.Stub.stub(@stub, plug)
  end
end
