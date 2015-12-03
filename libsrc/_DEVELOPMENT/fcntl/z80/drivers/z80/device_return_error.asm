
SECTION code_driver
SECTION code_driver_general

PUBLIC device_return_error

EXTERN error_zc, error_mc

device_return_error:

   ; enter :  a =  1     indicates error state
   ;               other indicates eof
   ;
   ; exit  : hl =  0 for error state
   ;            = -1 for eof
   ;         carry set
   ;
   ; uses  : af, hl

   dec a
   jp z, error_zc              ; error
   
   jp error_mc                 ; eof
