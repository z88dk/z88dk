
XLIB error_znc

   pop hl
   
error_znc:

   ; set hl=0
   ; reset carry flag

   ld hl,0

   scf
   ccf
   ret
