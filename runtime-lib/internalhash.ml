
let description = "internalhash"

type state = int
type hash_value = int
type seed = int

external create_seeded  : seed            -> state = "%identity"                   "noalloc"
external fold_int64     : state -> int64  -> state = "internalhash_fold_int64"     "noalloc"
external fold_int       : state -> int    -> state = "internalhash_fold_int"       "noalloc"
external fold_float     : state -> float  -> state = "internalhash_fold_float"     "noalloc"
external fold_string    : state -> string -> state = "internalhash_fold_string"    "noalloc"
external get_hash_value : state -> hash_value      = "internalhash_get_hash_value" "noalloc"

let alloc () = create_seeded 0

let reset ?(seed=0) _t = create_seeded seed

module For_tests = struct
  let compare_state = compare
  let state_to_string = string_of_int
end
