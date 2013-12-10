
XLIB errno_mc

INCLUDE "../../crt_vars.inc"
LIB error_mc
   
errno_mc:

   ; set errno=hl
   ; set hl=-1
   ; set carry flag

   ld (_errno),hl
   jp error_mc
