
; ===============================================================
; Stefano Bodrato
; ===============================================================
;
; void z180_pop_ei(void)
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
SECTION code_z180

PUBLIC asm_z180_pop_ei
PUBLIC asm0_z180_pop_ei

asm_z180_pop_ei:

   ; enter  : stack = ei_di_status, ret
   ;
   ; uses  : af

   ex (sp),hl
   pop af                      ; af = old hl
   
   ex (sp),hl                  ; hl = ei_di_status
   push af
   
   ex (sp),hl                  ; hl restored

asm0_z180_pop_ei:

   ; enter : stack = ret, ei_di_status
   ;
   ; uses  : af

   pop af                      ; af = ei_di_status
   
   IF __Z80 & __Z80_NMOS
   
      jr nc, di_state
   
   ELSE
   
      jp po, di_state

   ENDIF
   
ei_state:

   ei
   ret

di_state:

   di
   ret
