
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_cpu_pop_ei_jp

EXTERN asm_cpu_pop_ei_jp

defc ____sdcc_cpu_pop_ei_jp = asm_cpu_pop_ei_jp
