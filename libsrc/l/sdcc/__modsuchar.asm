
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __modsuchar

EXTERN __divsuchar_0

__modsuchar:

   ; mixed 8-bit mod
   ;
   ; enter : stack = divisor (signed byte), dividend (unsigned byte), ret
   ;
   ; exit  : hl = remainder
   ;         de = quotient

   ld hl,5
   call __divsuchar_0
   
   ex de,hl
   ret
