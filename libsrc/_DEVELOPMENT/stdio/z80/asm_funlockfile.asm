
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF __STDIO_LOCK_RELEASE

; ===============================================================
; Jan 2014
; ===============================================================
; 
; void funlockfile(FILE *file)
;
; Reduce lock count of file by one.
;
; ===============================================================

asm_funlockfile:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ; uses  : none
