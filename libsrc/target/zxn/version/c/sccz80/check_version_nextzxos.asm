; unsigned char check_version_nextzxos(uint16_t nv)

SECTION code_arch

PUBLIC check_version_nextzxos

EXTERN asm_check_version_nextzxos

defc check_version_nextzxos = asm_check_version_nextzxos

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _check_version_nextzxos
defc _check_version_nextzxos = check_version_nextzxos
ENDIF

