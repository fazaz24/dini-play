# Nasheed SaaS Example

This is a minimal example of a SaaS platform for hosting and managing nasheeds.
It provides a simple REST API built with Express.

## Setup

```bash
npm install
node index.js
```

The server exposes the following endpoints:

- `GET /nasheeds` – list available nasheeds
- `POST /nasheeds` – add a new nasheed (JSON body with `title` and `url`)

This is a basic starting point. In a real application, you would add user
authentication, file storage, and a database to persist data.
