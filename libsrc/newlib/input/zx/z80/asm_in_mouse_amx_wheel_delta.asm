
; ===============================================================
; Sep 2014
; ===============================================================
; 
; int16_t in_mouse_amx_wheel_delta(void)
;
; Report change in position of mouse track wheel.
; The AMX mouse does not have a track wheel so error is returned.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_mouse_amx_wheel_delta

EXTERN error_enotsup_zc

defc asm_in_mouse_amx_wheel_delta = error_enotsup_zc

   ; exit : success
   ;
   ;           hl = signed change in track wheel position
   ;           carry reset
   ;
   ;        fail
   ;
   ;           hl = 0
   ;           carry set, errno = ENOTSUP
   ;
   ; uses : f, hl
