
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FFLUSH

asm_fflush_unlocked:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;
   ;         if success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         if stream is in error state
   ;         if write failed
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : all except ix

