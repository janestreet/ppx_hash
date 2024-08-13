(* ppx_hash can be used with a custom hash type if you shadow Ppx_hash_lib *)

module Specs = struct
  let description = "dummy"

  type state = unit

  let f () _ = ()
  let fold_int = f
  let fold_int64 = f
  let fold_float = f
  let fold_string = f

  type seed = unit

  let alloc () = ()
  let reset ?seed:_ () = ()

  type hash_value = unit

  let get_hash_value () = ()

  module For_tests = struct
    let compare_state () () = assert false
    let state_to_string () = assert false
  end
end

module Ppx_hash_lib = struct
  module Std = struct
    module Hash = Ppx_hash_lib.Std.Hash.F (Specs)
  end

  include Ppx_hash_lib.F (struct
      type hash_state = Std.Hash.state
      type hash_value = Std.Hash.hash_value
    end)
end

open Ppx_hash_lib.Std.Hash.Builtin

module M : sig
  type t =
    { x : int
    ; y : string list
    }
  [@@deriving hash]
end = struct
  type t =
    { x : int
    ; y : string list
    }
  [@@deriving hash]
end

let () = M.hash { x = 5; y = [ "x" ] }
