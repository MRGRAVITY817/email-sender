# Sender

Learn concurrent data processing in Elixir, by improving and email sender.

## WIL from this project

### `.iex.exs`

- Create `.iex.exs` file to define default value that can be used in iex.

### What is `Task` module?

Elixir's `Task` is awesome for concurrently running one-off function.  
Which means it terminates the allocated process after the callback is done.

### `Task.async/await/yield`

- `owner` - the PID of the process that _started_ the Task process.
- `pid` - the PID of the process itself.
- `ref` - a ref value that you can use to do process monitoring.

```elixir
task = Task.async(fn -> Sender.send_email("hello@world.com") end)

%Task{
  mfa: {:erlang, :apply, 2},
  owner: #PID<0.137.0>,
  pid: #PID<0.157.0>,
  ref: #Reference<0.0.17539.341706125.1453916161.115355>
}

# We can `await` the `async` value, but only within 5 seconds (default).
Task.async(fn -> Sender.send_email("hi@world.com") end) |> Task.await()

# Task.yield can check if async task is still in progress.
# If nil, task is still running. Else, the task is ready.
Task.yield(task)
```

### `Task.async_stream()`

`Task.async_stream(fn, option)` will automatically allocate concurrent jobs according to number of machine cores. Like `Task.await`, by default it waits 5 seconds to operate.

There are some `option`s you can set.

- `max_concurrency`: Numbers of channel to run concurrent task.
- `ordered`: Run tasks in same order as it's given.
- `timeout`: Timeout to await task. Default 5 secs.
- `on_timeout`: What to do after timeout.

### Ignore some of the failed tasks

We can tell _supervisor_ not to crash the parent process when child process crashes. This is called _breaking the link_.

We can break the link with `Task.Supervisor.async_stream_nolink()`.

```elixir
def notify_all(emails) do
  Sender.EmailTaskSupervisor
  |> Task.Supervisor.async_stream_nolink(emails, &send_email/1)
  |> Enum.to_list()
end
```

### Supervisor's strategy for restarting dead process

• `:temporary` option which never restarts processes
• `:transient` will restart child processes, but only when they exit with an error
• :`permanent` always restarts children, keeping them running, even when they try to shut down without an error

### What is `GenServer`?

`Task` is one-off style, if you want a generic server like concurrency then we would use `GenServer`. Unless we explicitly call GenServer to be stopped, it will pertain the job by serving the Elixir server process.

### `GenServer.init()`

This is the very first callback function that is called when we start a GenServer. Keep in mind _not to_ put heavy setups like database fetching in `init()`, since it should be very fast.

To setup some stuffs, you better take a look with `handle_continue()`
