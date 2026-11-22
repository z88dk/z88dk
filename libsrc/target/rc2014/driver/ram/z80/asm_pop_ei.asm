
; ===============================================================
; Stefano Bodrato
; ===============================================================
;
; void asm_pop_ei(void)
;
; Pop the ei_di_status from the stack and restore the di/ei
; state to what it was previously when a push was called.
;
; The "ei" in the function name has no bearing on what the
; function does; the name is meant to balance "z80_push_di".
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib

PUBLIC asm_pop_ei_jp

.asm_pop_ei_jp

   ; enter : stack = ret, ei_di_status
   ;
   ; uses  : af

   pop af                      ; af = ei_di_status
   jp PO, di_state

.ei_state

   ei
   ret

.di_state

   di
   ret
