# Dotenvy for OCaml
**Deprecation Warning: I ended up not working on this project any more. Direnv
supports .env, which solves 100% of my planned use case for this project.**

Dotenvy is an OCaml library that reads `.env` file and updates the current
environment.

There are a few preexisting [alternatives](#alternatives), but they
haven't been updated for years and depend on deprecated libraries such as
`uutf`, so this library was created.

It only supports fairly recent versions of the OCaml system. Its API is intended
to be minimal but flexible enough.
## TODO
- [ ] Add support for UTF-8.
- [ ] Implement the proper dotenv syntax specification.
## Alternatives
- <https://github.com/thatportugueseguy/ocaml-dotenv>
- <https://github.com/jordanrmerrick/dotenv>
