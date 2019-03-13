;
;       Kaypro II pseudo graphics routines
;
;       Stefano Bodrato 2018
;
;
;        $Id: plot_end_83.asm $
;

        SECTION code_graphics
        PUBLIC  plot_end
        PUBLIC  plot_decode
        EXTERN  __gfx_coords

.plot_decode
        ld      (__gfx_coords),hl
                        
        ld      c,a
        srl     a
        ld      b,a        ;y/2
        ld      a,h
        ld      hl,$3000 - 128
        ld      de,128
        inc     b
yloop:  add     hl,de
        djnz    yloop
        ld      e,a
        add     hl,de
        ld      a,(hl)
        and     a                ; ' = top
        ld      a,1
        jr      z,ydone
        ld      a,(hl)
        cp      ','                ; bottom
        ld      a,2
        jr      z,ydone
        ld      a,(hl)
        cp      '|'                ; top+bottom
        ld      a,3
        jr      z,ydone
        xor     a
.ydone
        rr      c
        ret

        
.plot_end
        push    hl
        ld      hl,chars
        add     l
        ld      l,a
        jr      nc,nocy
        inc     h
.nocy
        ld      a,(hl)
        pop     hl
        ld      (hl),a
        pop     bc
        ret

chars:  defb ' ',0,',','|'

