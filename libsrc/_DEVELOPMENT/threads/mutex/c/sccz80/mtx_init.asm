
; int mtx_init(mtx_t *mtx, int type)

SECTION seg_code_mutex

PUBLIC mtx_init

EXTERN asm_mtx_init

mtx_init:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_mtx_init
