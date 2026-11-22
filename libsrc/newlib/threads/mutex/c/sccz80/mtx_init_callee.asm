
; int mtx_init(mtx_t *mtx, int type)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC mtx_init_callee

EXTERN asm_mtx_init

mtx_init_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_mtx_init
