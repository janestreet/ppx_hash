include Hash_intf.S
  with type state      = private int (** allow optimizations for immediate type *)
   and type seed       = int
   and type hash_value = int

external create_seeded  : seed            -> state = "%identity"                [@@noalloc]
external fold_int64     : state -> int64  -> state = "internalhash_fold_int64"  [@@noalloc]
external fold_int       : state -> int    -> state = "internalhash_fold_int"    [@@noalloc]
external fold_float     : state -> float  -> state = "internalhash_fold_float"  [@@noalloc]
external fold_string    : state -> string -> state = "internalhash_fold_string" [@@noalloc]
external get_hash_value : state -> hash_value      = "internalhash_get_hash_value" [@@noalloc]
