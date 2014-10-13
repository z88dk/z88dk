
SECTION seg_code_stdio

PUBLIC __stdio_lock_acquire

EXTERN asm0_flockfile

defc __stdio_lock_acquire = asm0_flockfile

   ; Acquire the FILE lock
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         carry set if failed to acquire
   ;
   ; uses  : af
