
; void *bit_play_tritone_fastcall(void *song)

SECTION smc_sound_bit

PUBLIC _bit_play_tritone_fastcall

_bit_play_tritone_fastcall:
   
   INCLUDE "sound/bit/z80/asm_bit_play_tritone.asm"
