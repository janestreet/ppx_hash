open Core_kernel.Std

module State : sig
  type t
  include Comparable.S with type t := t
  include Sexpable.S with type t := t
end

include Ppx_hash_lib.Hash_intf.S with type hash_value = int and type seed = unit with type state = State.t
