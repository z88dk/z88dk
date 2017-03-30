; void PSGRestoreVolumes(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGRestoreVolumes

EXTERN asm_PSGlib_RestoreVolumes

defc _PSGRestoreVolumes = asm_PSGlib_RestoreVolumes
