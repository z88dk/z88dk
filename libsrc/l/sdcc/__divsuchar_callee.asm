
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __divsuchar_callee

EXTERN __divschar_callee_1
   
__divsuchar_callee:

   ; mixed 8-bit division
   ;
   ; enter : stack = divisor (signed byte), dividend (unsigned byte), ret
   ;
   ; exit  : hl = quotient
   ;         de = remainder

   ; note: the fast integer math library has a fast 8x8 divide but it
   ;       is unknown at this time whether sdcc expects 16-bit results     

   pop af
   pop hl
   push af

   ld e,h
   
   ; e = divisor
   ; l = dividend
   
   ; must promote to 16-bits
   
   ld h,0                      ; hl = signed dividend (+ve)
   jp __divschar_callee_1
