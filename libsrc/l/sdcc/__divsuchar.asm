
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __divsuchar
PUBLIC __divsuchar_0

EXTERN __divschar_1
   
__divsuchar:

   ; mixed 8-bit division
   ;
   ; enter : stack = divisor (signed byte), dividend (unsigned byte), ret
   ;
   ; exit  : hl = quotient
   ;         de = remainder

   ; note: the fast integer math library has a fast 8x8 divide but it
   ;       is unknown at this time whether sdcc expects 16-bit results     

   ld hl,3

__divsuchar_0:

   add hl,sp
   
   ld e,(hl)                   ; e = signed divisor
   dec hl
   ld l,(hl)                   ; l = unsigned dividend
   
   ; must promote to 16-bits
   
   ld h,0                      ; hl = signed dividend (+ve)
   jp __divschar_1
