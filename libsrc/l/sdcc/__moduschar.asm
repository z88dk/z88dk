
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __moduschar

EXTERN __divuschar_0

__moduschar:

   ; mixed 8-bit mod
   ;
   ; enter : stack = divisor (unsigned byte), dividend (signed byte), ret
   ;
   ; exit  : hl = remainder
   ;         de = quotient

   ld hl,5
   call __divuschar_0
   
   ex de,hl
   ret
