
XLIB __stdio_lock_tryacquire

LIB asm_mtx_trylock

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
   
   ld e,ixl
   ld d,ixh                    ; de = FILE *
   
   ld hl,7
   add hl,de                   ; hl = & FILE->mtx_t
   
   call asm_mtx_trylock        ; lock stream
   
   pop hl
   pop de
   pop bc
   
   ret
