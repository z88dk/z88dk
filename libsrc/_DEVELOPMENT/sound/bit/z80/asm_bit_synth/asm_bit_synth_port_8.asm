
   ; "sound/bit/z80/asm_bit_synth/asm_bit_synth_port_8.asm"
   ; Stefano Bodrato
   
   ; quad synthesizer outputting to 8-bit port address
   ; included into "sound/bit/z80/asm_bit_synth.asm"

   ; This is a sort of "quad sound" routine.  It is based on four
   ; separate counters and a delay.  Depending on the parameters
   ; being passed, it is able to play using two audible voices,
   ; to generate sound effects and to play with a single voice
   ; having odd waveforms.
   ;
   ; Unfortunately self-modifying code is used to store parameters.
   ; This routine shouldn't stay in contended memory locations !!

   LIB asm_bit_open, asm_bit_close

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

   xor __sound_bit_toggle
   out (__sound_bit_port),a
   
FR_1:

   ld h,80

jump:

   dec l
   jr nz, jump2

FR2_tick:

   xor __sound_bit_toggle
   out (__sound_bit_port),a

FR_2:

   ld l,81

jump2:

   dec d
   jr nz, jump3

FR3_tick:

   xor __sound_bit_toggle
   out (__sound_bit_port),a
   
FR_3:

   ld d,162

jump3:

   dec e
   jr nz, loop2

FR4_tick:

   xor __sound_bit_toggle
   out (__sound_bit_port),a

FR_4:

   ld e,163
   
   dec c
   jr nz, loop2
   
   djnz loop1

   jp asm_bit_close
