defmodule HordeBackgroundJob.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: HordeBackgroundJob.Worker.start_link(arg)
      # {HordeBackgroundJob.Worker, arg}
      {Cluster.Supervisor, [topologies(), [name: HordeBackgroundJob.ClusterSupervisor]]},
      HordeBackgroundJob.HordeRegistry,
      HordeBackgroundJob.HordeSupervisor,
      HordeBackgroundJob.NodeObserver,
      {HordeBackgroundJob.DatabaseCleaner.Starter,
        [name: HordeBackgroundJob.DatabaseCleaner, timeout: :timer.seconds(2)]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HordeBackgroundJob.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp topologies do
    [
      horde_background_job: [
        strategy: Cluster.Strategy.Gossip,
        config: [
          if_addr: "127.0.0.3",
          secret: "kleblanc"
        ]
      ]
    ]
  end
end
