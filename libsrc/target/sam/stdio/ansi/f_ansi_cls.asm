;
;   SAM Coupé C Library
;
;   ANSI Video handling for SAM Coupé
;
;   CLS - Clear the screen
;
;
;   Frode Tennebø - 29/12/2002
;

    SECTION code_clib
    PUBLIC  ansi_cls

ansi_cls:
    xor     a
    call    $014E
    ld      a, 0xfe                     ;screen
    jp      $0112
