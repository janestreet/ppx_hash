#use "topfind";;
#require "js-build-tools.oasis2opam_install";;

open Oasis2opam_install;;

generate ~package:"ppx_hash"
  [ oasis_lib "ppx_hash"
  ; oasis_lib "ppx_hash_expander_lib"
  ; oasis_lib "ppx_hash_lib"
  ; file "META" ~section:"lib"
  ]
