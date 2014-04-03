; ===============================================================
; Stefano Bodrato
; ===============================================================
;
; unsigned int z80_get_int_state(void)
;
; Retrieve the current ei/di status.
;
; ===============================================================

XLIB asm_z80_get_int_state

asm_z80_get_int_state:

   ; exit  : hl = ei/di status
   ;
   ; uses  : af, hl
   
   ld a,i                      ; ei_di_status into p/v flag
   
   push af
   pop hl

   ret
