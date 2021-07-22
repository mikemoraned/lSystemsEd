# Fly.io

## Create

Create app:

    flyctl apps create lsystems-houseofmoran --builder dockerfile --no-config

## Deploy

Deploy app (this will use the settings in `fly.toml`):

    flyctl deploy

Open app:

    flyctl open

## Domains / SSL

Get IPs:

    flyctl ips list

Add the `v4` IP as an `A` record and the `v6` IP as the `AAAA` record

Once that has propagated, create the cert for the domain:

    flyctl certs create lsystems.houseofmoran.com

Show status:

    flyctl certs show lsystems.houseofmoran.com