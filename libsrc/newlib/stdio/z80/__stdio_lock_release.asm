
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_lock_release

EXTERN asm_mtx_unlock, l_offset_ix_de

__stdio_lock_release:

   ; Release the FILE lock
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ; uses  : none

   push af
   push bc
   push de
   push hl
   
   ld hl,7
   call l_offset_ix_de         ; hl = & FILE->mtx_t
   
   call asm_mtx_unlock

   pop hl
   pop de
   pop bc
   pop af
   
   ret
