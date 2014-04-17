
; ===============================================================
; Stefano Bodrato
; ===============================================================
;
; void z80_pop_ei(void)
;
; Pop the ei_di_status from the stack and restore the di/ei
; state to what it was previously when a push was called.
;
; The "ei" in the function name has no bearing on what the
; function does; the name is meant to balance "z80_push_di".
;
; ===============================================================

XLIB asm_z80_pop_ei

asm_z80_pop_ei:

   ; enter  : stack = ei_di_status, ret
   ;
   ; uses  : af

   ex (sp),hl
   pop af                      ; af = old hl
   
   ex (sp),hl                  ; hl = ei_di_status
   push af
   
   ex (sp),hl                  ; hl restored
   pop af                      ; af = ei_di_status
   
   jp po, di_state

ei_state:

   ei
   ret

di_state:

   di
   ret
