@@ portable

include Base.Hash.S with type seed = string and type hash_value = int

(** [Siphash] uses first 16 chars of the [seed] string to initialize/reset the hash state,
    padding it to the right with zero bytes if it's too short. The rest of the string is
    discarded. *)

external alloc : unit -> state = "siphash_alloc"
external reset_to : state -> seed -> state = "siphash_reset" [@@noalloc]

external fold_int64_u
  :  state
  -> (int64#[@unboxed])
  -> state
  @@ portable
  = "siphash_fold_int64" "siphash_fold_uint64"
[@@noalloc]

external fold_int : state -> int -> state = "siphash_fold_int" [@@noalloc]

external fold_float_u
  :  state
  -> (float#[@unboxed])
  -> state
  @@ portable
  = "siphash_fold_float" "siphash_fold_ufloat"
[@@noalloc]

external fold_string : state -> string -> state = "siphash_fold_string" [@@noalloc]
external get_hash_value : state -> int = "siphash_get_hash_value" [@@noalloc]
