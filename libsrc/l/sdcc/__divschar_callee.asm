
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __divschar_callee
PUBLIC __divschar_callee_0, __divschar_callee_1

EXTERN l_divs_16_16x16

__divschar_callee:

   ; signed 8-bit division
   ;
   ; enter : stack = divisor (signed byte), dividend (signed byte), ret
   ; 
   ; exit  : hl = quotient
   ;         de = remainder

   ; note: the fast integer math library has a fast 8x8 divide but it
   ;       is unknown at this time whether sdcc expects 16-bit results     
   
   pop af
   pop hl
   push af

__divschar_callee_0:

   ld e,h
   
   ; e = divisor
   ; l = dividend
   
   ld a,l
   add a,a
   sbc a,a
   ld h,a                      ; hl = dividend

__divschar_callee_1:

   ld a,e
   add a,a
   sbc a,a
   ld d,a                      ; de = divisor
   
   jp l_divs_16_16x16
