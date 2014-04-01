
; int toascii(int c)

XLIB toascii

toascii:

   pop af
   pop hl
   
   push hl
   push af

   ld h,0
   res 7,l
   
   ret
