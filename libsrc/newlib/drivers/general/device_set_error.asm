
SECTION code_driver
SECTION code_driver_general

PUBLIC device_set_error

device_set_error:

   ; enter : ix+6 = device flags, bits 1:0 device state
   ;
   ;           hl =  0 indicates error state
   ;                -1 indicates eof
   ;
   ; exit  : device flags set
   ;         carry flag set
   ;
   ; uses  : af
   
   ld a,l
   and $03
   xor $01
   or (ix+6)
   ld (ix+6),a
   
   scf
   ret
