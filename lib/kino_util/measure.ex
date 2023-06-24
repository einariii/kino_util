defmodule KinoUtil.Measure do
  def cpu_util() do
    :cpu_sup.util() |> round()
  end

  def mem_util() do
    result = :memsup.get_system_memory_data()
    total = result[:total_memory] / 1024 / 1024 / 1024
    used = total - result[:free_memory] / 1024 / 1024 / 1024
    perc = round(used / total * 100)

    {perc, used, total}
  end

  def check_gpu() do
    :os.cmd('nvidia-smi')
    |> List.to_string()
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

    {values["util_gpu"], values["util_mem"], values["mem_used"], values["mem_total"]}
  end
end
