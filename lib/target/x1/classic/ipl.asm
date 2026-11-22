;	CRT0 for the Sharp X1 -
;
;	Karl Von Dyson (for X1s.org)
;
;    $Id: x1_crt0.asm,v 1.17 2016-07-20 05:45:02 stefano Exp $
;


IF      !DEFINED_CRT_ORG_CODE
    defc CRT_ORG_CODE = 0x8000
ENDIF

    defc TAR__register_sp = 0xFDFF
    defc TAR__crt_on_exit = $10001      ;loop forever
    defc TAR__crt_interrupt_mode = 2
    defc TAR__crt_enable_eidi = $02     ;enable interrupts

    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE


if (CRT_ORG_CODE < 32768)
    defs    ZORG_TOO_LOW
endif

    INCLUDE	"crt/classic/crt_init_sp.inc"
    INCLUDE	"crt/classic/crt_init_atexit.inc"
    call    crt0_init

    INCLUDE "crt/classic/crt_init_heap.inc"

    ; re-activate IPL
    ld      bc,$1D00
    xor     a
    out     (c),a

    ld      hl,$FE00
    push    hl
    EXTERN im2_Init
    call    im2_Init
    pop     hl

    EXTERN im2_EmptyISR
    ld      hl,im2_EmptyISR
    ld      b,128
isr_table_fill:
    ld      ($FE00),hl
    inc     hl
    inc     hl
    djnz    isr_table_fill
    ld      hl,_kbd_isr
    ld      ($FE52),hl

    INCLUDE "crt/classic/crt_init_interupt_mode.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _wait_sub_cpu
    ld      bc, $1900
    ld      a, $E4	; Interrupt vector set
    out     (c), a
    call    _wait_sub_cpu
    ld      bc, $1900
    ld      a, $52	; 
    out     (c), a
    call    _main

__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"

_kbd_isr:
    push    af
    push    bc
    push    hl
    call    asm_x1_keyboard_handler
    pop     hl
    pop     bc
    pop     af
    ei
    reti







