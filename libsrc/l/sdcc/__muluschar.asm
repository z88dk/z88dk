
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __muluschar

EXTERN __mulsuchar_0

__muluschar:

   ; 8-bit mixed multiply
   ;
   ; enter : stack = multiplicand (byte), multiplicand (signed byte), ret
   ;
   ; exit  : hl = 16-bit product
   
   ld hl,3
   add hl,sp
   
   ld e,(hl)
   dec hl
   ld l,(hl)
   
   ex de,hl
   jp __mulsuchar_0
