SECTION code_common1

PUBLIC asm_z180_trap

EXTERN  __crt_phase_code_common1

;PHASE  __crt_phase_code_common1
PHASE   0xF700

asm_z180_trap:
    ret

DEPHASE

