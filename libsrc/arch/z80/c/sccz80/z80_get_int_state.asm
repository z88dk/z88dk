
; uint z80_get_int_state(void)

SECTION code_clib
SECTION code_z80

PUBLIC z80_get_int_state
PUBLIC cpu_get_int_state

EXTERN asm_z80_get_int_state
EXTERN asm_cpu_get_int_state

defc z80_get_int_state = asm_z80_get_int_state
defc cpu_get_int_state = asm_cpu_get_int_state

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _z80_get_int_state
defc _z80_get_int_state = z80_get_int_state
ENDIF

