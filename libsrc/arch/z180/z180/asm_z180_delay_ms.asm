
; ===============================================================
; Mar 2014
; ===============================================================
;
; void z180_delay_ms(uint ms)
;
; Busy wait exactly HL milliseconds, including an unconditional
; call and the ret. HL = 0 waits 65536 ms. One millisecond is
; __CPU_CLOCK/1000 states.
;
; delay_tstate includes its own call (16) and ret. States here
; are the Z180 manual, so dec rr is 4 (not the Z80's 6):
;
;   prologue: call 16 + two ld r,r = 24
;   full pass: dec rr 4, ld a,r 4, or r 4, jr not taken 6,
;              ld hl,nn 9, call tstate, jr 8 = 35 + tstate
;   last pass: dec rr 4, ld a,r 4, or r 4, jr taken 8,
;              ld hl,nn 9, jp 9. The jp is 7 less than the
;              call delay_tstate counts, so this pass is
;              22 + tstate. 24 + 22 = 46.
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

   ld hl,+(__CPU_CLOCK / 1000) - 46
   jp asm_z180_delay_tstate
