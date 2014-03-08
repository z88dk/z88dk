
; DO NOT ADD TO THE LIBRARY
; THIS FUNCTION IS EXPORTED AS PART OF ASM_Z80_POP_EI

; ===============================================================
; Stefano Bodrato
; ===============================================================
;
; void z80_pop_di(void)
;
; Pop the ei_di_status from the stack and restore the di/ei
; state to what it was previously when a push was called.
;
; ===============================================================

asm_z80_pop_di:

   ; enter  : stack = ei_di_status, ret
   ;
   ; uses  : af, hl
