; This constant is required for sound/bit/z80/asm_bit_open/close/click to compile.
; I based this file on arch/zx/misc/z80/__sound_bit_state.asm

SECTION data_clib
SECTION data_sound_bit

PUBLIC __sound_bit_state

;EXTERN _GLOBAL_ZX_PORT_FE

defc __sound_bit_state = 0x00	;0x12

