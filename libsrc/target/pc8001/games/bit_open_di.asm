
; Start one bit sound with interrupts off

    SECTION code_clib
    PUBLIC  bit_open_di
    PUBLIC  _bit_open_di
    EXTERN  __snd_tick
    EXTERN  __bit_irqstatus

bit_open_di:
_bit_open_di:
    ld      a, i                        ; get the current status of the irq line
    di
    push    af

    ex      (sp), hl
    ld      (__bit_irqstatus), hl
    pop     hl

    ld      a, ($ea67)
    ld      (__snd_tick), a
    ret
