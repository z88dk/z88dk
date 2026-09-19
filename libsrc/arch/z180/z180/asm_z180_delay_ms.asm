
; ===============================================================
; Mar 2014
; ===============================================================
;
; void z180_delay_ms(uint ms)
;
; Z180 ms-loop overhead around delay_tstate (jr 8/6, ld hl,nn 9,
; call 16, ret 9) is not the Z80 43/54 pair.
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

   ld hl,+(__CPU_CLOCK / 1000) - 35
   call asm_z180_delay_tstate

   jr ms_loop

last_ms:

   ld hl,+(__CPU_CLOCK / 1000) - 38
   jp asm_z180_delay_tstate
