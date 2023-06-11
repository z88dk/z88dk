
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

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_pop_ei
PUBLIC asm0_z80_pop_ei
PUBLIC asm_z80_pop_ei_jp

PUBLIC asm_cpu_pop_ei
PUBLIC asm0_cpu_pop_ei
PUBLIC asm_cpu_pop_ei_jp

asm_z80_pop_ei:
asm_cpu_pop_ei:

IF __CPU_R2KA__ | __CPU_R3K__

   defc asm0_z80_pop_ei = asm_cpu_pop_ei
   defc asm0_cpu_pop_ei = asm_cpu_pop_ei
   defc asm_z80_pop_ei_jp = asm_cpu_pop_ei
   defc asm_cpu_pop_ei_jp = asm_cpu_pop_ei

   ipres

ELSE

   ; enter  : stack = ei_di_status, ret
   ;
   ; uses  : af

   ex (sp),hl
   pop af                      ; af = old hl
   
   ex (sp),hl                  ; hl = ei_di_status
   push af
   
   ex (sp),hl                  ; hl restored

asm0_z80_pop_ei:
asm0_cpu_pop_ei:
asm_z80_pop_ei_jp:
asm_cpu_pop_ei_jp:

   ; enter : stack = ret, ei_di_status
   ;
   ; uses  : af

   pop af                      ; af = ei_di_status

IF __CPU_8085__

   and $08                     ; isolate IE bit
   jp Z,di_state               ; or fall through to ei_state

ELSE

   IF __Z80 & __Z80_NMOS
   
      jr NC, di_state
   
   ELSE
   
      jp PO, di_state

   ENDIF

ENDIF

ei_state:

   ei
   ret

di_state:

   di

ENDIF

   ret
