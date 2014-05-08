
PUBLIC error_mc

   pop hl
   
error_mc:

   ; set hl=-1
   ; set carry flag

   ld hl,-1
   
   scf
   ret
