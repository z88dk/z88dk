; void PSGCancelLoop(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGCancelLoop

EXTERN asm_PSGlib_SFXCancelLoop

defc PSGCancelLoop = asm_PSGlib_SFXCancelLoop
