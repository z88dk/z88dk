;
; Small C z88 Misc functions
;
; Return absolute value 
; This is interesting method, but so much quicker than what a compiled
; version would do..


                XLIB    abs
                LIB     l_neg

;abs(int num)       int num;

; I will figure out -ve numbers one day...this one will work now!
; oh no it won't not, if you try to turn +ve into -ve..fixed 29/11/98


.abs
        pop     bc      ;ret addr
        pop     hl      ;number
        push    hl
        push    bc
        bit     7,h
        call    nz,l_neg
        ret



;Gimme speed, much improved version!

;.abs
;        pop     bc
;        pop     hl      ;num
;        res     7,h     ;simply reset the sign bit!
;        push    hl
;        pop     bc
;        ret




;.abs
;        ld      hl,3            ;going down!
;        add     hl,sp
;        ld      a,(hl)
;        dec     hl
;        ld      l,(hl)
;        ld      h,a
;        rlca            ;test bit 7 of h
;        ret     nc       ;is zero ie 0-32767
;        res     7,h     ;force range
;        ret
