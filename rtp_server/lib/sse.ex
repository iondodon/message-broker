defmodule RtpServer.Sse do
  @moduledoc """
  TODO: Ruleset for weather

  Requirments
  - Process events as they come
  - Have a group of workers and a supervisor
  - Dynamically change the number of actors depending on the load
  - In case of panic message, kill the worker actor then restart
  - Have enpoints, one for average temperature, another for average humidity, and for weather
  """

  import Plug.Conn
  use Plug.Router

  plug Plug.Parsers, parsers: [:json],
                      pass:  ["application/json"],
                      json_decoder: Poison

  require Logger

  @lambda 11
  @panic_prob 0.01

  @help %{parameters: [:temperature_sensors_celsius,
                        :humidity_sensors_percent,
                        :wind_speed_sensors_kmh,
                        :athm_pressure_sensor_mmhg,
                        :light_sensor_analog,
                        :unix_timestamp_us],
          general_description: "To start streaming data, access the /iot, /sensors and /legacy_sensors routes. Data is in SSE/EventSource format. Sensor readings are sharded among the 3 routes, approximate join them on the timestamp field, +- 2 (100 usec).",
          the_weather_forecast_rules: [
              "if temperature < -2 and light < 128 and athm_pressure < 720 then SNOW",
              "if temperature < -2 and light > 128 and athm_pressure < 680 then WET_SNOW",
              "if temperature < -8 then SNOW",
              "if temperature < -15 and wind_speed > 45 then BLIZZARD",
              "if temperature > 0 and athm_pressure < 710 and humidity > 70 and wind_speed < 20 then SLIGHT_RAIN",
              "if temperature > 0 and athm_pressure < 690 and humidity > 70 and wind_speed > 20 then HEAVY_RAIN",
              "if temperature > 30 and athm_pressure < 770 and humidity > 80 and light > 192 then HOT",
              "if temperature > 30 and athm_pressure < 770 and humidity > 50 and light > 192 and wind_speed > 35 then CONVECTION_OVEN",
              "if temperature > 25 and athm_pressure < 750 and humidity > 70 and light < 192 and wind_speed < 10 then WARM",
              "if temperature > 25 and athm_pressure < 750 and humidity > 70 and light < 192 and wind_speed > 10 then SLIGHT_BREEZE",
              "if light < 128 then CLOUDY",
              "if temperature > 30 and athm_pressure < 660 and humidity > 85 and wind_speed > 45 then MONSOON",
              "if nothing matches then JUST_A_NORMAL_DAY"
          ]}

  plug :match
  plug :dispatch


  get "/iot" do
    Logger.info "Start connection on /iot"

    conn = put_resp_header(conn, "content-type", "text/event-stream")
    conn = send_chunked(conn, 200)

    time_scale = 5

    stream_loop(conn, time_scale, fn -> RtpServer.Messages.make_message_type_one end)

    conn
  end

  get "/sensors" do
    Logger.info "Start connection on /sensors"

    conn = put_resp_header(conn, "content-type", "text/event-stream")
    conn = send_chunked(conn, 200)

    time_scale = 5

    stream_loop(conn, time_scale, fn -> RtpServer.Messages.make_message_type_two end)

    conn
  end

  get "/legacy_sensors" do
    Logger.info "Start connection on /legacy_sensors"

    conn = put_resp_header(conn, "content-type", "text/event-stream")
    conn = send_chunked(conn, 200)

    time_scale = 5

    stream_loop(conn, time_scale, fn -> RtpServer.Messages.make_message_type_three end)

    conn
  end

  get "/help" do
    Logger.info "Start connection"

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Poison.encode!(@help))
  end

  defp sse_send_message(conn, message) do
    chunk(conn, "event: \"message\"\n\ndata: {\"message\": #{message}}\n\n")
  end


  defp stream_loop(conn, scale, msg_maker) when is_function(msg_maker, 0) do
    msecs = round(@lambda * :math.exp(- @lambda * :random.uniform) * scale)

    for _ <- 1..100 do
      msg = if :random.uniform > @panic_prob, do: msg_maker.(), else: "panic"
      sse_send_message(conn, msg)
      :timer.sleep(msecs)
    end

    stream_loop(conn, scale, msg_maker)
  end
end
