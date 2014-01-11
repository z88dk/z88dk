
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FPUTS

asm_fputs_unlocked:

   ; enter : ix = FILE *
   ;         hl = char *s
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = strlen(s)
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all except ix
