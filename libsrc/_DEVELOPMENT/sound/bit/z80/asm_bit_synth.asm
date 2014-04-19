
; ===============================================================
; 2008 Stefano Bodrato
; ===============================================================
;
; void bit_synth(int dur, int freq_1, int freq_2, int freq_3, int freq_4)
;
; This is a sort of "quad sound" routine.  It is based on four
; separate counters and a delay.  Depending on the parameters
; being passed, it is able to play using two audible voices,
; to generate sound effects and to play with a single voice
; having odd waveforms.
;
; Unfortunately self-modifying code is used to store parameters.
; This routine shouldn't stay in contended memory locations !!
;
; ===============================================================

INCLUDE "clib_cfg.asm"

XLIB asm_bit_synth

asm_bit_synth:

   ; enter :  a = duration
   ;          h = frequency_1 (0 = disable voice)
   ;          l = frequency_2 (0 = disable voice)
   ;          d = frequency_3 (0 = disable voice)
   ;          e = frequency_4 (0 = disable voice)
   ;
   ; uses  : af, bc, de, hl, (bc' if port_16)

   ; write parameters into synth code

   ld c,__sound_bit_toggle

duration:

   ld (LEN + 1),a

fr1:

   ld a,h
   or a
   jr z, fr1_blank

   ld (FR_1 + 1),a
   ld a,c

fr1_blank:

   ld (FR1_tick + 1),a

fr2:

   ld a,l
   or a
   jr z, fr2_blank
   
   ld (FR_2 + 1),a
   ld a,c

fr2_blank:

   ld (FR2_tick + 1),a
   
fr3:

   ld a,d
   or a
   jr z, fr3_blank
   
   ld (FR_3 + 1),a
   ld a,c

fr3_blank:

   ld (FR3_tick + 1),a

fr4:

   ld a,e
   or a
   jr z, fr4_blank

   ld (FR_4 + 1),a
   ld a,c

fr4_blank:

   ld (FR4_tick + 1),a
   
   ; begin synthesis

   IF __sound_bit_method = 1
   
      INCLUDE "sound/bit/z80/asm_bit_synth/asm_bit_synth_port_8.asm"
   
   ELSE IF __sound_bit_method = 2
   
      INCLUDE "sound/bit/z80/asm_bit_synth/asm_bit_synth_port_16.asm"
   
   ELSE IF __sound_bit_method = 3
   
      INCLUDE "sound/bit/z80/asm_bit_synth/asm_bit_synth_memory.asm"
   
   ENDIF
