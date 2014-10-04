
; int toascii(int c)

SECTION seg_code_ctype

PUBLIC toascii

toascii:

   ld h,0
   res 7,l
   
   ret
