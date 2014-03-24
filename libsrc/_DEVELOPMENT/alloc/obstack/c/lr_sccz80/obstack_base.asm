
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_base(struct obstack *ob)
;
; Returns the address of the currently growing object.
;
; ===============================================================

XDEF obstack_base

obstack_base:

   INCLUDE "alloc/obstack/z80/asm_obstack_base.asm"
