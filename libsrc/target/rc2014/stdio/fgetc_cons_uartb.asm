
; Classic console input via UART B device layer (blocking).

    INCLUDE "target/rc2014/config_rc2014-8085_private.inc"

    SECTION code_driver

    PUBLIC  fgetc_cons_uartb

    EXTERN  _uartb_getc


.fgetc_cons_uartb
    ; exit     : hl = char received
    ; modifies : af, hl

.wait_rx
    call    _uartb_getc
    jp      NC, wait_rx

  IF STANDARDESCAPECHARS
    cp      13
    ld      hl, 10
    ret     Z
    cp      10
    ld      hl, 13
    ret     Z
  ENDIF

    ld      l, a
    ld      h, 0
    ret
