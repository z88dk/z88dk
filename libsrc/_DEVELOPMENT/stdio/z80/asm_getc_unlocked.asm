
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FGETC

; ===============================================================
; Jan 2014
; ===============================================================
; 
; int getc_unlocked(FILE *stream)
;
; Read char from stream.
;
; ===============================================================

asm_getc_unlocked:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         if success
   ;
   ;            hl = char
   ;            carry reset
   ;
   ;         if fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : all except ix
