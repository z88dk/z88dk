
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

SECTION code_clib
SECTION code_input

PUBLIC asm_in_mouse_amx_wheel

EXTERN error_enotsup_zc

defc asm_in_mouse_amx_wheel = error_enotsup_zc

   ; exit : success
   ;
   ;           hl = track wheel position
   ;           carry reset
   ;
   ;        fail
   ;
   ;           hl = 0
   ;           carry set, errno = ENOTSUP
   ;
   ; uses : f, hl
