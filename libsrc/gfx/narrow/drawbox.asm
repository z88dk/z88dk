
  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION code_graphics

        PUBLIC  drawbox

;
;    $Id: drawbox.asm $
;

; ***********************************************************************
;
; Draw a box.
; Generic version
;
; Stefano Bodrato - March 2002
;
;
; IN:    HL    = (x,y)
;    BC    = (width,heigth)
;

drawbox:
        push    bc
        push    hl

; -- Vertical lines --
        push    hl
        ld      a, h
        add     a, b
        dec     a
        ld      h, a
        pop     de
rowloop:
        push    bc

        call    p_sub
        inc     l
        ex      de, hl

        call    p_sub
        inc     l
        ex      de, hl

        pop     bc
        dec     c
        jr      nz, rowloop

        pop     hl
        pop     bc

; -- Horizontal lines --
        inc     h
        dec     b
        dec     b
        push    hl
        ld      a, l
        add     a, c
        dec     a
        ld      l, a
        pop     de

vrowloop:
        push    bc

        call    p_sub
        inc     h
        ex      de, hl

        call    p_sub
        inc     h
        ex      de, hl

        pop     bc

        djnz    vrowloop

        ret

p_sub:
        push    hl
        push    de
        ld      de, p_RET1
        push    de
        jp      (ix)                    ;    execute PLOT at (h,l)
p_RET1:
        pop     de
        pop     hl
        ret
  ENDIF
