; unsigned char check_version_esxdos(uint16_t ev)

SECTION code_arch

PUBLIC check_version_esxdos

EXTERN asm_check_version_esxdos

defc check_version_esxdos = asm_check_version_esxdos
