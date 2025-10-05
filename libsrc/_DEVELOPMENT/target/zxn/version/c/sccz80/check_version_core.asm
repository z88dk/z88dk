; unsigned char check_version_core(uint16_t cv)

SECTION code_arch

PUBLIC check_version_core

EXTERN asm_check_version_core

defc check_version_core = asm_check_version_core

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _check_version_core
defc _check_version_core = check_version_core
ENDIF

