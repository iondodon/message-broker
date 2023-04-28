defmodule RtpServer.Messages do
  def make_message_type_one() do
    "{\"wind_speed_sensor_1\": #{:random.uniform * 50},\"wind_speed_sensor_2\": #{:random.uniform * 50},\"atmo_pressure_sensor_1\": #{:random.uniform * 200 + 600},\"atmo_pressure_sensor_2\": #{:random.uniform * 200 + 600},\"unix_timestamp_100us\": #{Integer.floor_div (DateTime.to_unix DateTime.utc_now, :microsecond), 100}}"
  end

  def make_message_type_two() do
    "{\"light_sensor_1\": #{Float.round(:random.uniform * 256)},\"light_sensor_2\": #{Float.round(:random.uniform * 256)},\"unix_timestamp_100us\": #{Integer.floor_div (DateTime.to_unix DateTime.utc_now, :microsecond), 100}}"
  end

  def make_message_type_three() do
    String.replace("""
    \"<SensorReadings unix_timestamp_100us=\'#{Integer.floor_div (DateTime.to_unix DateTime.utc_now, :microsecond), 100}\'>
      <humidity_percent>
        <value>#{:random.uniform * 100}</value>
        <value>#{:random.uniform * 100}</value>
      </humidity_percent>
      <temperature_celsius>
        <value>#{:random.uniform * 60 - 20}</value>
        <value>#{:random.uniform * 60 - 20}</value>
      </temperature_celsius>
    </SensorReadings>\"
    """, "\n", "")
  end
end
