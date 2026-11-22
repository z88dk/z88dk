
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __divschar
PUBLIC __divschar_0, __divschar_1

EXTERN l_divs_16_16x16

__divschar:

   ; signed 8-bit division
   ;
   ; enter : stack = divisor (signed byte), dividend (signed byte), ret
   ; 
   ; exit  : hl = quotient
   ;         de = remainder

   ; note: the fast integer math library has a fast 8x8 divide but it
   ;       is unknown at this time whether sdcc expects 16-bit results     
   
   ld hl,3

__divschar_0:

   add hl,sp
   
   ld e,(hl)                   ; e = divisor
   dec hl
   ld l,(hl)                   ; l = dividend

   ld a,l
   add a,a
   sbc a,a
   ld h,a                      ; hl = dividend

__divschar_1:

   ld a,e
   add a,a
   sbc a,a
   ld d,a                      ; de = divisor
   
   jp l_divs_16_16x16
