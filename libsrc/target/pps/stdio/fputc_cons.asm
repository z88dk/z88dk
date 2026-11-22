;
;       Small C+ Library Functions
;
;	Renamed once more and rechristened for ANSIstdio
;
;	This outputs a character to the console
;
;	1/4/2000 (Original Aug 98)
;
;
;
;	$Id: fputc_cons.asm,v 1.5 2016-05-15 20:15:46 dom Exp $
;

    SECTION code_clib
    PUBLIC  fputc_cons_native           ;Print char

fputc_cons_native:
    pop     bc
    pop     hl
    push    hl
    push    bc
    push    ix

    ld      a, l
    cp      8
    jr      nz, fputc_cons1
    ld      c, $53                      ;CURSOR
    rst     $10
    ld      a, e
    and     a
    jr      z, fputc_exit
    dec     e
    ld      c, $52                      ;LOCATE
    rst     $10
    jr      fputc_exit
fputc_cons1:
    ; DSS PUTCHAR treats CR and LF as independent cursor controls.
    ; C '\n' is LF with the +pps default -Cc-standard-escape-chars;
    ; emit CR first so the next line starts at column 0.
    cp      10                          ;LF?
    jr      nz, fputc_cons2
    ld      a, 13
    ld      c, $5b                      ;PUTCHAR
    rst     $10
    ld      a, 10
fputc_cons2:
    ld      c, $5b                      ;PUTCHAR
    rst     $10
fputc_exit:
    pop     ix
    ret
