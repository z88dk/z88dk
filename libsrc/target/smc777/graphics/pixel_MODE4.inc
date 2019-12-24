
        EXTERN w_pixeladdress_320
        EXTERN __gfx_coords

        INCLUDE        "graphics/grafix.inc"

        EXTERN        __smc777_ink16
        EXTERN        __smc777_paper16
        EXTERN        getmaxy
        EXTERN        getmaxx
        EXTERN        l_cmp

; Generic code to handle the pixel commands
; Define NEEDxxx before including
;
; 4 bits per pixel in MODE4(not updated)

        push    hl          ;save x
        call    getmaxy             ;hl = maxy
        inc     hl
        call    l_cmp
        pop     hl
        ret     nc

        ex      de,hl               ;de = x, hl = y
        push    hl          ;save y
        call    getmaxx
        inc     hl
        call    l_cmp
        pop     hl
        ret     nc
        ex      de,hl
        ld      (__gfx_coords),hl   ;x
        ld      (__gfx_coords+2),de ;y
        push    bc
        call    w_pixeladdress_320
        ld      b,h
        ld      c,l
        ld      h,a
IF NEEDunplot
        ld      a,(__smc777_paper16)
ELSE
        ld      a,(__smc777_ink16)
ENDIF
        ld      e,a
        ld      a,@00001111
        jr      z, rotated         ; pixel is at bit 0...
.plot_position        
        rlca
        rlca
        rlca
        rlca
        rlc     e
        rlc     e    
        rlc     e
        rlc     e    
        dec     h
        jr      nz,plot_position
rotated:
        ld      h,a                ;the pixel mask
        cpl
        ld      l,a                ;the excluded mask
        ld      a,e
        and     h
        ld      e,a    
        ; e = byte holding pixels to plot
        ; h = byte holding pixel mask
        ; l = byte holding mask exlcuding this pixel
        ; bc = address
        in      a,(c)
IF NEEDplot | NEEDunplot
        and     l
        or      e
        out     (c),a
ENDIF
IF NEEDxor
        xor     e
        out     (c),a
ENDIF
IF NEEDpoint
        and     h
ENDIF
        pop     bc                ;Restore callers
        ret
