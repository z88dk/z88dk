
XLIB __stdio_lock_acquire

LIB asm_flockfile

__stdio_lock_acquire:

   jp asm_flockfile

;defc __stdio_lock_acquire = asm_flockfile

   ; Acquire the FILE lock
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         carry set if failed to acquire
   ;
   ; uses  : af
