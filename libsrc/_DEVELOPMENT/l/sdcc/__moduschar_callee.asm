
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __moduschar_callee

EXTERN __divuschar_callee_0

__moduschar_callee:

   ; mixed 8-bit mod
   ;
   ; enter : stack = divisor (unsigned byte), dividend (signed byte), ret
   ;
   ; exit  : hl = remainder
   ;         de = quotient

   pop af
   pop hl
   push af
   
   call __divuschar_callee_0

   ex de,hl
   ret
