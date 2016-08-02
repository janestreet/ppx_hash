
module F (Hash : Hash_intf.S) = struct

  type state = Hash.state
  type 'a folder = state -> 'a -> state

  let hash_fold_unit s () = s

  let hash_fold_int      = Hash.fold_int
  let hash_fold_int64    = Hash.fold_int64
  let hash_fold_float    = Hash.fold_float
  let hash_fold_string   = Hash.fold_string

  let as_int f s x = hash_fold_int s (f x)

  (* This ignores the sign bit on 32-bit architectures, but it's unlikely to lead to
     frequent collisions (min_value colliding with 0 is the most likely one).  *)
  let hash_fold_int32        = as_int Int32.to_int

  let hash_fold_char         = as_int Char.code
  let hash_fold_bool         = as_int (function true -> 1 | false -> 0)

  let hash_fold_nativeint s x = hash_fold_int64 s (Int64.of_nativeint x)

  let hash_fold_option hash_fold_elem s = function
    | None -> hash_fold_int s 0
    | Some x -> hash_fold_elem (hash_fold_int s 1) x

  let rec hash_fold_list_body hash_fold_elem s list =
    match list with
    | [] -> s
    | x::xs -> hash_fold_list_body hash_fold_elem (hash_fold_elem s x) xs

  let hash_fold_list hash_fold_elem s list =
    (* The [length] of the list must be incorporated into the hash-state so values of
       types such as [unit list] - ([], [()], [();()],..) are hashed differently. *)
    (* The [length] must come before the elements to avoid a violation of the rule
       enforced by Perfect_hash. *)
    let s = hash_fold_int s (List.length list) in
    let s = hash_fold_list_body hash_fold_elem s list in
    s

  let hash_fold_lazy_t hash_fold_elem s x =
    hash_fold_elem s (Lazy.force x)

  let hash_fold_ref_frozen hash_fold_elem s x = hash_fold_elem s (!x)

  let rec hash_fold_array_frozen_i hash_fold_elem s array i =
    if i = Array.length array
    then s
    else
      let e = Array.unsafe_get array i in
      hash_fold_array_frozen_i hash_fold_elem (hash_fold_elem s e) array (i + 1)

  let hash_fold_array_frozen hash_fold_elem s array =
    hash_fold_array_frozen_i
      (* [length] must be incorporated for arrays, as it is for lists. See comment above *)
      hash_fold_elem (hash_fold_int s (Array.length array)) array 0

end
