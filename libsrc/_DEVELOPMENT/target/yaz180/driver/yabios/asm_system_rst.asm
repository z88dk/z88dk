SECTION code_common1

PUBLIC asm_system_rst

EXTERN  __crt_phase_code_common1

;PHASE  __crt_phase_code_common1
PHASE   0xF700

asm_system_rst:
    ret

DEPHASE

