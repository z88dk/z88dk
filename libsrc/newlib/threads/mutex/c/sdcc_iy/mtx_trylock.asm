
; int mtx_trylock(mtx_t *m)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _mtx_trylock

EXTERN asm_mtx_trylock

_mtx_trylock:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_mtx_trylock
