defmodule PingPong do

  def start do
    {:ok, pid} = Task.start(fn -> loop() end)
    Process.register(pid, :ping_pong_app)
  end

  defp loop do
    receive do
      {:ok, "pong", pid} -> ping(:from, pid) 
      {:ok, "ping", pid} -> pong(:from, pid)
    end
    loop()
  end

  def stop do
    Process.exit(:ping_pong_app, :kill)
  end

  def ping do
    send(:ping_pong_app, {:ok, "ping", self()})
    await()
  end
  defp ping(:from, pid) do
    send(pid, {:ok, "ping", self()})
  end

  def pong do
    send(:ping_pong_app, {:ok, "pong", self()})
    await()
  end
  defp pong(:from, pid) do
    send(pid, {:ok, "pong", self()})
  end

  defp await do
    receive do
      {:ok, message, pid} -> 
        message 
        |> IO.puts
        pid
        |> IO.inspect
    end
  end
end
