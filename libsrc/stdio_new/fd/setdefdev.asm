; void __FASTCALL__ *setdefdev(void *driver_function)
; 06.2008 aralbrec

PUBLIC setdefdev
EXTERN _stdio_defdev

.setdefdev

   ; set a new default device
   ;
   ; enter : hl = void *driver_function
   ; exit  : hl = former default driver function
   
   ld de,(_stdio_defdev)
   ld (_stdio_defdev),hl
   ex de,hl

   ret
