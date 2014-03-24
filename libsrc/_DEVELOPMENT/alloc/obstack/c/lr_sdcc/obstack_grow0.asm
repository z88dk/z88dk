
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int obstack_grow0(struct obstack *ob, void *data, size_t size)
;
; Grow the current object by appending size bytes read from
; address data followed by a NUL char.
;
; ===============================================================

XDEF obstack_grow0

obstack_grow0:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_grow0.asm"
