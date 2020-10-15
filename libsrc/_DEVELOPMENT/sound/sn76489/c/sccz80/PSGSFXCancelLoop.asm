; void PSGSFXCancelLoop(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGSFXCancelLoop

EXTERN asm_PSGlib_CancelLoop

defc PSGSFXCancelLoop = asm_PSGlib_CancelLoop
