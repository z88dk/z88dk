
; void z180_delay_tstate_fastcall(uint tstates)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_delay_tstate_fastcall

EXTERN asm_z180_delay_tstate

defc _z180_delay_tstate_fastcall = asm_z180_delay_tstate
