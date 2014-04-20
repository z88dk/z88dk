
; ===============================================================
; 2014
; ===============================================================
;
; void bit_beep_raw(uint16_t num_cycles, uint16_t tone_period_T)
;
; Output a tone for given duration.
;
; ===============================================================

INCLUDE "clib_target_cfg.asm"

XLIB asm_bit_beep_raw

asm_bit_beep_raw:

   ; enter : hl = (tone_period - 236) / 8, tone_period in z80 T states
   ;         de = duration in number of cycles of tone = time (sec) * freq (Hz)
   ;
   ; uses  : af, bc, de, hl, ix, (bc' if port16)
   
   ld a,d
   or e
   ret z                       ; avoid duration == 0 problem
   
   dec de

   IF __sound_bit_method = 1
   
      INCLUDE "sound/bit/z80/asm_bit_beep_raw/asm_bit_beep_raw_port_8.asm"
   
   ENDIF
   
   IF __sound_bit_method = 2
   
      INCLUDE "sound/bit/z80/asm_bit_beep_raw/asm_bit_beep_raw_port_16.asm"
   
   ENDIF
   
   IF __sound_bit_method = 3
   
      INCLUDE "sound/bit/z80/asm_bit_beep_raw/asm_bit_beep_raw_memory.asm"
   
   ENDIF
   
   IF (__sound_bit_method < 1) | (__sound_bit_method > 3)
   
      ret
      
   ENDIF
