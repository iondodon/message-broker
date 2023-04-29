# message-broker

### Wtach the demo

[![Watch the demo](https://img.youtube.com/vi/eYuetqTuRvw/maxresdefault.jpg)](https://youtu.be/eYuetqTuRvw)

## Overview

This project represents a fault-tolerant message broker built with Elixir. The message broker is responsible for registering subscribers to topics and consuming events from publishers on those topics.

## Components

The repository includes four Elixir applications:

1. `joiner_subscriber_app`
2. `message_broker_app`
3. `remote_listener`
4. `rtp_server`

The `rtp_server` is a server that sends SSE events on three HTTP routes: `/sensors`, `/ion`, and `/legacy_sensors`. These endpoints send events with weather data, such as atmospheric pressure, humidity, light, temperature, and wind speed. The data is distributed across multiple endpoints.

The `remote_listener` application listens for events from the `rtp_server` and publishes them to the `message_broker` under a specific topic (e.g., `/sensors`). The `message_broker_app` receives messages from the publisher and registers them under the topic specified in the event sent by the publisher. If a publisher sends an event with a non-existent topic, the `message_broker` will create it as a new one. Multiple publishers can send events to the `message_broker_app` simultaneously.

Subscriber apps can register with the `message_broker_app` to listen for events on a specific topic or multiple topics. All subscriber apps subscribed to the `/sensors` topic will receive events about sensor data, which originally come from the `rtp_server`, passing through the `remote_listener` and the `message_broker_app`.

The `joiner_subscriber_app` subscribes to the `/sensors` events and gathers them together. It also creates a weather description based on the data received from the `message_broker_app`.
