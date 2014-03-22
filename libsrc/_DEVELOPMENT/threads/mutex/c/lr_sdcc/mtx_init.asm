
; int mtx_init(mtx_t *mtx, int type)

XDEF mtx_init

mtx_init:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_mtx_init.asm"
