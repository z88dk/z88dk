;
;       Small C+ Long Library Functions
;
;       Divide 2 32 bit numbers
;
;       Hopefully this routine does work!
;
;       I think the use of ix is unavoidable in this case..unless you know
;       otherwise!
;
;       This is for unsigned quantities..separate routine for signed..

                XLIB    l_long_div_u





; 32 bit division
; Entry: arg1 on stack under return address, dehl=arg2
; Exit:  dehl=result, de'hl'=remainder
;
; The number on the stack is stored LSB first
;

.l_long_div_u
;Check for dividing by zero
        ld      a,d
        or      e
        or      h
        or      l
        jr      nz,l_long_div0  
; Zero, return with dehl=0 dehl=arg1
        exx
        pop     bc
        pop     hl
        pop     de
        push    bc
        exx
        ret
.l_long_div0
        ld      ix,2
        add     ix,sp           ;points to arg1
        ld      b,32            ;counter
        push    hl              ;lower 16 of arg2
        exx
        pop     de
        ld      hl,0            ;lower 16 of res1
        exx
        ld      hl,0            ;upper 16 of res1
        and     a               ;clear carry
.l_long_div1
        rl      (ix+0)          ;arg1 << 1 -> arg1
        rl      (ix+1)
        rl      (ix+2)
        rl      (ix+3)
        exx                     ;res1 << 1 -> res1
        rl      l               ;lower 16
        rl      h
        exx
        rl      l               ;upper 16
        rl      h
        exx                     ;res1 - arg2 -> res1
        sbc     hl,de           ;lower 16
        exx
        sbc     hl,de           ;upper 16
        jr      nc,l_long_div2  ;don't add
        exx                     ;res1 + arg2 -> res1
        add     hl,de           ;lower 16
        exx
        adc     hl,de
.l_long_div2
        ccf
        djnz    l_long_div1
; It was so very tempting to use instructions along the lines of
; ld l,rl(ix+0) here..it would work, would annoy the hackers, but
; I don't think it would be any faster :(
                                ;arg1 << 1 -> arg1
        rl      (ix+0)
        rl      (ix+1)
        rl      (ix+2)
        rl      (ix+3)
;Now we have to return arg1 in dehl and res1 in dehl'
;As well as clear up the stack!
        push    hl      ;upper 16 of res1
        exx
        pop     de
        exx             ;so res1 is now safe in alternate registers
        pop     bc      ;return address
        pop     hl      ;lower 16 of arg1
        pop     de      ;upper 16
        push    bc
        ret
