
; ===============================================================
; Stefano Bodrato
; ===============================================================
;
; void z80_pop_ei(void)
;
; Pop the ei_di_status from the stack and restore the di/ei
; state to what it was previously when a push was called.
;
; ===============================================================

XLIB asm_z80_pop_ei
XDEF asm_z80_pop_di

asm_z80_pop_ei:
asm_z80_pop_di:

   ; enter  : stack = ei_di_status, ret
   ;
   ; uses  : af, hl

   pop hl                      ; hl = return address
   
   pop af                      ; f = ei_di_status
   jp po, di_state

ei_state:

   ei
   jp (hl)

di_state:

   di
   jp (hl)
