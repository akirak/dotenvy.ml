val parse : string -> (string * string) list
(** [parse path] reads a dotenv file at [path] and returns environment variables
    defined within the file. *)

val load : ?override:bool -> ?path:string -> unit -> unit
(** [load ~override ~path ()] reads a dotenv file at [path] and updates the
    current environment. By default, [path] is `.env`.

    If an environment variable with of same name is already set in the current
    environment, it won't be updated by default. If and only if [override] is
    `true`, all environment variables will be updated.

    If the specified file doesn't exist, this function doesn't update the
    environment. *)
