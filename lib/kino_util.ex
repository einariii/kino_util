defmodule KinoUtil do
  use Kino.JS, assets_path: "lib/assets"
  use Kino.JS.Live
  use Kino.SmartCell, name: "System utilization"
  alias KinoUtil.Utils

  @update_interval 1000

  @impl true
  def init(attrs, ctx) do
    has_gpu = Utils.check_gpu()
    broadcast_event(ctx, "hasGpu", has_gpu)

    fields = %{
      "cpu_percent" => attrs["cpu_percent"] || 0,
      "mem_percent" => attrs["mem_percent"] || 0,
      "gpu_percent" => attrs["gpu_percent"] || 0,
      "gpu_mem_percent" => attrs["gpu_mem_percent"] || 0
    }

    Process.send(self(), "update", [])
    {:ok, assign(ctx, fields: fields)}
  end

  @impl true
  def handle_info("update", ctx) do
    cpu_util = Utils.cpu_util()
    mem_util = Utils.mem_util()

    {gpu_util, gpu_mem_util} =
      if ctx.assigns.fields["show_gpu"] do
        Utils.gpu_util()
      else
        {0, 0}
      end

    IO.inspect(ctx.assigns.fields, label: "pre merge")
    fields =
      Map.merge(ctx.assigns.fields, %{
        "cpu_percent" => cpu_util,
        "mem_percent" => mem_util,
        "gpu_percent" => gpu_util,
        "gpu_mem_percent" => gpu_mem_util
      })

    ctx = assign(ctx, fields: fields)
    IO.inspect(ctx.assigns.fields, label: "post merge")
    broadcast_event(ctx, "update", fields)
    Process.send_after(self(), "update", @update_interval)
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
      IO.puts("to_source not implemented")
    end
    |> Kino.SmartCell.quoted_to_string()
  end
end
