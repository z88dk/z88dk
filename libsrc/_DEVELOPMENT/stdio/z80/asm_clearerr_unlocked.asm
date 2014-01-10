
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_CLEARERR

asm_clearerr_unlocked:

   ; enter : ix = FILE *
   ; 
   ; exit  : ix = FILE *
   ;         hl = 0
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl
