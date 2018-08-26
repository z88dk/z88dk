; unsigned char check_version_esxdos(uint16_t ev)

SECTION code_arch

PUBLIC _check_version_esxdos_fastcall

EXTERN asm_check_version_esxdos

defc _check_version_esxdos_fastcall = asm_check_version_esxdos
