defmodule GlobalBackgroundJob.DatabaseCleaner.Starter do
  use GenServer

  alias GlobalBackgroundJob.DatabaseCleaner

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl GenServer
  def init(opts) do
    pid = start_and_monitor(opts)

    {:ok, {pid, opts}}
  end

  @impl GenServer
  def handle_info({:DOWN, _, :process, pid, _reason}, {pid, opts} = state) do
    {:noreply, {start_and_monitor(opts), opts}}
  end

  defp start_and_monitor(opts) do
    pid =
      case GenServer.start_link(DatabaseCleaner, opts, name: {:global, DatabaseCleaner}) do
        {:ok, pid} ->
          pid

        {:error, {:already_started, pid}} ->
          pid
      end

    Process.monitor(pid)

    pid
  end
end
