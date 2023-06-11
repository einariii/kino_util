defmodule KinoUtil.Utils do
  def cpu_util() do
    :cpu_sup.util() |> Float.round(1)
  end

  def mem_util() do
    result = :memsup.get_system_memory_data()
    total = (result[:system_total_memory] / 1.0e9) |> Float.round(1)
    available = (result[:available_memory] / 1.0e9) |> Float.round(1)
    used = (total - available) |> Float.round(1)
    used_percent = (used / total * 100.0) |> Float.round(1)

    {used, used_percent}
  end

  def gpu_util() do
    {result, _} =
      System.cmd("nvidia-smi", [
        "--query-gpu=utilization.gpu,utilization.memory,memory.total,memory.used",
        "--format=csv,noheader,nounits"
      ])

    labels = ["util_gpu", "util_mem", "mem_total", "mem_used"]

    values =
      result
      |> String.trim()
      |> String.split(", ")
      |> Enum.map(fn x -> String.to_integer(x) end)
      |> (fn x -> Enum.zip(labels, x) end).()
      |> Enum.into(%{})

    util_gpu = values["util_gpu"]
    util_mem = values["util_mem"]
    mem_used = values["mem_used"] |> Kernel./(1.0e3) |> Float.round(1)
    mem_total = values["mem_total"] |> Kernel./(1.0e3) |> Float.round(1)

    {util_gpu, util_mem, mem_used, mem_total}
  end
end
