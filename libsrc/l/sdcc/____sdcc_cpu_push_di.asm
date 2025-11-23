
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_cpu_push_di

EXTERN asm_cpu_push_di

defc ____sdcc_cpu_push_di = asm_cpu_push_di
