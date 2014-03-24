
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_init(struct obstack *ob, size_t size)
;
; Create an obstack at address ob, size bytes long.
; Size must be at least seven bytes to hold obstack header.
;
; ===============================================================

XDEF obstack_init

obstack_init:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_init.asm"
