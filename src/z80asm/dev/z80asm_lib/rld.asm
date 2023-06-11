; Substitute for z80 rld instruction
; aralbrec 06.2007
; CPU   Min T Max T
; 8080  201   232
; 8085  197   226
; gbz80 164   188
; r2ka  108   125
; z180   18    18
; z80    18    18
; z80n   18    18

        SECTION code_l_sccz80
        PUBLIC  __z80asm__rld

__z80asm__rld:

        jr      nc, dorld

        call    dorld
        scf
        ret

dorld:

  IF    __CPU_INTEL__                   ; a = xi, (hl) = jk --> a = xj, (hl) = ki
        push    de
        push    hl

        ld      l, (hl)
        ld      h, 0                    ; hl = 00jk

        ld      d, a                    ; d = xi
        and     0xf0
        ld      e, a                    ; e = x0
        ld      a, d
        and     0x0f
        ld      d, a                    ; d = a = 0i

        add     hl, hl
        add     hl, hl
        add     hl, hl
        add     hl, hl                  ; a = 0i, hl = 0jk0

        add     a, l
        ld      l, a                    ; a = 0i, hl = 0jki
        ld      a, h                    ; a = 0j, hl = 0jki
        add     a, e                    ; a = xj, hl = 0jki

        ld      e, l                    ; a = xj, e = ki

        pop     hl
        ld      (hl), e                 ; a = xj, (hl) = ki

        pop     de
  ELSE
        rlca
        rlca
        rlca
        rlca                            ; a = bits 32107654

        sla     a
        rl      (hl)
        adc     a, 0

        rla
        rl      (hl)
        adc     a, 0

        rla
        rl      (hl)
        adc     a, 0

        rla
        rl      (hl)
        adc     a, 0
  ENDIF

        or      a
        ret
