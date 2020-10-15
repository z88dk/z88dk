; void PSGSFXFrame(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGSFXFrame

EXTERN asm_PSGlib_SFXFrame

defc PSGSFXFrame = asm_PSGlib_SFXFrame
