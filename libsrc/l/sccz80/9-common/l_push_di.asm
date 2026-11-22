SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_push_di

EXTERN asm_cpu_push_di

defc l_push_di = asm_cpu_push_di
