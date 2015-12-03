
; ===============================================================
; ported by Dominic Morris, adapted by Stefano Bodrato
; from ZX Spectrum ROM
; ===============================================================
;
; void bit_beep_raw(uint16_t num_cycles, uint16_t tone_period_T)
;
; Output a tone for given duration.
;
; ===============================================================

INCLUDE "clib_target_cfg.asm"

SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_beep_raw

EXTERN asm_bit_open, asm_bit_close

asm_bit_beep_raw:

   ; enter : hl = (tone_period - 236) / 8, tone_period in z80 T states
   ;         de = duration in number of cycles of tone = time (sec) * freq (Hz)
   ;
   ; uses  : af, bc, de, hl, ix, (bc' if port16)
   
   ld a,d
   or e
   ret z                       ; avoid duration == 0 problem
   
   dec de

   IF __sound_bit_method = 2
   
      exx
      ld bc,__sound_bit_port
      exx
   
   ENDIF

beeper:

   ld a,l
   srl l
   srl l
   cpl
   and $03
   ld c,a
   ld b,0
   
   ld ix,beixp3
   add ix,bc

   call asm_bit_open
   
beixp3:

   nop
   nop
   nop
   inc b
   inc c

behllp:

   dec c
   jr nz, behllp
   
   ld c,$3f

   dec b
   jp nz, behllp

   xor __sound_bit_toggle
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"
   
   ld b,h
   ld c,a
   
   bit __sound_bit_toggle_pos,a
   jr nz, be_again
   
   ld a,d
   or e
   
   ld a,c
   jr z, be_end

   ld c,l
   
   dec de
   jp (ix)

be_again:

   ld c,l
   
   inc c
   jp (ix)

be_end:

   jp asm_bit_close
