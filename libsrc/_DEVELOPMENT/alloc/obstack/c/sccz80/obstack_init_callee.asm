
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

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_init_callee

EXTERN asm_obstack_init

obstack_init_callee:

   pop hl
   pop bc
   pop de
   push hl
   
   jp asm_obstack_init
