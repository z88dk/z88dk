
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FEOF

asm_feof_unlocked:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         if stream is at eof
   ;
   ;            hl = non-zero
   ;            nz flag set
   ;
   ;         if stream is not at eof
   ;
   ;            hl = 0
   ;            z flag set
   ;
   ; uses  : af, hl
