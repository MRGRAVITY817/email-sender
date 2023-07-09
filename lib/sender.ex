defmodule Sender do
  def send_email(email) do
    Enum.random(1000..3000) |> Process.sleep()

    IO.puts("Email to #{email} sent")

    {:ok, "email_sent"}
  end

  def notify_all(emails) do
    emails
    |> Task.async_stream(&send_email/1)
    |> Enum.to_list()
  end
end
