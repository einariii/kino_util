defmodule KinoUtil do
  use Kino.JS, assets_path: "lib/assets"
  use Kino.JS.Live
  use Kino.SmartCell, name: "System utilization"
  alias KinoUtil.Utils

  @update 1000

  @impl true
  def init(attrs, ctx) do
    fields = %{
      "cpu_util" => attrs["cpu_util"] || "",
      "mem_used" => attrs["mem_used"] || "",
      "mem_util" => attrs["mem_util"] || ""
      # "cpu_warning" => attrs["cpu_warning"] || "",
    }

    Process.send(self(), "update", [])
    {:ok, assign(ctx, fields: fields)}
  end

  @impl true
  def handle_info("update", ctx) do
    cpu_util = Utils.cpu_util()
    {mem_used, mem_util} = Utils.mem_util()
    # cpu_warning = "red"

    ctx =
      update(
        ctx,
        :fields,
        &Map.merge(&1, %{"cpu_util" => cpu_util, "mem_used" => mem_used, "mem_util" => mem_util})
      )

    broadcast_event(ctx, "update", [cpu_util, mem_used, mem_util])

    Process.send_after(self(), "update", @update)
    {:noreply, ctx}
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, %{fields: ctx.assigns.fields}, ctx}
  end

  @impl true
  def to_attrs(ctx) do
    ctx.assigns.fields
  end

  @impl true
  def to_source(_attrs) do
    quote do
      :ok
    end
    |> Kino.SmartCell.quoted_to_string()
  end
end
