
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int obstack_grow(struct obstack *ob, void *data, size_t size)
;
; Grow the current object by appending size bytes read from
; address data.
;
; ===============================================================

XDEF obstack_grow

obstack_grow:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_grow.asm"
