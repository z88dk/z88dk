
; int toascii(int c)

XLIB _toascii

_toascii:

   pop af
   pop hl
   
   push hl
   push af

   ld h,0
   res 7,l
   
   ret
