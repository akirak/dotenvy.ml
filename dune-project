(lang dune 3.16)

(generate_opam_files false)

(authors "Akira Komamura <akira.komamura@gmail.com>")
(maintainers "Akira Komamura <akira.komamura@gmail.com>")
(license LICENSE)

(package
 (name dotenvy)
 (version 0.1.0)
 (synopsis "Load environment variables from .env files")
 (description "A library to load environment variables from .env files for OCaml projects")
 (allow_empty)
 (depends
  (ocaml (>= 4.08.0))
  (dune (>= 3.16))
  unix
  (alcotest :with-test)))
