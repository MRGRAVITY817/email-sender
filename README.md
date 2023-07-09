# Sender

Practice Elixir `Task` module.

## WIL from this project

- Create `.iex.exs` file to define default value that can be used in iex.

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
