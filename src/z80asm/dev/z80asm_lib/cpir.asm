; Substitute for z80 cpir instruction
; aralbrec 02.2008
; flag-perfect emulation of cpir

        SECTION code_l_sccz80
        PUBLIC  __z80asm__cpir

__z80asm__cpir:

        jr      nc, enterloop

        call    enterloop

; scf clears N and H - must set carry the hard way
        push    af
        ex      (sp), hl
  IF    __CPU_INTEL__
        ld      a, l
        or      @00000001
        ld      l, a
  ELSE
        set     0, l                    ; set carry
  ENDIF
        jr      retflags

loop:

        inc     hl

enterloop:

        dec     bc
        cp      (hl)                    ; compare, set flags
        jr      z, match

        inc     c
        dec     c
        jr      nz, loop

        inc     b
        djnz    loop

; .nomatch

        cp      (hl)                    ; compare, set flags
        inc     hl
        push    af

joinbc0:

        ex      (sp), hl
  IF    __CPU_INTEL__
        ld      a, l
        and     @11111010
        ld      l, a
  ELSE
        res     0, l                    ; clear carry
        res     2, l                    ; clear P/V -> BC == 0
  ENDIF
        jr      retflags

match:

        inc     hl
        push    af

        ld      a, b
        or      c
        jr      z, joinbc0

        ex      (sp), hl
  IF    __CPU_INTEL__
        ld      a, l
        and     @11111110
        or      @00000100
        ld      l, a
  ELSE
        res     0, l                    ; clear carry
        set     2, l                    ; set P/V -> BC != 0
  ENDIF

retflags:
        ex      (sp), hl
        pop     af
        ret
