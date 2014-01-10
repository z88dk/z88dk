
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF __STDIO_LOCK_ACQUIRE

asm_flockfile:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         carry set if failed to acquire (not normal operation)
   ;
   ; uses  : af
