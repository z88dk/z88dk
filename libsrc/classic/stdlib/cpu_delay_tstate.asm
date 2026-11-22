; void __FASTCALL__ cpu_delay_tstate(unsigned int tstates)
;
; Classic C name for asm_cpu_delay_tstate. Same core as t_delay.

    SECTION code_clib

    PUBLIC  cpu_delay_tstate
    PUBLIC  _cpu_delay_tstate

    EXTERN  asm_cpu_delay_tstate

    defc    cpu_delay_tstate=asm_cpu_delay_tstate
    defc    _cpu_delay_tstate=asm_cpu_delay_tstate
