defmodule GlobalBackgroundJob.DatabaseCleaner.Runner do
  require Logger

  def execute do
    random = :rand.uniform(1_000)

    Process.sleep(random)

    Logger.info("#{__MODULE__} #{random} entées supprimées")
  end
end
