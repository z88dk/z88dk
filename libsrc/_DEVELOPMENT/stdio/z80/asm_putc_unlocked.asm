
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FPUTC_UNLOCKED

; ===============================================================
; Jan 2014
; ===============================================================
; 
; int putc_unlocked(int c, FILE *stream)
;
; Write char to stream.
;
; ===============================================================

asm_putc_unlocked:

   ; enter : ix = FILE *
   ;          e = char c
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = char c
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all except ix
