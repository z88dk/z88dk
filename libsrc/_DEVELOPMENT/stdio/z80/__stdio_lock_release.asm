
SECTION seg_code_stdio

PUBLIC __stdio_lock_release

EXTERN asm_mtx_unlock

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
   
   ld e,ixl
   ld d,ixh                    ; de = FILE *
   
   ld hl,7
   add hl,de                   ; hl = & FILE->mtx_t
   
   call asm_mtx_unlock

   pop hl
   pop de
   pop bc
   pop af
   
   ret
