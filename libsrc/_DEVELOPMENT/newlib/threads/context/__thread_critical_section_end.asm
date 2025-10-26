SECTION code_clib
SECTION code_threads

PUBLIC __thread_critical_section_end

EXTERN asm_cpu_pop_ei

defc __thread_critical_section_end = asm_cpu_pop_ei
