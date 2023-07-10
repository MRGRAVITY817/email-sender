defmodule Sender do
  def send_email("nihao@world.com" = email) do
    raise "Oops, couldn't send email to #{email}!"
  end

  def send_email(email) do
    Enum.random(1000..3000) |> Process.sleep()

    IO.puts("Email to #{email} sent")

    {:ok, "email_sent"}
  end

  def notify_all(emails) do
    Sender.EmailTaskSupervisor
    |> Task.Supervisor.async_stream_nolink(emails, &send_email/1)
    |> Enum.to_list()
  end
end
