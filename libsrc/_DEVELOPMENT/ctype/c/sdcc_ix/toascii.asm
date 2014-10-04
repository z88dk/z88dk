
; int toascii(int c)

SECTION seg_code_ctype

PUBLIC _toascii

_toascii:

   pop af
   pop hl
   
   push hl
   push af

   ld h,0
   res 7,l
   
   ret
