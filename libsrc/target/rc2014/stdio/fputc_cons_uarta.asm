
; Classic console output via UART A device layer.

    INCLUDE "target/rc2014/config_rc2014-8085_private.inc"

    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC  fputc_cons_uarta

    EXTERN  _uarta_putc
    EXTERN  uartaControl


.fputc_cons_uarta
    ; enter    : (sp+2) = char to output
    ; modifies : af, de, hl

    ld      a, (uartaControl)
    or      a
    ret     Z                               ; channel not present

    ld      de, sp+2
    ld      a, (de)
    ld      e, a

  IF STANDARDESCAPECHARS
    cp      10
    jp      NZ, fputc_cons_immediate
    ld      e, 13
    call    fputc_cons_immediate
    ld      e, 10
  ELSE
    cp      13
    jp      NZ, fputc_cons_immediate
    call    fputc_cons_immediate
    ld      e, 10
  ENDIF

.fputc_cons_immediate
    ld      l, e
    jp      _uarta_putc                 ; device blocks until THRE; L=0 on success
