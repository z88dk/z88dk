
; ===============================================================
; Apr 2014
; ===============================================================
; 
; uint16_t in_mouse_kempston_wheel(void)
;
; Report position of mouse track wheel.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_mouse_kemptson_wheel

EXTERN __input_kempston_mouse_wheel

asm_in_mouse_kempston_wheel:

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

   ld a,$fa
   in a,($df)
   
   and $f0
   
   ld h,a
   ld l,0
   
   ret
