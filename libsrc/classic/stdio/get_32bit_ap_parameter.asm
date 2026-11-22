
    MODULE  get_32bit_ap_parameter
    SECTION code_clib
    PUBLIC  get_32bit_ap_parameter
    EXTERN  __printf_issccz80

; Get a 32 bit number from ap
;
; Entry: de = ap
; Exit:  deba = number
;        hl = new ap
get_32bit_ap_parameter:

IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_issccz80
ELSE
    bit     0,(ix+6)        ;sccz80 flag
ENDIF
    jr      nz,pickuplong_sccz80
    ; Picking up a long sdcc style
    ex      de,hl           ;hl=where tp pick up from
    ld      a,(hl)          ;LSW
    inc     hl
    ld      b,(hl)
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ret


pickuplong_sccz80:
    ex      de,hl
    ld      e,(hl)          ;MSW
    inc     hl
    ld      d,(hl)
    dec     hl
    dec     hl
    ld      b,(hl)          ;LSW
    dec     hl
IF __CPU_GBZ80__
    ld      a,(hl-)
ELSE
    ld      a,(hl)
    dec     hl
ENDIF
    dec     hl
    ret