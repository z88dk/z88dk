
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

XLIB asm_z80_delay_ms

INCLUDE "clib_target_cfg.asm"

LIB asm_z80_delay_tstate

asm_z80_delay_ms:

   ; enter : hl = milliseconds (0 = 65536)
   ;
   ; uses  : af, bc, de, hl

   ex de,hl
   
   ld hl,+(__clock_freq / 1000) - 49
   call asm_z80_delay_tstate
   
   ex de,hl

ms_loop:

   dec hl

   ld a,h
   or l

   jr nz, not_done             ; must slow down the return path
   ret

not_done:

   ret z                       ; never taken
   ex de,hl
   
   ld hl,+(__clock_freq / 1000) - 61
   call asm_z80_delay_tstate
   
   ex de,hl
   jr ms_loop
