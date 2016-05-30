#include <stdint.h>
#include <caml/mlvalues.h>
#include <caml/hash.h>

/* This pretends that the state of the OCaml internal hash function, which is an
   int32, is actually stored in an OCaml int. */

CAMLprim value internalhash_fold_int32(value st, value i)
{
  return Val_long(caml_hash_mix_uint32(Long_val(st), Int32_val(i)));
}

CAMLprim value internalhash_fold_nativeint(value st, value i)
{
  return Val_long(caml_hash_mix_intnat(Long_val(st), Nativeint_val(i)));
}

CAMLprim value internalhash_fold_int64(value st, value i)
{
  return Val_long(caml_hash_mix_int64(Long_val(st), Int64_val(i)));
}

CAMLprim value internalhash_fold_int(value st, value i)
{
  return Val_long(caml_hash_mix_intnat(Long_val(st), Long_val(i)));
}

CAMLprim value internalhash_fold_float(value st, value i)
{
  return Val_long(caml_hash_mix_double(Long_val(st), Double_val(i)));
}

CAMLprim value internalhash_fold_string(value st, value i)
{
  return Val_long(caml_hash_mix_string(Long_val(st), i));
}

/* This code mimics what hashtbl.hash does in OCaml's hash.c */
#define FINAL_MIX(h)                            \
  h ^= h >> 16; \
  h *= 0x85ebca6b; \
  h ^= h >> 13; \
  h *= 0xc2b2ae35; \
  h ^= h >> 16;

CAMLprim value internalhash_get_hash_value(value st)
{
  uint32_t h = Int_val(st);
  FINAL_MIX(h);
  return Val_int(h & 0x3FFFFFFFU); /*30 bits*/
}
