; Substitute for the z80 adc hl,hl instruction
; CPU   Min T Max T
; 8080  110   110
; 8085  111   111
; gbz80  84    84
; r2ka    4     4
; z180   10    10
; z80    15    15
; z80n   15    15

        SECTION code_l_sccz80
        PUBLIC  __z80asm__adc_hl_hl

__z80asm__adc_hl_hl:
        push    de

  IF    __CPU_INTEL__
        push    af
        ld      a, 0
        ld      d, a
        rla
        ld      e, a
        pop     af
  ELSE
        ld      de, 0
        rl      e                       ; de = carry
  ENDIF
        add     hl, hl
        add     hl, de

        pop     de
        ret
