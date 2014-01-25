
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FSEEK

asm_fseek_unlocked:

   ; enter :   ix = FILE *
   ;         dehl = offset
   ;            c = whence
   ;
   ; exit  :   ix = FILE *
   ;
   ;         success
   ;
   ;           hl = 0
   ;           carry reset
   ;
   ;         fail
   ;
   ;           hl = -1
   ;           carry set
   ;
   ; uses  : all except ix
