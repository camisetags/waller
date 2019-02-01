# defmodule MyApp.Redix do
#   @pool_size 5

#   def child_spec(_args) do
#     # Specs for the Redix connections.
#     children =
#       for i <- 0..(@pool_size - 1) do
#         Supervisor.child_spec({Redix, name: :"redix_#{i}"}, id: {Redix, i})
#       end

#     # Spec for the supervisor that will supervise the Redix connections.
#     %{
#       id: RedixSupervisor,
#       type: :supervisor,
#       start: {Supervisor, :start_link, [children, [strategy: :one_for_one]]}
#     }
#   end

#   def command(command) do
#     Redix.command(:"redix_#{random_index()}", command)
#   end

#   defp random_index() do
#     rem(System.unique_integer([:positive]), @pool_size)
#   end
# end

# defmodule Waller.RedixPool do
#   use Supervisor

#   @redis_connection_params host: Application.get_env(:waller, :redix_pool)[:host]
#   # @redis_connection_params host: "redis"

#   def start_link(initial_val) do
#     Supervisor.start_link(__MODULE__, initial_val)
#   end

#   def init([]) do
#     pool_opts = [
#       name: {:local, :redix_poolboy},
#       worker_module: Redix,
#       size: 10,
#       max_overflow: 5
#     ]

#     children = [
#       :poolboy.child_spec(:redix_poolboy, pool_opts, @redis_connection_params)
#     ]

#     supervise(children, strategy: :one_for_one, name: __MODULE__)
#   end

#   def command(command) do
#     :poolboy.transaction(:redix_poolboy, &Redix.command(&1, command))
#   end

#   def pipeline(commands) do
#     :poolboy.transaction(:redix_poolboy, &Redix.pipeline(&1, commands))
#   end
# end
