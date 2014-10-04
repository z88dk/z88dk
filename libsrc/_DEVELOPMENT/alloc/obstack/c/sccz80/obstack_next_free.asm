
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_next_free(struct obstack *ob)
;
; Returns address of next available byte in the obstack.
;
; ===============================================================

SECTION seg_code_obstack

PUBLIC obstack_next_free

obstack_next_free:

   INCLUDE "alloc/obstack/z80/asm_obstack_next_free.asm"
