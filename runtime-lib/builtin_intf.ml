module type S = sig

  type state
  type 'a folder = state -> 'a -> state

  val hash_fold_nativeint    : nativeint     folder
  val hash_fold_int64        : int64         folder
  val hash_fold_int32        : int32         folder
  val hash_fold_char         : char          folder
  val hash_fold_int          : int           folder
  val hash_fold_bool         : bool          folder
  val hash_fold_string       : string        folder
  val hash_fold_float        : float         folder
  val hash_fold_unit         : unit          folder

  val hash_fold_option       : 'a folder -> 'a option  folder
  val hash_fold_list         : 'a folder -> 'a list    folder
  val hash_fold_lazy_t       : 'a folder -> 'a lazy_t  folder

  (* Hash support for [array] and [ref] is provided, but is potentially DANGEROUS, since
     it incorporates the current contents of the array/ref into the hash value.  Because
     of this we add a [_with_hashing] suffix to the function name.

     Hash support for [string] is also potentially DANGEROUS, but strings are mutated less
     often, so we don't append [_with_hashing] to it.

     Also note that we don't support [bytes].
  *)

  val hash_fold_ref_with_hashing : 'a folder -> 'a ref folder
  val hash_fold_array_with_hashing : 'a folder -> 'a array folder

end
