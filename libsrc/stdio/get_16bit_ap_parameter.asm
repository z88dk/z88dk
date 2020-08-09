    MODULE  get_16bit_ap_parameter
    SECTION code_clib
    PUBLIC  get_16bit_ap_parameter
    EXTERN  __printf_issccz80


; Change the arguments pointer, the delta is always 2, but is it +/-ve?
; Entry: de = ap
; Return: de = new ap
;         hl = value
; Uses:  ix
get_16bit_ap_parameter:
IF __CPU_GBZ80__
    ld      a,(de)
    ld      l,a
    inc     de
    ld      a,(de)
    ld      h,a
ELSE
    ex      de,hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ex      de,hl           ;de=ap+1 hl=to print
ENDIF
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_issccz80
ELSE
    bit     0,(ix+6)        ;sccz80 flag
ENDIF
    jr      nz,change_ap_decrement
    inc     de
    ret
change_ap_decrement:
    dec     de
    dec     de
    dec     de
    ret
