SECTION code_common1

PUBLIC asm_am9511a_rst

EXTERN  __crt_phase_code_common1

;PHASE  __crt_phase_code_common1
PHASE   0xF700

asm_am9511a_rst:
    ret

DEPHASE
