;
;    Fast background save
;
;    Generic version (just a bit slow)
;
;    $Id: bkrestore3.asm $
;

  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION code_clib


        EXTERN  plotpixel
        EXTERN  respixel

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

        push    ix

        inc     hl                      ; skip first X xs
        inc     hl                      ; skip first Y ys

        ld      d, (hl)                 ; x pos
        inc     hl
        ld      e, (hl)                 ; Y pos
        inc     hl

        push    hl                      ; sprite addr
        pop     ix

;    ld    h,a    ; X
;    ld    l,e    ; Y

        ld      h, d
        ld      l, e

        ld      a, (ix+0)               ; Width
        ld      b, (ix+1)               ; Height
oloopx: push    bc                      ;Save # of rows
        push    af

    ;ld    b,a    ;Load width
        ld      b, 0                    ; Better, start from zero !!

        ld      c, (ix+2)               ;Load one line of image

iloopx:                                 ;sla    c    ;Test leftmost pixel
    ;jr    nc,noplotx    ;See if a plot is needed

        push    hl
    ;push    bc    ; this should be done by the called routine
        push    de
        ld      a, h
        add     a, b
        ld      h, a
        sla     c                       ;Test leftmost pixel
        push    af
        call    nc, respixel
        pop     af
        call    c, plotpixel
        pop     de
    ;pop    bc
        pop     hl

;.noplotx

        inc     b                       ; witdh counter

        pop     af
        push    af

        cp      b                       ; end of row ?

        jr      nz, noblkx

        inc     ix
        ld      c, (ix+2)               ;Load next byte of image

        jr      noblockx

noblkx:

        ld      a, b                    ; next byte in row ?
    ;dec    a
        and     a
        jr      z, iloopx
        and     7

        jr      nz, iloopx

blockx:
        inc     ix
        ld      c, (ix+2)               ;Load next byte of image
        jr      iloopx

noblockx:

        inc     l

        pop     af
        pop     bc                      ;Restore data
        djnz    oloopx

        pop     ix
        ret


  ENDIF
