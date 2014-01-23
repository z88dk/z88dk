
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FERROR

asm_ferror_unlocked:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         carry reset
   ;
   ;         if stream in error state
   ;
   ;            hl = non-zero
   ;            nz flag set
   ;
   ;         if stream is error free
   ;
   ;            hl = 0
   ;            z flag set
   ;
   ; uses  : af, hl
