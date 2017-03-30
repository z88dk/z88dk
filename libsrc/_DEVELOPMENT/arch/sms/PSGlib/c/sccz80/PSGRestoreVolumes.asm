; void PSGRestoreVolumes(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGRestoreVolumes

EXTERN asm_PSGlib_RestoreVolumes

defc PSGRestoreVolumes = asm_PSGlib_RestoreVolumes
