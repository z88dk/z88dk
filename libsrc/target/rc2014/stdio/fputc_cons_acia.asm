
; Classic console output via ACIA device layer.
; Thin wrap over _acia_putc — do not duplicate Tx buffer logic.

    INCLUDE "target/rc2014/config_rc2014-8085_private.inc"

    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC  fputc_cons_acia

    EXTERN  _acia_putc


.fputc_cons_acia
    ; enter    : (sp+2) = char to output
    ; modifies : af, de, hl

    ld      de, sp+2                     ; retrieve Tx character
    ld      a, (de)
    ld      e, a

  IF STANDARDESCAPECHARS
    cp      10                          ; LF ?
    jp      NZ, fputc_cons_immediate
    ld      e, 13                       ; CR
    call    fputc_cons_immediate
    ld      e, 10                       ; LF
  ELSE
    cp      13                          ; CR ?
    jp      NZ, fputc_cons_immediate
    call    fputc_cons_immediate
    ld      e, 10                       ; LF
  ENDIF

.fputc_cons_immediate
    ; L = char; _acia_putc returns L=1 if Tx buffer full

    ld      l, e
    call    _acia_putc
    ld      a, l
    or      a
    jp      NZ, fputc_cons_immediate    ; buffer full — wait and retry
    ret
