
SECTION code_clib
SECTION code_threads

PUBLIC __thread_critical_section_end

EXTERN asm_z80_pop_ei

defc __thread_critical_section_end = asm_z80_pop_ei
