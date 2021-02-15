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


    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE


if (CRT_ORG_CODE < 32768)
    defs    ZORG_TOO_LOW
endif

    INCLUDE	"crt/classic/crt_init_sp.asm"
    INCLUDE	"crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss

IF DEFINED_USING_amalloc
    ld      hl,0
    add     hl,sp
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

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

    im      2
    ei


    call    _wait_sub_cpu
    ld      bc, $1900
    ld      a, $E4	; Interrupt vector set
    out     (c), a
    call    _wait_sub_cpu
    ld      bc, $1900
    ld      a, $52	; 
    out     (c), a
    call    _main

cleanup:

    call    crt0_exit


	push    hl				; return code
end:
    jr      end

cleanup_exit:
	ret

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







