  IF    !__CPU_INTEL__&&!__CPU_GBZ80__&&!__CPU_STRICT__

        SECTION code_l_sccz80
        PUBLIC  __z80asm__call_iy

__z80asm__call_iy:
        push    iy
        ret

  ENDIF
