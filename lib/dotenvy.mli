val parse : string -> (string * string) list
(** [parse path] reads a dotenv file at [path] and returns environment variables
    defined within the file. *)

val load : ?override:bool -> ?path:string -> unit -> unit
(** [load ~override ~path ()] reads a dotenv file at [path] and updates the
    current environment. By default, [path] is `.env`.

    By default, the defined environment variables don't override existing ones.
    If and only if [override] is `true`, all environment variables will be
    updated.

    If the specified file doesn't exist, this function doesn't do anything. *)
