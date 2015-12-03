
; ===============================================================
; Mar 2014
; ===============================================================
;
; void z80_delay_ms(uint ms)
;
; Busy wait exactly the number of milliseconds, which includes the
; time needed for an unconditional call and the ret.
;
; ===============================================================

INCLUDE "clib_target_cfg.asm"

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_delay_ms

EXTERN asm_z80_delay_tstate

asm_z80_delay_ms:

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

   ld hl,+(__clock_freq / 1000) - 43
   call asm_z80_delay_tstate

   jr ms_loop

last_ms:

   ; we will be exact
   
   ld hl,+(__clock_freq / 1000) - 54
   jp asm_z80_delay_tstate
