let test_simple _ =
  Dotenvy.load ~path:"simple.env" () ;
  Alcotest.(check string) "same string" "value" (Sys.getenv "TEST_SIMPLE") ;
  Alcotest.(check (option string))
    "none" None
    (Sys.getenv_opt "#TEST_COMMENT")

let test_preserving _ =
  Unix.putenv "TEST_PRESERVING" "original value" ;
  Dotenvy.load ~path:"preserving.env" ~override:false () ;
  Alcotest.(check string)
    "same string" "original value"
    (Unix.getenv "TEST_PRESERVING")

let test_overriding _ =
  Unix.putenv "TEST_OVERRIDING" "original value" ;
  Dotenvy.load ~path:"overriding.env" ~override:true () ;
  Alcotest.(check string)
    "same string" "updated value"
    (Unix.getenv "TEST_OVERRIDING")

let () =
  let open Alcotest in
  run "dotenvy"
    [ ( "load"
      , [ test_case "simple" `Slow test_simple
        ; test_case "preserving" `Slow test_preserving
        ; test_case "overriding" `Slow test_overriding ] ) ]
