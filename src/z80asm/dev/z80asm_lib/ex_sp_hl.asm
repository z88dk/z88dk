; Substitute for the z80 ex (sp),hl instruction


IF __CPU_GBZ80__
SECTION code_crt0_sccz80
PUBLIC __z80asm__ex_sp_hl

.__z80asm__ex_sp_hl
        push    af              ;16
        push    de              ;16
        ld      d,h             ;4			DE = HL0
        ld      e,l             ;4
        ld      hl,sp+6         ;12, (sp)	HL = & SP0
        ld      a,(hl)          ;8
        ld      (hl),e          ;8
        ld      e,a             ;4			swap low HL0, SP0
        inc     hl              ;8			HL = & SP0+1
        ld      a,(hl)          ;8
        ld      (hl),d          ;8
        ld      h,a             ;4			swap hi HL0, SP0 -> HL
        ld      l,e             ;4
        pop     de              ;12
        pop     af              ;12
        ret                     ;16

ENDIF
