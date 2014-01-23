
XLIB __stdio_lock_release
XDEF asm_funlockfile

LIB asm_mtx_unlock

__stdio_lock_release:
asm_funlockfile:

   ; Release the FILE lock
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ; uses  : bc

   push af
   push de
   push hl
   
   ld e,ixl
   ld d,ixh                    ; de = FILE *
   
   ld hl,7
   add hl,de                   ; hl = & FILE->mtx_t
   
   call asm_mtx_unlock

   pop hl
   pop de
   pop af
   
   ret
