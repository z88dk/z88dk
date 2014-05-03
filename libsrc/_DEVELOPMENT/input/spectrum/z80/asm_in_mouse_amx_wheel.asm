
; ===============================================================
; Apr 2014
; ===============================================================
; 
; uint16_t in_mouse_amx_wheel(void)
;
; Report position of mouse track wheel.
; The AMX mouse does not have a track wheel so error is returned.
;
; ===============================================================

XLIB asm_in_mouse_amx_wheel

LIB error_enotsup_mc

asm_in_mouse_amx_wheel:

   ; exit : success
   ;
   ;           hl = track wheel position
   ;           carry reset
   ;
   ;        fail
   ;
   ;           hl = -1
   ;           carry set, errno = ENOTSUP
   ;
   ; uses : f, hl
   
   jp error_enotsup_mc
