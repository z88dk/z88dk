
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FTELL

asm_ftell_unlocked:

   ; enter :   ix = FILE *
   ;
   ; exit  :   ix = FILE *
   ;
   ;         success
   ;
   ;           dehl = current file position
   ;           carry reset
   ;
   ;         fail
   ;
   ;           dehl = -1
   ;           carry set
   ;
   ; uses  : all except ix
