;       Z88 Small C+ Run Time Library 
;       Long functions
;

                XLIB    l_long_add





;primary = secondary + primary
;enter with secondary, primary on stack

IF ARCHAIC
.l_long_add
        ld      b,h     ;store lower 16 in bc temporarily
        ld      c,l
        ld      hl,2
        add     hl,sp   ;points to hl on stack
        ld      a,c
        add     a,(hl)
        inc     hl
        ld      c,a
        ld      a,b
        adc     a,(hl)
        inc     hl
        ld      b,a
        ld      a,e
        adc     a,(hl)
        inc     hl
        ld      e,a
        ld      a,d
        adc     a,(hl)
        ld      d,a
;Done the adding, now do some tidying up!
        exx
        pop     bc      ;return address
        pop     hl      ;discard entry long
        pop     hl
        push    bc      ;dump return address back
        exx
        ld      l,c     ;get the lower 16 back into hl
        ld      h,b
        ret
ENDIF
; This routine appears to cause horrendous crashes, but I'm not
; sure why...mysterious!

.l_long_add
        
        ld      a,l
        exx     ;2
        pop     bc      ;ret address
        pop     hl      ;secondary
        pop     de
        push    bc
        add     a,l
        ld      l,a
        ld      a,h
        exx     ;1
        adc     a,h
        exx     ;2
        ld      h,a
        ld      a,e
        exx     ;1
        adc     a,e
        exx     ;2
        ld      e,a
        ld      a,d
        exx     ;1
        adc     a,d
        exx     ;2
        ld      d,a
        ret

