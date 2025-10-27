
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_cpu_pop_ei

EXTERN asm_cpu_pop_ei

defc ____sdcc_cpu_pop_ei = asm_cpu_pop_ei
