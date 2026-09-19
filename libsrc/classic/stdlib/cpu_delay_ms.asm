; void __FASTCALL__ cpu_delay_ms(unsigned int ms)
;
; Classic C name for asm_cpu_delay_ms (Z80 / 8080-family / gbz80 /
; Z180 each have their own tstate inner loop).

    SECTION code_clib

    PUBLIC  cpu_delay_ms
    PUBLIC  _cpu_delay_ms

    EXTERN  asm_cpu_delay_ms

    defc    cpu_delay_ms=asm_cpu_delay_ms
    defc    _cpu_delay_ms=asm_cpu_delay_ms
