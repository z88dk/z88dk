; Internal routine to read double at far pointer
; 31/3/00 GWL

; Entry: EHL=far pointer
; Exit: FA->FA+5=double


        XLIB    lp_gdoub
        XREF    fa

        LIB     farseg1,incfar


.lp_gdoub
        ld      a,($04d1)
	ex	af,af'
        ld      b,h
        ld      c,l
        call    farseg1
        ld      a,(hl)
        ld      ixl,a
        call    incfar
        ld      a,(hl)
        ld      ixh,a
        call    incfar
        ld      a,(hl)
        ld      iyl,a
        call    incfar
        ld      a,(hl)
        ld      iyh,a
        call    incfar
        ld      a,(hl)
        call    incfar
        ld      h,(hl)
        ld      l,a             ; double now in HLIYIX
	ex	af,af'
        ld      ($04d1),a
        out     ($d1),a
        ld      (fa),iy
        ld      (fa+2),ix
        ld      (fa+4),hl
        ret

