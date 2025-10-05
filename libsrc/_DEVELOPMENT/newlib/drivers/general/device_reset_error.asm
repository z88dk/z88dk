
SECTION code_driver
SECTION code_driver_general

PUBLIC device_reset_error

device_reset_error:

   ; enter : ix+6 = device flags, bits 1:0 device state
   ;
   ; exit  : device error flags cleared
   ;
   ; uses  : af
   
   ld a,(ix+6)
   and $fc
   ld (ix+6),a
   
   ret
