
XLIB error_mnc

   pop hl
   
error_mnc:

   ; set hl=-1
   ; reset carry flag

   ld hl,-1
   
   scf
   ccf
   ret
