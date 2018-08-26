; unsigned char check_version_nextzxos(uint16_t nv)

SECTION code_arch

PUBLIC check_version_nextzxos

EXTERN asm_check_version_nextzxos

defc check_version_nextzxos = asm_check_version_nextzxos
