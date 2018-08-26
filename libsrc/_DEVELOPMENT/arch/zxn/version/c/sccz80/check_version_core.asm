; unsigned char check_version_core(uint16_t cv)

SECTION code_arch

PUBLIC check_version_core

EXTERN asm_check_version_core

defc check_version_core = asm_check_version_core
