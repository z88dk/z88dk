;       Z88 Small C+ Run Time Library 
;       Long functions
;
;       djm 21/2/99
;       The old routine is fubarred! Written a new one now..but
;       I'm mystified!

                XLIB    l_long_sub


;primary = secondary - primary
;enter with secondary, primary on stack

IF ARCHAIC
.l_long_add
        ld      b,h     ;store lower 16 in bc temporarily
        ld      c,l
        ld      hl,2
        add     hl,sp   ;points to hl on stack
        ld      a,c
        sub     a,(hl)
        inc     hl
        ld      c,a
        ld      a,b
        sbc     a,(hl)
        inc     hl
        ld      b,a
        ld      a,e
        sbc     a,(hl)
        inc     hl
        ld      e,a
        ld      a,d
        sbc     a,(hl)
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


;This routines also messes things up not inconsiderably..mystified!
;

.l_long_sub 
        exx             ;2nd
        pop     bc
        pop     hl
        pop     de
        push    bc
        ld      a,l
        exx
        sub     l
        ld      l,a
        exx             ;1st
        ld      a,h
        exx             ;2nd
        sbc     a,h
        ld      h,a
        exx             ;1st
        ld      a,e
        exx             '2md
        sbc     a,e
        ld      e,a     
        exx             ;1st
        ld      a,d
        exx             ;2nd
        sbc     a,d
        ld      d,a
        ret

