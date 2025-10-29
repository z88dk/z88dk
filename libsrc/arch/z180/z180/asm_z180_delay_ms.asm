
; ===============================================================
; Mar 2014
; ===============================================================
;
; void z180_delay_ms(uint ms)
;
; Busy wait exactly the number of milliseconds, which includes the
; time needed for an unconditional call and the ret.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_z180

PUBLIC asm_z180_delay_ms
PUBLIC asm_cpu_delay_ms

EXTERN asm_z180_delay_tstate

asm_z180_delay_ms:
asm_cpu_delay_ms:

   ; enter : hl = milliseconds (0 = 65536)
   ;
   ; uses  : af, bc, de, hl

   ld e,l
   ld d,h

ms_loop:

   dec de
   
   ld a,d
   or e
   jr z, last_ms

   ld hl,+(__CPU_CLOCK / 1000) - 43
   call asm_z180_delay_tstate

   jr ms_loop

last_ms:

   ; we will be exact
   
   ld hl,+(__CPU_CLOCK / 1000) - 54
   jp asm_z180_delay_tstate
