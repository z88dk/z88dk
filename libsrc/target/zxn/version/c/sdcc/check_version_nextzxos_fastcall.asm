; unsigned char check_version_nextzxos(uint16_t nv)

SECTION code_arch

PUBLIC _check_version_nextzxos_fastcall

EXTERN asm_check_version_nextzxos

defc _check_version_nextzxos_fastcall = asm_check_version_nextzxos
