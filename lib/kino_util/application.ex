defmodule KinoUtil.Application do
  use Application

  @impl true
  def start(_type, _args) do
    Kino.SmartCell.register(KinoUtil)

    children = []
    opts = [strategy: :one_for_one, name: KinoUtil.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
