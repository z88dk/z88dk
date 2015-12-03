
; void z80_delay_tstate(uint tstates)

SECTION code_clib
SECTION code_z80

PUBLIC z80_delay_tstate

EXTERN asm_z80_delay_tstate

defc z80_delay_tstate = asm_z80_delay_tstate
