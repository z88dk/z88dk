
; ===============================================================
; Stefano Bodrato
; ===============================================================
;
; void z80_pop_di(void)
;
; Pop the ei_di_status from the stack and restore the di/ei
; state to what it was previously when a push was called.
;
; The "di" in the function name has no bearing on what the
; function does; the name is meant to balance "z80_push_ei".

; ===============================================================

XLIB asm_z80_pop_di

LIB asm_z80_pop_ei

asm_z80_pop_di:

   jp asm_z80_pop_ei

;defc asm_z80_pop_di = asm_z80_pop_ei

   ; enter  : stack = ei_di_status, ret
   ;
   ; uses  : af, hl
