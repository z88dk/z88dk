
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

INCLUDE "config_private.inc"

SECTION smc_clib
SECTION smc_sound_bit

PUBLIC asm_bit_synth

EXTERN asm_bit_open, asm_bit_close

asm_bit_synth:

   ; enter :  a = duration
   ;          h = frequency_1 (0 = disable voice)
   ;          l = frequency_2 (0 = disable voice)
   ;          d = frequency_3 (0 = disable voice)
   ;          e = frequency_4 (0 = disable voice)
   ;
   ; uses  : af, bc, de, hl, (bc' if port_16)

   ; write parameters into synth code

   ld c,__SOUND_BIT_TOGGLE

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

   IF __SOUND_BIT_METHOD = 2
   
      exx
      ld bc,__SOUND_BIT_PORT
      exx
   
   ENDIF

   call asm_bit_open
   
   ld h,1
   ld l,h
   ld d,h
   ld e,h
   
LEN:

   ld b,50

loop1:

   ld c,4

loop2:

   dec h
   jr nz, jump
   
FR1_tick:

   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"
   
FR_1:

   ld h,80

jump:

   dec l
   jr nz, jump2

FR2_tick:

   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

FR_2:

   ld l,81

jump2:

   dec d
   jr nz, jump3

FR3_tick:

   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"
   
FR_3:

   ld d,162

jump3:

   dec e
   jr nz, loop2

FR4_tick:

   xor __SOUND_BIT_TOGGLE
   INCLUDE "sound/bit/z80/output_bit_device_2.inc"

FR_4:

   ld e,163
   
   dec c
   jr nz, loop2
   
   djnz loop1

   jp asm_bit_close
