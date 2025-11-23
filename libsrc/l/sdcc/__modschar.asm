
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __modschar

EXTERN __divschar_0

__modschar:

   ; signed 8-bit mod
   ;
   ; enter : divisor (byte), dividend (byte), ret
   ;
   ; exit  : hl = remainder
   ;         de = quotient

   ; note: the fast integer math library has a fast 8x8 divide but it
   ;       is unknown at this time whether sdcc expects 16-bit results     

   ld hl,5
   call __divschar_0
   
   ex de,hl
   ret
