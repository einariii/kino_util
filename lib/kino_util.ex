defmodule KinoUtil do
  use Kino.JS, assets_path: "lib/assets"
  use Kino.JS.Live
  use Kino.SmartCell, name: "System Utilization"
  alias KinoUtil.Utils

  @interval_init 100
  @interval_update 2_000
  @default_fields %{
    "has_gpu" => false,
    "cpu_percent" => 0,
    "mem_used" => 0,
    "mem_total" => 0,
    "mem_percent" => 0,
    "gpu_percent" => 0,
    "gpu_mem_percent" => 0,
    "gpu_mem_used" => 0,
    "gpu_mem_total" => 0
  }

  @impl true
  def init(attrs, ctx) do
    fields = Map.merge(@default_fields, attrs)

    # Weird behavior if send instead of send_after
    Process.send_after(self(), "check_gpu", @interval_init)
    Process.send_after(self(), "update", @interval_init)
    {:ok, assign(ctx, fields: fields)}
  end

  @impl true
  def handle_info("check_gpu", ctx) do
    fields = ctx.assigns.fields

    has_gpu = Utils.check_gpu()

    Map.merge(fields, %{"has_gpu" => has_gpu})
    broadcast_event(ctx, "has_gpu", has_gpu)
    {:noreply, assign(ctx, fields: fields)}
  end

  @impl true
  def handle_info("update", ctx) do
    fields = ctx.assigns.fields

    cpu_util = Utils.cpu_util()
    {mem_perc, mem_used, mem_total} = Utils.mem_util()

    values = %{
      "cpu_percent" => cpu_util,
      "mem_percent" => mem_perc,
      "mem_used" => mem_used,
      "mem_total" => mem_total
    }

    values =
      if fields["show_gpu"] do
        {gpu_util, gpu_mem_util, gpu_mem_used, gpu_mem_total} = Utils.gpu_util()

        values_gpu = %{
          "gpu_percent" => gpu_util,
          "gpu_mem_percent" => gpu_mem_util,
          "gpu_mem_used" => gpu_mem_used,
          "gpu_mem_total" => gpu_mem_total
        }

        Map.merge(values, values_gpu)
      else
        values
      end

    fields = Map.merge(fields, values)
    ctx = assign(ctx, fields: fields)
    broadcast_event(ctx, "update", fields)
    Process.send_after(self(), "update", @interval_update)
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
