
; void z180_delay_tstate(uint tstates)

SECTION code_clib
SECTION code_z180

PUBLIC z180_delay_tstate

EXTERN asm_z180_delay_tstate

defc z180_delay_tstate = asm_z180_delay_tstate
