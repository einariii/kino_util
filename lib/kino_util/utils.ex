defmodule KinoUtil.Utils do
  def cpu_util() do
    :cpu_sup.util() |> round()
  end

  def mem_util() do
    result = :memsup.get_system_memory_data()
    total = result[:total_memory]
    used = total - result[:free_memory]
    used_percent = round(used / total * 100)

    used_percent
  end

  def check_gpu() do
    :os.cmd('nvidia-smi')
    |> List.to_string()
    # Need better check
    |> String.contains?("not found")
    |> Kernel.not()
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
    # mem_used = values["mem_used"] |> Kernel./(1.0e3) |> round()
    # mem_total = values["mem_total"] |> Kernel./(1.0e3) |> round()

    {util_gpu, util_mem}
  end
end
