(* This module is included in [Import].  It is aimed at modules that define the standard
   combinators for [sexp_of], [of_sexp], [compare] and [hash] and are included in
   [Import]. *)

include (
  Shadow_stdlib :
    module type of struct
    include Shadow_stdlib
  end
  with type 'a ref := 'a ref
  with type ('a, 'b, 'c) format := ('a, 'b, 'c) format
  with type ('a, 'b, 'c, 'd) format4 := ('a, 'b, 'c, 'd) format4
  with type ('a, 'b, 'c, 'd, 'e, 'f) format6 := ('a, 'b, 'c, 'd, 'e, 'f) format6
  (* These modules are redefined in Base *)
  with module Array := Shadow_stdlib.Array
  with module Atomic := Shadow_stdlib.Atomic
  with module Bool := Shadow_stdlib.Bool
  with module Buffer := Shadow_stdlib.Buffer
  with module Bytes := Shadow_stdlib.Bytes
  with module Char := Shadow_stdlib.Char
  with module Either := Shadow_stdlib.Either
  with module Float := Shadow_stdlib.Float
  with module Hashtbl := Shadow_stdlib.Hashtbl
  with module Int := Shadow_stdlib.Int
  with module Int32 := Shadow_stdlib.Int32
  with module Int64 := Shadow_stdlib.Int64
  with module Lazy := Shadow_stdlib.Lazy
  with module List := Shadow_stdlib.List
  with module Map := Shadow_stdlib.Map
  with module Nativeint := Shadow_stdlib.Nativeint
  with module Option := Shadow_stdlib.Option
  with module Printf := Shadow_stdlib.Printf
  with module Queue := Shadow_stdlib.Queue
  with module Random := Shadow_stdlib.Random
  with module Result := Shadow_stdlib.Result
  with module Set := Shadow_stdlib.Set
  with module Stack := Shadow_stdlib.Stack
  with module String := Shadow_stdlib.String
  with module Sys := Shadow_stdlib.Sys
  with module Uchar := Shadow_stdlib.Uchar
  with module Unit := Shadow_stdlib.Unit)
  [@ocaml.warning "-3"]

type 'a ref = 'a Caml.ref = { mutable contents : 'a }

(* Reshuffle [Caml] so that we choose the modules using labels when available. *)
module Caml = struct
  include Caml
  include Caml.StdLabels
  include Caml.MoreLabels
end

external ( |> ) : 'a -> ('a -> 'b) -> 'b = "%revapply"

(* These need to be declared as an external to get the lazy behavior *)
external ( && ) : (bool[@local_opt]) -> (bool[@local_opt]) -> bool = "%sequand"
external ( || ) : (bool[@local_opt]) -> (bool[@local_opt]) -> bool = "%sequor"
external not : (bool[@local_opt]) -> bool = "%boolnot"

(* We use [Obj.magic] here as other implementations generate a conditional jump and the
   performance difference is noticeable. *)
let bool_to_int (x : bool) : int = Caml.Obj.magic x

(* This need to be declared as an external for the warnings to work properly *)
external ignore : _ -> unit = "%ignore"

let ( != ) = Caml.( != )
let ( * ) = Caml.( * )
let ( ** ) = Caml.( ** )
let ( *. ) = Caml.( *. )
let ( + ) = Caml.( + )
let ( +. ) = Caml.( +. )
let ( - ) = Caml.( - )
let ( -. ) = Caml.( -. )
let ( / ) = Caml.( / )
let ( /. ) = Caml.( /. )

module Poly = Poly0 (** @canonical Base.Poly *)

module Int_replace_polymorphic_compare = struct
  (* Declared as externals so that the compiler skips the caml_apply_X wrapping even when
     compiling without cross library inlining. *)
  external ( = ) : (int[@local_opt]) -> (int[@local_opt]) -> bool = "%equal"
  external ( <> ) : (int[@local_opt]) -> (int[@local_opt]) -> bool = "%notequal"
  external ( < ) : (int[@local_opt]) -> (int[@local_opt]) -> bool = "%lessthan"
  external ( > ) : (int[@local_opt]) -> (int[@local_opt]) -> bool = "%greaterthan"
  external ( <= ) : (int[@local_opt]) -> (int[@local_opt]) -> bool = "%lessequal"
  external ( >= ) : (int[@local_opt]) -> (int[@local_opt]) -> bool = "%greaterequal"
  external compare : (int[@local_opt]) -> (int[@local_opt]) -> int = "%compare"
  external equal : (int[@local_opt]) -> (int[@local_opt]) -> bool = "%equal"

  let ascending (x : int) y = compare x y
  let descending (x : int) y = compare y x
  let max (x : int) y = if x >= y then x else y
  let min (x : int) y = if x <= y then x else y
end

include Int_replace_polymorphic_compare

module Int32_replace_polymorphic_compare = struct
  let ( < ) (x : Caml.Int32.t) y = Poly.( < ) x y
  let ( <= ) (x : Caml.Int32.t) y = Poly.( <= ) x y
  let ( <> ) (x : Caml.Int32.t) y = Poly.( <> ) x y
  let ( = ) (x : Caml.Int32.t) y = Poly.( = ) x y
  let ( > ) (x : Caml.Int32.t) y = Poly.( > ) x y
  let ( >= ) (x : Caml.Int32.t) y = Poly.( >= ) x y
  let ascending (x : Caml.Int32.t) y = Poly.ascending x y
  let descending (x : Caml.Int32.t) y = Poly.descending x y
  let compare (x : Caml.Int32.t) y = Poly.compare x y
  let equal (x : Caml.Int32.t) y = Poly.equal x y
  let max (x : Caml.Int32.t) y = if x >= y then x else y
  let min (x : Caml.Int32.t) y = if x <= y then x else y
end

module Int64_replace_polymorphic_compare = struct
  (* Declared as externals so that the compiler skips the caml_apply_X wrapping even when
     compiling without cross library inlining. *)
  external ( = )
    :  (Caml.Int64.t[@local_opt])
    -> (Caml.Int64.t[@local_opt])
    -> bool
    = "%equal"

  external ( <> )
    :  (Caml.Int64.t[@local_opt])
    -> (Caml.Int64.t[@local_opt])
    -> bool
    = "%notequal"

  external ( < )
    :  (Caml.Int64.t[@local_opt])
    -> (Caml.Int64.t[@local_opt])
    -> bool
    = "%lessthan"

  external ( > )
    :  (Caml.Int64.t[@local_opt])
    -> (Caml.Int64.t[@local_opt])
    -> bool
    = "%greaterthan"

  external ( <= )
    :  (Caml.Int64.t[@local_opt])
    -> (Caml.Int64.t[@local_opt])
    -> bool
    = "%lessequal"

  external ( >= )
    :  (Caml.Int64.t[@local_opt])
    -> (Caml.Int64.t[@local_opt])
    -> bool
    = "%greaterequal"

  external compare
    :  (Caml.Int64.t[@local_opt])
    -> (Caml.Int64.t[@local_opt])
    -> int
    = "%compare"

  external equal
    :  (Caml.Int64.t[@local_opt])
    -> (Caml.Int64.t[@local_opt])
    -> bool
    = "%equal"

  let ascending (x : Caml.Int64.t) y = Poly.ascending x y
  let descending (x : Caml.Int64.t) y = Poly.descending x y
  let max (x : Caml.Int64.t) y = if x >= y then x else y
  let min (x : Caml.Int64.t) y = if x <= y then x else y
end

module Nativeint_replace_polymorphic_compare = struct
  let ( < ) (x : Caml.Nativeint.t) y = Poly.( < ) x y
  let ( <= ) (x : Caml.Nativeint.t) y = Poly.( <= ) x y
  let ( <> ) (x : Caml.Nativeint.t) y = Poly.( <> ) x y
  let ( = ) (x : Caml.Nativeint.t) y = Poly.( = ) x y
  let ( > ) (x : Caml.Nativeint.t) y = Poly.( > ) x y
  let ( >= ) (x : Caml.Nativeint.t) y = Poly.( >= ) x y
  let ascending (x : Caml.Nativeint.t) y = Poly.ascending x y
  let descending (x : Caml.Nativeint.t) y = Poly.descending x y
  let compare (x : Caml.Nativeint.t) y = Poly.compare x y
  let equal (x : Caml.Nativeint.t) y = Poly.equal x y
  let max (x : Caml.Nativeint.t) y = if x >= y then x else y
  let min (x : Caml.Nativeint.t) y = if x <= y then x else y
end

module Bool_replace_polymorphic_compare = struct
  let ( < ) (x : bool) y = Poly.( < ) x y
  let ( <= ) (x : bool) y = Poly.( <= ) x y
  let ( <> ) (x : bool) y = Poly.( <> ) x y
  let ( = ) (x : bool) y = Poly.( = ) x y
  let ( > ) (x : bool) y = Poly.( > ) x y
  let ( >= ) (x : bool) y = Poly.( >= ) x y
  let ascending (x : bool) y = Poly.ascending x y
  let descending (x : bool) y = Poly.descending x y
  let compare (x : bool) y = Poly.compare x y
  let equal (x : bool) y = Poly.equal x y
  let max (x : bool) y = if x >= y then x else y
  let min (x : bool) y = if x <= y then x else y
end

module Char_replace_polymorphic_compare = struct
  let ( < ) (x : char) y = Poly.( < ) x y
  let ( <= ) (x : char) y = Poly.( <= ) x y
  let ( <> ) (x : char) y = Poly.( <> ) x y
  let ( = ) (x : char) y = Poly.( = ) x y
  let ( > ) (x : char) y = Poly.( > ) x y
  let ( >= ) (x : char) y = Poly.( >= ) x y
  let ascending (x : char) y = Poly.ascending x y
  let descending (x : char) y = Poly.descending x y
  let compare (x : char) y = Poly.compare x y
  let equal (x : char) y = Poly.equal x y
  let max (x : char) y = if x >= y then x else y
  let min (x : char) y = if x <= y then x else y
end

module Uchar_replace_polymorphic_compare = struct
  let i x = Caml.Uchar.to_int x
  let ( < ) (x : Caml.Uchar.t) y = Int_replace_polymorphic_compare.( < ) (i x) (i y)
  let ( <= ) (x : Caml.Uchar.t) y = Int_replace_polymorphic_compare.( <= ) (i x) (i y)
  let ( <> ) (x : Caml.Uchar.t) y = Int_replace_polymorphic_compare.( <> ) (i x) (i y)
  let ( = ) (x : Caml.Uchar.t) y = Int_replace_polymorphic_compare.( = ) (i x) (i y)
  let ( > ) (x : Caml.Uchar.t) y = Int_replace_polymorphic_compare.( > ) (i x) (i y)
  let ( >= ) (x : Caml.Uchar.t) y = Int_replace_polymorphic_compare.( >= ) (i x) (i y)

  let ascending (x : Caml.Uchar.t) y =
    Int_replace_polymorphic_compare.ascending (i x) (i y)
  ;;

  let descending (x : Caml.Uchar.t) y =
    Int_replace_polymorphic_compare.descending (i x) (i y)
  ;;

  let compare (x : Caml.Uchar.t) y = Int_replace_polymorphic_compare.compare (i x) (i y)
  let equal (x : Caml.Uchar.t) y = Int_replace_polymorphic_compare.equal (i x) (i y)
  let max (x : Caml.Uchar.t) y = if x >= y then x else y
  let min (x : Caml.Uchar.t) y = if x <= y then x else y
end

module Float_replace_polymorphic_compare = struct
  let ( < ) (x : float) y = Poly.( < ) x y
  let ( <= ) (x : float) y = Poly.( <= ) x y
  let ( <> ) (x : float) y = Poly.( <> ) x y
  let ( = ) (x : float) y = Poly.( = ) x y
  let ( > ) (x : float) y = Poly.( > ) x y
  let ( >= ) (x : float) y = Poly.( >= ) x y
  let ascending (x : float) y = Poly.ascending x y
  let descending (x : float) y = Poly.descending x y
  let compare (x : float) y = Poly.compare x y
  let equal (x : float) y = Poly.equal x y
  let max (x : float) y = if x >= y then x else y
  let min (x : float) y = if x <= y then x else y
end

module String_replace_polymorphic_compare = struct
  let ( < ) (x : string) y = Poly.( < ) x y
  let ( <= ) (x : string) y = Poly.( <= ) x y
  let ( <> ) (x : string) y = Poly.( <> ) x y
  let ( = ) (x : string) y = Poly.( = ) x y
  let ( > ) (x : string) y = Poly.( > ) x y
  let ( >= ) (x : string) y = Poly.( >= ) x y
  let ascending (x : string) y = Poly.ascending x y
  let descending (x : string) y = Poly.descending x y
  let compare (x : string) y = Poly.compare x y
  let equal (x : string) y = Poly.equal x y
  let max (x : string) y = if x >= y then x else y
  let min (x : string) y = if x <= y then x else y
end

module Bytes_replace_polymorphic_compare = struct
  let ( < ) (x : bytes) y = Poly.( < ) x y
  let ( <= ) (x : bytes) y = Poly.( <= ) x y
  let ( <> ) (x : bytes) y = Poly.( <> ) x y
  let ( = ) (x : bytes) y = Poly.( = ) x y
  let ( > ) (x : bytes) y = Poly.( > ) x y
  let ( >= ) (x : bytes) y = Poly.( >= ) x y
  let ascending (x : bytes) y = Poly.ascending x y
  let descending (x : bytes) y = Poly.descending x y
  let compare (x : bytes) y = Poly.compare x y
  let equal (x : bytes) y = Poly.equal x y
  let max (x : bytes) y = if x >= y then x else y
  let min (x : bytes) y = if x <= y then x else y
end

(* This needs to be defined as an external so that the compiler can specialize it as a
   direct set or caml_modify *)
external ( := ) : ('a ref[@local_opt]) -> 'a -> unit = "%setfield0"

(* These need to be defined as an external otherwise the compiler won't unbox
   references *)
external ( ! ) : ('a ref[@local_opt]) -> 'a = "%field0"
external ref : 'a -> ('a ref[@local_opt]) = "%makemutable"

let ( @ ) = Caml.( @ )
let ( ^ ) = Caml.( ^ )
let ( ~- ) = Caml.( ~- )
let ( ~-. ) = Caml.( ~-. )
let ( asr ) = Caml.( asr )
let ( land ) = Caml.( land )
let lnot = Caml.lnot
let ( lor ) = Caml.( lor )
let ( lsl ) = Caml.( lsl )
let ( lsr ) = Caml.( lsr )
let ( lxor ) = Caml.( lxor )
let ( mod ) = Caml.( mod )
let abs = Caml.abs
let failwith = Caml.failwith
let fst = Caml.fst
let invalid_arg = Caml.invalid_arg
let snd = Caml.snd

(* [raise] needs to be defined as an external as the compiler automatically replaces
   '%raise' by '%reraise' when appropriate. *)
external raise : exn -> _ = "%raise"

let phys_equal = Caml.( == )

external decr : (int ref[@local_opt]) -> unit = "%decr"
external incr : (int ref[@local_opt]) -> unit = "%incr"

(* used by sexp_conv, which float0 depends on through option *)
let float_of_string = Caml.float_of_string

(* [am_testing] is used in a few places to behave differently when in testing mode, such
   as in [random.ml].  [am_testing] is implemented using [Base_am_testing], a weak C/js
   primitive that returns [false], but when linking an inline-test-runner executable, is
   overridden by another primitive that returns [true]. *)
external am_testing : unit -> bool = "Base_am_testing"

let am_testing = am_testing ()
