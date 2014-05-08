
PUBLIC errno_mc

EXTERN _errno

EXTERN error_mc
   
errno_mc:

   ; set errno=hl
   ; set hl=-1
   ; set carry flag

   ld (_errno),hl
   jp error_mc
