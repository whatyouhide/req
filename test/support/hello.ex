# A dummy API client that can be globally configured to be in "stub" mode.
# If at the call site, we can pass options, setting `plug: fun` is the
# better way to test it.
defmodule Hello do
  def hello(options \\ []) do
    Req.new(
      stub: Application.get_env(:hello, :stub) == true && Hello.Stub,
      url: "https://example.com"
    )
    |> Req.request!(options)
  end
end
