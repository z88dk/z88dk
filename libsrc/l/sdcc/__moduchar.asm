
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __moduchar

EXTERN __divuchar_0

__moduchar:

   ; unsigned 8-bit mod
   ;
   ; enter : stack = divisor (byte), dividend (byte), ret
   ;
   ; exit  : hl = remainder
   ;         de = quotient

   ; note: the fast integer math library has a fast 8x8 divide but it
   ;       is unknown at this time whether sdcc expects 16-bit results     

   ld hl,5
   call __divuchar_0
   
   ex de,hl
   ret
