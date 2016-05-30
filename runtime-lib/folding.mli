
(** Builtin folding-style hash functions, abstracted over [Hash_intf.S] *)

module F (Hash : Hash_intf.S) : Builtin_intf.S with type state = Hash.state
