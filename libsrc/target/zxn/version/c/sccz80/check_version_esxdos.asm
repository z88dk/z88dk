; unsigned char check_version_esxdos(uint16_t ev)

SECTION code_arch

PUBLIC check_version_esxdos

EXTERN asm_check_version_esxdos

defc check_version_esxdos = asm_check_version_esxdos

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _check_version_esxdos
defc _check_version_esxdos = check_version_esxdos
ENDIF

