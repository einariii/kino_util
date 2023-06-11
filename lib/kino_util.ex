defmodule KinoUtil do
  use Kino.JS, assets_path: "lib/assets"
  use Kino.JS.Live
  use Kino.SmartCell, name: "System utilization"
  # alias KinoUtil.Utils

  @impl true
  def handle_connect(ctx) do
    {:ok, %{}, ctx}
  end

  @impl true
  def to_attrs(_), do: %{}

  @impl true
  def to_source(_) do
    quote do
      IO.puts("Testing")
    end
    |> Kino.SmartCell.quoted_to_string()
  end
end
