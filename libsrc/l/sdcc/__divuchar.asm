
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __divuchar, __divuchar_0

EXTERN l_divu_16_16x8

__divuchar:

   ; unsigned 8-bit division
   ;
   ; enter : stack = divisor (byte), dividend (byte), ret
   ;
   ; exit  : hl = quotient
   ;         de = remainder

   ; note: the fast integer math library has a fast 8x8 divide but it
   ;       is unknown at this time whether sdcc expects 16-bit results     

   ld hl,3

__divuchar_0:

   add hl,sp
   
   ld e,(hl)                   ; e = divisor
   dec hl
   ld l,(hl)                   ; l = dividend

   ld h,0
   jp l_divu_16_16x8
