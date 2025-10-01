open Ppxlib

let type_extension name f =
  Context_free.Rule.extension
    (Extension.declare
       name
       Core_type
       Ast_pattern.(ptyp __)
       (fun ~loc ~path:_ ty -> f ~loc ty))
;;

let pattern_extension name f =
  Context_free.Rule.extension
    (Extension.declare
       name
       Pattern
       Ast_pattern.(ptyp __)
       (fun ~loc ~path:_ ty -> f ~loc ty))
;;

let () =
  let name = "hash_fold" in
  Deriving.ignore
    (Deriving.add name ~extension:(fun ~loc:_ ~path:_ ty ->
       Ppx_hash_expander.hash_fold_core_type ty));
  Driver.register_transformation
    name
    ~rules:
      [ type_extension name Ppx_hash_expander.hash_fold_type
      ; pattern_extension name Ppx_hash_expander.hash_fold_pattern
      ]
;;

let () =
  let name = "hash" in
  Deriving.ignore
    (Deriving.add
       name
       ~str_type_decl:
         (Deriving.Generator.make
            Deriving.Args.(empty +> flag "portable")
            (fun ~loc ~path tds portable ->
              Ppx_hash_expander.str_type_decl ~loc ~path tds ~portable)
            ~attributes:Ppx_hash_expander.str_attributes)
       ~sig_type_decl:
         (Deriving.Generator.make
            Deriving.Args.(empty +> flag "portable")
            (fun ~loc ~path tds portable ->
              Ppx_hash_expander.sig_type_decl ~loc ~path tds ~portable))
       ~extension:(fun ~loc:_ ~path:_ ty -> Ppx_hash_expander.hash_core_type ty));
  Driver.register_transformation
    name
    ~rules:
      [ type_extension name Ppx_hash_expander.hash_type
      ; pattern_extension name Ppx_hash_expander.hash_pattern
      ]
;;
