
XLIB __stdio_lock_release

LIB asm0_funlockfile

__stdio_lock_release:

   jp asm0_funlockfile

;defc __stdio_lock_release = asm_funlockfile

   ; Release the FILE lock
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ; uses  : none
