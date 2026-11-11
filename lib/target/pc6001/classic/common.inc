; What every PC-6001 startup has the same (included by basic.asm, rom.asm and
; allrammk2.asm after they have set their memory model)

    defc        TAR__fputc_cons_generic=1
    defc        TAR__no_ansifont=1
    defc        TAR__clib_exit_stack_size=32
IFNDEF    TAR__register_sp
    defc        TAR__register_sp=-1
ENDIF
    defc        __CPU_CLOCK=3800000
    INCLUDE     "crt/classic/crt_rules.inc"
