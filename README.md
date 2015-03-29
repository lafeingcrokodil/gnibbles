# Gnibbles

Snake game based on [GNOME Nibbles](https://wiki.gnome.org/Apps/Nibbles).

### Requirements

- compass gem must be installed for node-compass middleware to work

### Environment Variables

- BUILDPACK_URL: https://github.com/ddollar/heroku-buildpack-multi.git (needed if deploying to Heroku)
- PORT: e.g. 8080 (optional)
- NODE_ENV: e.g. "development" or "production" (doesn't really make a difference currently)
- DEBUG: e.g. "*" or "server,game" (filters console output)
