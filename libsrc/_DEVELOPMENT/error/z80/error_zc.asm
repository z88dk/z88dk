
XLIB error_zc

   pop hl

error_zc:

   ; set hl=0
   ; set carry flag

   ld hl,0
   
   scf
   ret
