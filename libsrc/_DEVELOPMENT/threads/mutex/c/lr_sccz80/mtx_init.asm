
; int mtx_init(mtx_t *mtx, int type)

XLIB mtx_init

LIB asm_mtx_init

mtx_init:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_mtx_init
