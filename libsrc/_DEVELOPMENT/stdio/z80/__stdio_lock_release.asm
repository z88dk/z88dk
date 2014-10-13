
SECTION seg_code_stdio

PUBLIC __stdio_lock_release

EXTERN asm0_funlockfile

defc __stdio_lock_release = asm0_funlockfile

   ; Release the FILE lock
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ; uses  : none
