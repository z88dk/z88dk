;       The integer printf routine
;       Is compiled C, but been optimized by hand
;       An awful lot of work went into this - some 400 hundred
;       or so bytes have been winkled out!
;
;       13/10/98



                XLIB printf1
                LIB utoi
                LIB itod
                LIB itou
                LIB itox
                LIB pf_outc
                XREF _pf_string
                XREF _pf_count
                LIB     l_gint
                LIB     l_pint
                LIB     l_gt

.printf1
        ld      hl,-26
        add     hl,sp
        ld      sp,hl
        ld      hl,0
        ld      (_pf_count),hl
;ctl=*nxtarg
        ld      hl,28
        add     hl,sp
        call    l_gint
        call    l_gint
        pop     de
        pop     bc
        push    hl
        push    de
.i_2
; while (c=*ctl++)
        ld      hl,17
        add     hl,sp
        push    hl      ;c
        ld      hl,4    ;ctl
        add     hl,sp
        push    hl
        call    l_gint
        ld      a,(hl)  ;character, keep it safe in a'
        ex      af,af'
        inc     hl
        pop     de
        call    l_pint
        ex      af,af'
        pop     de
        ld      (de),a
        and     a
        jp      z,i_3   ;if zero, end of string out of here

;ATP a is our character..keep it safe in c
;also hl=ctl


;If character isnt % then print it
        cp      '%'
        jr      z,i_4
.i_djm1
        ld      l,a
        ld      h,0
        push    hl
        ld      hl,32
        add     hl,sp   ;fd - stream
        call    l_gint
        push    hl
        call    pf_outc
        pop     bc
        pop     bc
        jp      i_2

;Come here if we have a percentage
;If the next character is % then print it out.
;Remember, hl holds ctl so we can just get it out..
.i_4
        ld      a,(hl)
        cp      '%'
        jr      nz,i_5  ;wasn't percentage
;Now, we have to increment the ctr
        inc     hl
        ex      de,hl
        ld      hl,2
        add     hl,sp
        ex      de,hl
        call    l_pint
        ld      a,'%'
        jr      i_djm1
;We still have ctl in hl
.i_5
;cx=ctl
        pop     bc
        push    hl
;Now, check if *cx = '-'
;if *cx='-'
        ld      a,(hl)
        ex      de,hl   ;de=cx
        cp      '-'
        jr      nz,i_6
;right=0 (char)
        ld      hl,16
        add     hl,sp   ;right
        ld      (hl),0
;++cx
        inc     de      ;cx
;store cx..
        pop     bc
        push    de
        jr      i_7
.i_6
;else right = 1
        ld      hl,16
        add     hl,sp
        ld      (hl),1
;ATP cx is in de
.i_7
;if *cx = '0'
        ld      a,(de)
        cp      '0'
        jr      nz,i_8
;pad='0'
        ld      hl,8
        add     hl,sp
        ld      (hl),'0'
;cx++
        inc     de
        pop     bc
        push    de
        jr      i_9
;else pad=' '
.i_8
        ld      hl,8
        add     hl,sp
        ld      (hl),' '

;ATP de=cx still
.i_9
;if ( ( i=utoi(cx, &width)) >= 0 )
        ld      hl,24
        add     hl,sp
        push    hl      ;i
        push    de      ;last we'll see of cx I think!
        ld      hl,10
        add     hl,sp
        push    hl      ;&width
        call    utoi
        pop     bc
        pop     bc
        pop     de      ;i
        call    l_pint
;test if i>=0
        xor     a
        or      h
        jp      m,i_2   ;continue
;hl=i
;cx +=i
        pop     de      ;cx (from auto)
        add     hl,de   ;cx +=i
        push    hl      ;store cx again
;if *cx=='.'
;hl=cx
        ld      a,(hl)
        cp      '.'
        jr      nz,i_12
;     { if ( ( preclen=utoi(++cx, &prec)) >=0 )
;   Deal with ++cx first of all
        pop     de
        inc     de
        push    de
        ld      hl,20
        add     hl,sp
        push    hl      ;preclen
        push    de      ;cx
        ld      hl,26
        add     hl,sp
        push    hl      ;&prec
        call    utoi
        pop     bc
        pop     bc
        pop     de
        call    l_pint
        xor     a
        or      h
        jp      m,i_2   ;continue
;cx += preclen
;hl = preclen
        pop     de      ;cx is first variable
        add     hl,de
        push    de
        jr      i_15
; [ *cx != '.']
; else preclen=0
.i_12
        ld      hl,20
        add     hl,sp
        ld      (hl),0
        inc     hl
        ld      (hl),0
;sptr=str i.e. sptr=&str (sptr is char *sptr]
.i_15
        ld      hl,4
        add     hl,sp
        push    hl
        ld      hl,11
        add     hl,sp
        pop     de
        call    l_pint
;c=cx++
        pop     de
        ld      a,(de)
        inc     de      ;cx++
        push    de

        ld      hl,17
        add     hl,sp
        ld      (hl),a  ;c=*cxr++
        ex      af,af'  ;keep c safe in a'

;i=*(--nxtarg)
        ld      hl,24
        add     hl,sp
        push    hl
        ld      hl,30
        add     hl,sp   ;next arg
        push    hl
        call    l_gint
        dec     hl
        dec     hl
        pop     de
        call    l_pint
        call    l_gint
        pop     de      ;&i
        call    l_pint

;switch(c)
        ex      af,af'  ;retrieve c
        cp      'd'
        jr      z,i_19
        cp      'x'
        jr      z,i_20
        cp      'c'
        jr      z,i_21
        cp      's'
        jr      z,i_22
        cp      'u'
        jr      z,i_23
        jp      i_2     ;default

; case 'd'
.i_19
        ld      hl,24
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,11
        add     hl,sp
        push    hl
        ld      hl,7
        push    hl
        call    itod
        pop     bc
        pop     bc
        pop     bc
        jp      i_17
; case 'x'
.i_20
        ld      hl,24
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,11
        add     hl,sp
        push    hl
        ld      hl,7
        push    hl
        call    itox
        pop     bc
        pop     bc
        pop     bc
        jp      i_17
;case 'c'
.i_21
        ld      hl,9
        add     hl,sp
        push    hl
        ld      hl,26
        add     hl,sp
        call    l_gint
        pop     de
        ld      a,l
        ld      (de),a
        inc     de
        xor     a
        ld      (de),a
        jp      i_17
;case 's'
.i_22
        ld      hl,4
        add     hl,sp
        push    hl
        ld      hl,26
        add     hl,sp
        call    l_gint
        pop     de
        call    l_pint
        jp      i_17
;case 'u'
.i_23
        ld      hl,24
        add     hl,sp
        call    l_gint
        push    hl
        ld      hl,11
        add     hl,sp
        push    hl
        ld      hl,7
        push    hl
        call    itou
        pop     bc
        pop     bc
        pop     bc


;ctl=cx
.i_17
        pop     hl      ;cx
        pop     de      ;ctl
        push    hl      ;ctl
        push    hl      ;cx
; if c!='s'
        ld      hl,17
        add     hl,sp
        ld      a,(hl)
        cp      's'
        jr      z,i_25
; while ( *sptr == ' ') ++sptr;
.i_26
        ld      hl,4
        add     hl,sp
        push    hl
        call    l_gint
.i_djm2
        ld      a,(hl)
        inc     hl
        cp      ' '
        jr      z,i_djm2
;We incremented one too far, so decrement and store sptr
        dec     hl
        pop     de      ;where it should go
        call    l_pint

.i_27
;len=-1 [almagamated with loop]
.i_25
; while ( sptr[++len] ) ;
.i_28
        ld      hl,4
        add     hl,sp   ;sptr
        call    l_gint
        ld      de,-1   ;len
;My quick loop now
;hl=sptr, de=len
.i_djm4
        inc     de
        ld      a,(hl)
        inc     hl      ;increment sptr
        and     a
        jr      nz,i_djm4
        ld      hl,18
        add     hl,sp   ;get location of len
        ld      (hl),e
        inc     hl
        ld      (hl),d
; if ( c == 's'&& len>prec && preclen >0 )
.i_29
        ld      hl,17
        add     hl,sp
        ld      a,(hl)
        cp      's'
        jp      nz,i_30
;Cheating.. hl=sp+17 need sp+18
        inc     hl      ;len
        call    l_gint
        push    hl
        ld      hl,24
        add     hl,sp
        call    l_gint  ;prec
        pop     de
        call    l_gt
        ld      a,h
        or      l
        jp      z,i_30
        ld      hl,20
        add     hl,sp   ;preclen
        call    l_gint
        ex      de,hl
        ld      hl,0
        call    l_gt
        ld      a,h
        or      l
        jp      z,i_30
;len=prec
        ld      hl,18
        add     hl,sp
        push    hl
        ld      hl,24
        add     hl,sp
        call    l_gint
        pop     de
        call    l_pint
; if (right)
.i_30
        ld      hl,16
        add     hl,sp
        ld      a,(hl)
        and     a
        jp      z,i_33
; whle ( ((width--)-len) > 0 )
.i_34
        ld      hl,6
        add     hl,sp
        push    hl
        call    l_gint
        dec     hl
        pop     de
        call    l_pint
        inc     hl
        push    hl
        ld      hl,20
        add     hl,sp   ;len
        call    l_gint
        ex      de,hl
        pop     hl      ;width
        and     a
        sbc     hl,de
        xor     a       ;test for zero
        or      h
        jp      m,i_35
        or      l
        jp      z,i_35
;pf_outc(pad,fd)
        ld      hl,8
        add     hl,sp
        ld      l,(hl)
        ld      h,0
        push    hl
        ld      hl,32
        add     hl,sp   ;fd
        call    l_gint
        push    hl
        call    pf_outc
        pop     bc
        pop     bc
        jp      i_34
.i_35
.i_33
; while (len)
.i_36
;do the len-- here..
        ld      hl,18
        add     hl,sp
        push    hl      ;keep address
        call    l_gint
        pop     de      ;restore it
        ld      a,h
        or      l
        jp      z,i_37
        dec     hl
        call    l_pint  

        ld      hl,4
        add     hl,sp   ;sptr
        push    hl
        call    l_gint
        inc     hl      ;sptr++
        pop     de
        call    l_pint
        dec     hl
        ld      l,(hl)
        ld      h,0
        push    hl
        ld      hl,32
        add     hl,sp   ;fd
        call    l_gint
        push    hl
        call    pf_outc
        pop     bc
        pop     bc
;--width
        ld      hl,6
        add     hl,sp
        push    hl
        call    l_gint
        dec     hl
        pop     de
        call    l_pint
        jp      i_36
.i_37
.i_38
        ld      hl,6
        add     hl,sp   ;width
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        dec     de      ;width--
        ld      (hl),d
        dec     hl
        ld      (hl),e
        inc     de      ;width restored
        ld      hl,20
        add     hl,sp   ;len
        call    l_gint  ;hl=len
        ex      de,hl
        and     a
        sbc     hl,de
        xor     a
        or      h
        jp      m,i_2
        or      l
        jp      z,i_2
        ld      hl,8
        add     hl,sp   ;pad
        ld      l,(hl)
        ld      h,0     
        push    hl
        ld      hl,32
        add     hl,sp   ;fd
        call    l_gint
        push    hl
        call    pf_outc
        pop     bc
        pop     bc
        jp      i_38
;if (pf_string != 0_ *pfstring= '\000';
.i_3
        ld      hl,(_pf_string)
        ld      a,h
        or      l
        jr      z,i_40
        ld      hl,(_pf_string)
        ld      (hl),0
; return (pf_count);
.i_40
        ld      hl,26
        add     hl,sp
        ld      sp,hl   ;restore count
        ld      hl,(_pf_count)   ;number of chars printed
        ret

