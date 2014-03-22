
XLIB errno_mc

XREF _errno

LIB error_mc
   
errno_mc:

   ; set errno=hl
   ; set hl=-1
   ; set carry flag

   ld (_errno),hl
   jp error_mc
