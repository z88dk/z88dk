; void __FASTCALL__ *setdefdev(void *driver_function)
; 06.2008 aralbrec

XLIB setdefdev
XREF _zdefdev

.setdefdev

   ; set a new default device
   ;
   ; enter : hl = void *driver_function (message interpretter)
   ; exit  : hl = former default driver function
   
   ld de,(_zdefdev)
   ld (_zdefdev),hl
   ex de,hl

   ret
