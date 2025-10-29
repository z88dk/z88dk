
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __muluschar_callee

EXTERN __mulsuchar_callee_0

__muluschar_callee:

   ; 8-bit mixed multiply
   ;
   ; enter : stack = multiplicand (byte), multiplicand (signed byte), ret
   ;
   ; exit  : hl = 16-bit product

   pop af
   pop hl
   push af
   
   ld e,l
   ld l,h
   
   jp __mulsuchar_callee_0
