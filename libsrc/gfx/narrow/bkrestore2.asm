;
;    Fast background save
;
;    Generic version (just a bit slow)
;
;    $Id: bkrestore2.asm $
;

  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION code_clib


        EXTERN  putsprite
        EXTERN  asm_clga

        PUBLIC  bkrestore
        PUBLIC  _bkrestore
        PUBLIC  bkrestore_fastcall
        PUBLIC  _bkrestore_fastcall

bkrestore:
_bkrestore:
        pop     de
        pop     hl
        push    hl
        push    de

bkrestore_fastcall:
_bkrestore_fastcall:


    ; __FASTCALL__ !!   HL = sprite address

        inc     hl                      ; skip first X xs
        inc     hl                      ; skip first Y ys

; spr_and:  166+47*256 // CPL - AND (HL)
; spr_or:   182 // OR (HL)

        ld      de, 182                 ; spr_or
        push    de

        ld      e, (hl)                 ; x pos
        inc     hl
        ld      a, e
    ;ld    d,0    <- d=0 already
        push    de

        ld      e, (hl)                 ; Y pos
        inc     hl
        push    de

        push    hl                      ; sprite addr

        ld      b, (hl)                 ; saved X sz
        inc     hl
        ld      c, (hl)                 ; saved Y sz

        ld      h, a                    ; X
        ld      l, e                    ; Y

    ; HL    = (x,y)
    ; BC    = (width,heigth)
        call    asm_clga

        call    putsprite

        pop     hl
        pop     de
        pop     de
        pop     de

        ret
  ENDIF
