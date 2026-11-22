
; ===============================================================
; Mar 2014
; ===============================================================
;
; void z80_delay_ms(uint ms)
;
; Busy wait the number of milliseconds, including an
; unconditional call and the ret. Overhead subtracted from
; __CPU_CLOCK/1000 is the ms-loop cost around delay_tstate
; (call/ret of tstate is inside tstate).
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_delay_ms
PUBLIC asm_cpu_delay_ms

EXTERN asm_z80_delay_tstate

asm_z80_delay_ms:
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

IF __CPU_INTEL__

   jp z, last_ms

   ld hl,+(__CPU_CLOCK / 1000) - 43
   call asm_z80_delay_tstate

   jp ms_loop

last_ms:

   ld hl,+(__CPU_CLOCK / 1000) - 42
   jp asm_z80_delay_tstate

ELIF __CPU_GBZ80__

   jr z, last_ms

   ld hl,+(__CPU_CLOCK / 1000) - 44
   call asm_z80_delay_tstate

   jr ms_loop

last_ms:

   ld hl,+(__CPU_CLOCK / 1000) - 46
   jp asm_z80_delay_tstate

ELSE

   jr z, last_ms

   ld hl,+(__CPU_CLOCK / 1000) - 43
   call asm_z80_delay_tstate

   jr ms_loop

last_ms:

   ld hl,+(__CPU_CLOCK / 1000) - 54
   jp asm_z80_delay_tstate

ENDIF
