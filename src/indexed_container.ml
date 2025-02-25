include Indexed_container_intf

let with_return = With_return.with_return

let iteri ~fold t ~f =
  ignore
    (fold t ~init:0 ~f:(fun i x ->
       f i x;
       i + 1)
     : int)
;;

let foldi ~fold t ~init ~f =
  let i = ref 0 in
  fold t ~init ~f:(fun acc v ->
    let acc = f !i acc v in
    i := !i + 1;
    acc) [@nontail]
;;

let counti ~foldi t ~f =
  foldi t ~init:0 ~f:(fun i n a -> if f i a then n + 1 else n) [@nontail]
;;

let existsi ~iteri c ~f =
  with_return (fun r ->
    iteri c ~f:(fun i x -> if f i x then r.return true);
    false) [@nontail]
;;

let for_alli ~iteri c ~f =
  with_return (fun r ->
    iteri c ~f:(fun i x -> if not (f i x) then r.return false);
    true) [@nontail]
;;

let find_mapi ~iteri t ~f =
  with_return (fun r ->
    iteri t ~f:(fun i x ->
      match f i x with
      | None -> ()
      | Some _ as res -> r.return res);
    None) [@nontail]
;;

let findi ~iteri c ~f =
  with_return (fun r ->
    iteri c ~f:(fun i x -> if f i x then r.return (Some (i, x)));
    None) [@nontail]
;;

module Make_gen (T : sig
    include Container_intf.Make_gen_arg

    val iteri : [ `Define_using_fold | `Custom of ('a t, 'a elt) iteri ]
    val foldi : [ `Define_using_fold | `Custom of ('a t, 'a elt, _) foldi ]
  end) : Generic with type 'a t := 'a T.t with type 'a elt := 'a T.elt = struct
  include Container.Make_gen (T)

  let iteri =
    match T.iteri with
    | `Custom iteri -> iteri
    | `Define_using_fold -> fun t ~f -> iteri ~fold t ~f
  ;;

  let foldi =
    match T.foldi with
    | `Custom foldi -> foldi
    | `Define_using_fold -> fun t ~init ~f -> foldi ~fold t ~init ~f
  ;;

  let counti t ~f = counti ~foldi t ~f
  let existsi t ~f = existsi ~iteri t ~f
  let for_alli t ~f = for_alli ~iteri t ~f
  let find_mapi t ~f = find_mapi ~iteri t ~f
  let findi t ~f = findi ~iteri t ~f
end

module Make (T : Make_arg) = struct
  module C = Container.Make (T)

  (* Not part of [Container.Generic]. *)
  let mem = C.mem

  include Make_gen (struct
      include T

      type 'a t = 'a T.t
      type 'a elt = 'a
    end)
end

module Make0 (T : Make0_arg) = struct
  module C = Container.Make0 (T)

  (* Not part of [Container.Generic]. *)
  let mem = C.mem

  include Make_gen (struct
      include T

      type 'a t = T.t
      type 'a elt = T.Elt.t
    end)
end
