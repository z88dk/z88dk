
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FSETPOS

asm_fsetpos_unlocked:

   ; enter :   ix = FILE *
   ;           hl = fpos_t *pos
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
