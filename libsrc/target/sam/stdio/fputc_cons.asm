;
;       SAM Coup� C Library
;
;	Print character to the screen
;
;       We will corrupt any register
;
;
;	Frode Tenneb� - 29/12/2002


    SECTION code_driver
    PUBLIC  fputc_cons_native

    EXTERN  THIS_FUNCTION_ONLY_WORKS_WITH_BASIC_SUBTYPE
    PUBLIC  ___fputc_cons_native_protection
    defc ___fputc_cons_native_protection = THIS_FUNCTION_ONLY_WORKS_WITH_BASIC_SUBTYPE



.fputc_cons_native
    ld      hl,2
    add     hl,sp
    ld      b,(hl)
    ld      hl,skip_count
    ld      a,(hl)
    and     a
    ld      a,b
    jr      z,continue
    dec     (hl)
    jr      direct
continue:
    cp      22		;move to
    jr      nz,not_posn
    ld      (hl),2
not_posn:
    cp      10
    jr      nz,not_lf
    ld      a,13
not_lf:
    cp      12	; CLS ?
    jr      nz,direct
    xor     a
    call    $014E
    ld      a,0xfe	;screen
    jp      $0112
direct:
    rst     16
    ld      a,255
    ld      (0x5C8C),a
    ret

    SECTION bss_driver

skip_count:	
    defb    0
