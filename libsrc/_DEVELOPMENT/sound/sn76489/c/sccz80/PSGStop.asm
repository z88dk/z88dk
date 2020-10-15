; void PSGStop(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGStop

EXTERN asm_PSGlib_Stop

defc PSGStop = asm_PSGlib_Stop
