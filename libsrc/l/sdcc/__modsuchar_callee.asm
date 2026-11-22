
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __modsuchar_callee

EXTERN __divschar_callee_1

__modsuchar_callee:

   ; mixed 8-bit mod
   ;
   ; enter : stack = divisor (signed byte), dividend (unsigned byte), ret
   ;
   ; exit  : hl = remainder
   ;         de = quotient

   pop af
   pop hl
   push af

   ld e,h
   
   ; e = divisor
   ; l = dividend
   
   ; must promote to 16-bits
   
   ld h,0                      ; hl = signed dividend (+ve)

   call __divschar_callee_1
   
   ex de,hl
   ret
