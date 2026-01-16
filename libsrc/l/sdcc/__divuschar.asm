
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __divuschar
PUBLIC __divuschar_0

EXTERN l_divs_16_16x16

__divuschar:

   ; mixed 8-bit division
   ;
   ; enter : stack = divisor (unsigned byte), dividend (signed byte), ret
   ;
   ; exit  : hl = quotient
   ;         de = remainder

   ; note: the fast integer math library has a fast 8x8 divide but it
   ;       is unknown at this time whether sdcc expects 16-bit results     

   ld hl,3

__divuschar_0:

   ld d,h                      ; d = 0
   add hl,sp
   
   ld e,(hl)                   ; de = signed divisor (+ve)
   dec hl
   ld l,(hl)                   ; l = signed dividend
   
   ; must promote to 16-bits
   
   ld a,l
   add a,a
   sbc a,a
   ld h,a                      ; hl = signed dividend
   
   jp l_divs_16_16x16
