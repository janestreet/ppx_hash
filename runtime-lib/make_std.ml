(*
  This is the interface to the runtime support for [ppx_hash].

  The [ppx_hash] syntax extension supports: [@@deriving hash] and [%hash_fold: TYPE] and [%hash: TYPE]

  For type [t] a function [hash_fold_t] of type [Hash.state -> t -> Hash.state] is generated.

  The generated [hash_fold_<T>] function is compositional, following the structure of the
  type; allowing user overrides at every level. This is in contrast to ocaml's builtin
  polymorphic hashing [Hashtbl.hash] which ignores user overrides.

  The generator also provides a direct hash-function [hash] (named [hash_<T>] when <T> != "t")
  of type: [t -> Hash.hash_value] as a wrapper around the hash-fold function.

  The folding hash function can be accessed as [%hash_fold: TYPE]
  The direct hash function can be accessed as [%hash: TYPE]
*)

module F (Hash : Hash_intf.S) : sig

  module Hash : Hash_intf.Full
    with type hash_value = Hash.hash_value
     and type state      = Hash.state
     and type seed       = Hash.seed

end = struct

  module Hash = struct
    include Hash

    type 'a folder = state -> 'a -> state

    let create ?seed () = reset ?seed (alloc ())

    module Builtin = Folding.F(Hash)

    let run ?seed folder x =
      Hash.get_hash_value (folder (Hash.reset ?seed (Hash.alloc ())) x)

  end

end
