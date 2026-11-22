SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_pop_ei
PUBLIC l_pop_ei_jp

EXTERN asm_cpu_pop_ei
EXTERN asm_cpu_pop_ei_jp

defc l_pop_ei = asm_cpu_pop_ei
defc l_pop_ei_jp = asm_cpu_pop_ei_jp
