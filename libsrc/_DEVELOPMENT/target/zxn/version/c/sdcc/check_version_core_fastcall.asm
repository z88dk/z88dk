; unsigned char check_version_core(uint16_t cv)

SECTION code_arch

PUBLIC _check_version_core_fastcall

EXTERN asm_check_version_core

defc _check_version_core_fastcall = asm_check_version_core
