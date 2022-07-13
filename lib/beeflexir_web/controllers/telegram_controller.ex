defmodule BeeflexirWeb.TelegramController do
  use BeeflexirWeb, :controller

  @schema %{
    key: [
      type: :string,
      default: ""
    ],
    start: [
      type: :integer,
      min: 0,
      default: 0
    ]
  }

  def index(conn, params) do
    case Want.keywords(params, @schema) do
      {:ok, opts} ->
        render(conn, "value.html", value: increment_by(opts))

      {:error, _reason} ->
        render(conn, "index.html")
    end
  end

  defp increment_by(opts) do
    name = {:via, Registry, {Telegram.Registry, opts[:key], opts[:start]}}

    case Registry.lookup(Telegram.Registry, opts[:key]) do
      [] -> {:ok, _} = Agent.start_link(fn -> opts[:start] end, name: name)
      [{pid, _}] -> pid
    end

    Agent.update(name, &(&1 + 1))
    Agent.get(name, & &1)
  end
end
