
; Classic console input via ACIA device layer (blocking).
; Thin wrap over _acia_getc — do not duplicate Rx buffer logic.

    INCLUDE "target/rc2014/config_rc2014-8085_private.inc"

    SECTION code_driver

    PUBLIC  fgetc_cons_acia

    EXTERN  _acia_getc


.fgetc_cons_acia
    ; exit     : hl = char received
    ; modifies : af, hl

.wait_rx
    call    _acia_getc                  ; L = char, carry set if available
    jp      NC, wait_rx                 ; empty — block

    ; A = L = raw byte from device

  IF STANDARDESCAPECHARS
    cp      13                          ; CR ?
    ld      hl, 10                      ; LF
    ret     Z
    cp      10                          ; LF ?
    ld      hl, 13                      ; CR
    ret     Z
  ENDIF

    ld      l, a
    ld      h, 0
    ret
