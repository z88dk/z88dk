
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __modschar_callee

EXTERN __divschar_callee_0

__modschar_callee:

   ; signed 8-bit mod
   ;
   ; enter : divisor (byte), dividend (byte), ret
   ;
   ; exit  : hl = remainder
   ;         de = quotient

   ; note: the fast integer math library has a fast 8x8 divide but it
   ;       is unknown at this time whether sdcc expects 16-bit results     

   pop af
   pop hl
   push af
   
   call __divschar_callee_0
   
   ex de,hl
   ret
