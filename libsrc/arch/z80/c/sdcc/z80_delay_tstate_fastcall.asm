
; void z80_delay_tstate_fastcall(uint tstates)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_delay_tstate_fastcall

EXTERN asm_z80_delay_tstate

defc _z80_delay_tstate_fastcall = asm_z80_delay_tstate
