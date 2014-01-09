
XLIB __stdio_lock_acquire

LIB asm_mtx_lock

__stdio_lock_acquire:

   ; Acquire the FILE lock
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
   
   call asm_mtx_lock           ; lock stream
   
   pop hl
   pop de
   pop bc
   
   ret
