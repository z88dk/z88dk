
; void z80_set_int_state(uint state)

SECTION code_clib
SECTION code_z80

PUBLIC z80_set_int_state
PUBLIC cpu_set_int_state

EXTERN asm_z80_set_int_state
EXTERN asm_cpu_set_int_state

defc z80_set_int_state = asm_z80_set_int_state
defc cpu_set_int_state = asm_cpu_set_int_state

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _z80_set_int_state
defc _z80_set_int_state = z80_set_int_state
ENDIF

