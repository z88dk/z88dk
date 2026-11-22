
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_lock_tryacquire

EXTERN asm_mtx_trylock, l_offset_ix_de

__stdio_lock_tryacquire:

   ; Try to acquire the FILE lock but don't block
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         carry set if failed to acquire
   ;
   ; uses  : af
   
   push bc
   push de
   push hl

   ld hl,7
   call l_offset_ix_de         ; hl = & FILE->mtx_t
   
   call asm_mtx_trylock        ; lock stream
   
   pop hl
   pop de
   pop bc
   
   ret
