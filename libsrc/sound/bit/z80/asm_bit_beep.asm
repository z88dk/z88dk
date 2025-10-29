
; ===============================================================
; 2014
; ===============================================================
;
; void bit_beep(uint16_t duration_ms, uint16_t frequency_hz)
;
; Output a tone for given duration.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_beep
PUBLIC asm0_bit_beep

EXTERN asm_bit_beep_raw, l_mulu_32_16x16, l0_divu_32_32x16

asm_bit_beep:

   ; enter : hl = note_frequency
   ;         de = duration_ms
   ;
   ; uses  : af, bc, de, hl, ix, (bc', de', hl' for integer division)

   push hl                     ; save note_freq
   
   call l_mulu_32_16x16        ; dehl = note_freq * dur_ms
   
   ld bc,1000
   call l0_divu_32_32x16       ; hl = cycle_dur = note_freq * dur_ms / 1000
   
   pop bc                      ; bc = note_freq

asm0_bit_beep:

   ; bc = note_freq
   ; hl = cycle_duration

   push hl                     ; save cycle_dur
   
   ld de,+(__CPU_CLOCK / 8) / 65536
   ld hl,+(__CPU_CLOCK / 8) % 65536
   
   call l0_divu_32_32x16       ; dehl = dehl / bc = __CPU_CLOCK / (note_freq * 8)
   
   or a
   ld de,30
   sbc hl,de
   
   pop de
   
   ; de = cycle_duration
   ; hl = cycle_note_period

   jp asm_bit_beep_raw
