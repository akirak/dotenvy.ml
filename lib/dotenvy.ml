let parse path =
  let ic = open_in path in
  let parse_line = function
    | s when String.length s == 0 -> None
    | s when String.starts_with ~prefix:"#" s -> None
    | s -> (
      match String.index_opt s '=' with
      | None -> failwith "missing '='"
      | Some i ->
          let name = String.sub s 0 i in
          let value = String.sub s (i + 1) (String.length s - i - 1) in
          Some (name, value) )
  in
  try
    let rec loop acc =
      try
        loop
          ( match input_line ic |> String.trim |> parse_line with
          | Some ent -> ent :: acc
          | None -> acc )
      with End_of_file -> List.rev acc
    in
    let lines = loop [] in
    close_in ic ; lines
  with e -> close_in_noerr ic ; raise e

let load ?(override = false) ?(path = ".env") () =
  if Sys.file_exists path then
    let apply_env (name, value) = Unix.putenv name value in
    let env_name str =
      match String.split_on_char '=' str with
      | name :: _ -> name
      | _ -> failwith "invalid environment definition"
    in
    let apply_envs_preserving envs =
      let existing_names =
        Unix.environment () |> Array.to_list |> List.map env_name
      in
      List.filter (fun (name, _) -> not (List.mem name existing_names)) envs
      |> List.iter apply_env
    in
    let apply_envs =
      if override then List.iter apply_env else apply_envs_preserving
    in
    parse path |> apply_envs
  else ()
