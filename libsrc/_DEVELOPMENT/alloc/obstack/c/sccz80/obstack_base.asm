
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_base(struct obstack *ob)
;
; Returns the address of the currently growing object.
;
; ===============================================================

SECTION seg_code_obstack

PUBLIC obstack_base

obstack_base:

   INCLUDE "alloc/obstack/z80/asm_obstack_base.asm"
