open Ppx_type_conv.Std
open Ppx_hash_expander_lib.Std

module Expand = Expand_folding_style

let (_set : Type_conv.t list) = [
  Type_conv.add
    "hash_fold"
    ~extension:(fun ~loc:_ ~path:_ ty -> Expand.hash_fold_core_type ty);
  Type_conv.add
    "hash"
    ~str_type_decl:(Type_conv.Generator.make_noarg Expand.str_type_decl ~attributes:Expand.str_attributes)
    ~sig_type_decl:(Type_conv.Generator.make_noarg Expand.sig_type_decl)
    ~extension:(fun ~loc:_ ~path:_ ty -> Expand.hash_core_type ty);
]
