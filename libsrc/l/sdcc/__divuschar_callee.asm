
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __divuschar_callee
PUBLIC __divuschar_callee_0

EXTERN l_divs_16_16x16

__divuschar_callee:

   ; mixed 8-bit division
   ;
   ; enter : stack = divisor (unsigned byte), dividend (signed byte), ret
   ;
   ; exit  : hl = quotient
   ;         de = remainder

   ; note: the fast integer math library has a fast 8x8 divide but it
   ;       is unknown at this time whether sdcc expects 16-bit results     

   pop af
   pop hl
   push af

__divuschar_callee_0:

   ld e,h
   
   ; e = divisor
   ; l = dividend
   
   ; must promote to 16-bits

   ld d,0
   
   ld a,l
   add a,a
   sbc a,a
   ld h,a                      ; hl = signed dividend
   
   jp l_divs_16_16x16
