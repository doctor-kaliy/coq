(* Flags used to compile Coq but _not_ plugins (via coq_makefile) *)
module Prefs = struct
  type t = { warn_error : bool }
  let default = { warn_error = true }
end

(** This Makefile is only used in the test-suite now, remove eventually. *)
let write_makefile coqprefix coqlibinstall best_compiler ocamlfind caml_flags coq_caml_flags o () =
  let pr s = Format.fprintf o s in
  pr "###### Coq Test suite configuration ##############################\n";
  pr "#                                                                #\n";
  pr "# This file is generated by the script \"coq_config_to_make\"      #\n";
  pr "# DO NOT EDIT IT !! DO NOT EDIT IT !! DO NOT EDIT IT !!          #\n";
  pr "#                                                                #\n";
  pr "##################################################################\n\n";

  pr "# Paths where Coq is installed\n";
  pr "COQPREFIX=%s\n" coqprefix;
  pr "COQLIBINSTALL=%s\n\n" coqlibinstall;
  pr "# The best compiler: native (=opt) or bytecode (=byte)\n";
  pr "BEST=%s\n\n" best_compiler;
  pr "# Findlib command\n";
  pr "OCAMLFIND=%S\n" ocamlfind;
  pr "# Caml flags\n";
  pr "CAMLFLAGS=%s %s\n" caml_flags coq_caml_flags;
  ()

let coq_warn_error (prefs : Prefs.t) =
    if prefs.warn_error
    then "-warn-error +a"
    else ""

let main () =
  let prefs = Prefs.default in
  let coqprefix = Coq_config.install_prefix in
  let coqlibinstall = Coq_config.coqlib in
  (* EJGA: Good enough approximation *)
  let best_compiler = if Coq_config.has_natdynlink then "opt" else "byte" in
  let ocamlfind = Coq_config.ocamlfind in
  let caml_flags = Coq_config.caml_flags in
  let coq_caml_flags = coq_warn_error prefs in
  Format.printf "@[%a@]@\n%!"
    (write_makefile coqprefix coqlibinstall best_compiler ocamlfind caml_flags coq_caml_flags) ();
  ()

let () = main ()
