; void __FASTCALL__ t_delay(unsigned int tstates)

SECTION code_clib
PUBLIC t_delay
PUBLIC _t_delay
EXTERN asm_cpu_delay_tstate


defc t_delay = asm_cpu_delay_tstate
defc _t_delay = asm_cpu_delay_tstate

