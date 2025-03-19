  IF    !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_STRICT__

        SECTION code_l_sccz80
        PUBLIC  __z80asm__call_ix

__z80asm__call_ix:
        push    ix
        ret

  ENDIF
