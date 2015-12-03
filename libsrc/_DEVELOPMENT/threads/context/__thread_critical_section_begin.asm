
SECTION code_clib
SECTION code_threads

PUBLIC __thread_critical_section_begin

EXTERN asm_z80_push_di

defc __thread_critical_section_begin = asm_z80_push_di
