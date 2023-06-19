defmodule KinoUtil do
  use Kino.JS, assets_path: "lib/assets"
  use Kino.JS.Live
  use Kino.SmartCell, name: "System utilization"
  alias KinoUtil.Utils

  @init_interval 100
  @update_interval 1000

  @impl true
  def init(attrs, ctx) do
    fields = %{
      "cpu_percent" => attrs["cpu_percent"] || 0,
      "mem_percent" => attrs["mem_percent"] || 0
      # "gpu_percent" => attrs["gpu_percent"] || 0,
      # "gpu_mem_percent" => attrs["gpu_mem_percent"] || 0,
    }

    Process.send_after(self(), "show_gpu", @init_interval)
    Process.send_after(self(), "update", @init_interval)
    {:ok, assign(ctx, fields: fields)}
  end

  @impl true
  def handle_info("show_gpu", ctx) do
    has_gpu = Utils.check_gpu()
    broadcast_event(ctx, "show_gpu", has_gpu)
    {:noreply, ctx}
  end

  @impl true
  def handle_info("update", ctx) do
    cpu_util = Utils.cpu_util()
    mem_util = Utils.mem_util()

    # {gpu_util, gpu_mem_util} =
    #   if ctx.assigns.fields["show_gpu"] do
    #     Utils.gpu_util()
    #   else
    #     {0, 0}
    #   end

    fields =
      Map.merge(ctx.assigns.fields, %{
        "cpu_percent" => cpu_util,
        "mem_percent" => mem_util
        # "gpu_percent" => gpu_util,
        # "gpu_mem_percent" => gpu_mem_util
      })

    IO.inspect(fields, label: "fields update")

    ctx = assign(ctx, fields: fields)
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
