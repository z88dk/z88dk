
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
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   INCLUDE "../../z80/asm_obstack_init.asm"
