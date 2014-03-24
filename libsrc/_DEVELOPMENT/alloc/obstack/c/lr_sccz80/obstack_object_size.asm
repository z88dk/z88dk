
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t obstack_object_size(struct obstack *ob)
;
; Return the size in bytes of the currently growing object.
;
; ===============================================================

XDEF obstack_object_size

obstack_object_size:

   INCLUDE "alloc/obstack/z80/asm_obstack_object_size.asm"
