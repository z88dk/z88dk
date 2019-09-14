; Substitute for the z80 ex (sp),hl instruction


IF __CPU_GBZ80__
SECTION code_crt0_sccz80
PUBLIC __z80asm__exsphl



.__z80asm__exsphl
        push    af              ;16
        push    de              ;16
        ld      d,h             ;4
        ld      e,l             ;4
        ld      hl,sp+8         ;12, (sp)
        ld      a,(hl)          ;8
        ld      (hl),e          ;8
        ld      e,a             ;4
        inc     hl              ;8
        ld      a,(hl)          ;8
        ld      (hl),d          ;8
        ld      h,a             ;4
        ld      l,e             ;4
        pop     de              ;12
        pop     af              ;12
        ret                     ;16

ENDIF
