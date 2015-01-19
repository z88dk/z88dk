
;  itod -- convert nbr to signed decimal string of width sz
;              right adjusted, blank filled ; returns str
; 
;             if sz > 0 terminate with null byte
;             if sz  =  0 find end of string
;             if sz < 0 use last byte for data
; 
;       Used for printf - compiled hand optimized C



;itod(int nbr, char str[], sz)




                PUBLIC    itod
                EXTERN     l_gint
                EXTERN     l_pint
                EXTERN     l_neg
                EXTERN     l_div

.itod
        dec     sp
; if (nbr < 0)
        ld      hl,7
        add     hl,sp
        call    l_gint
        xor     a
        or      h
        ld      a,' '   ;for sgn
        jp      p,i_2
;nbr=-nbr
        ld      hl,7
        add     hl,sp
        push    hl
        call    l_gint
        call    l_neg
        pop     de
        call    l_pint
;sgn= '-'
        ld      a,'-'
;flowing through
;else sgn= ' '
.i_2
        ld      hl,0
        add     hl,sp
        ld      (hl),a
;if (sz >0)
.i_3
        ld      hl,3
        add     hl,sp
        call    l_gint
        xor     a
        or      h
        jp      m,i_4
        or      l
        jp      z,i_4
;str[--sz]=NULL
        dec     hl
        ex      de,hl   ;keep --sz sage
        ld      hl,5
        add     hl,sp   ;str
        call    l_gint
        add     hl,de
        ld      (hl),0
        ld      hl,3
        add     hl,sp   ;sz
        ex      de,hl
        call    l_pint
        jr      i_5
; else if sz < 0  sz=-sz

;we already have sz in hl if we come here...
.i_4
        xor     a
        or      h
        jp      p,i_6
;sz=-sz
        ld      hl,3
        add     hl,sp
        push    hl
        call    l_gint
        call    l_neg
        pop     de      ;sz
        call    l_pint
        jr      i_7
.i_6
;else while ( str[sz] != NULL ) ++sz;
.i_8
        ld      hl,3
        add     hl,sp   ;sz
        push    hl
        call    l_gint
        ex      de,hl
        ld      hl,7
        add     hl,sp   ;str
        call    l_gint
;My short and sweet loop
.i_djm1
        add     hl,de
        ld      a,(hl)
        inc     de
        and     a
        jr      nz,i_djm1
;Have gone one step too far..undo
        dec     de
        ex      de,hl
        pop     de      ;&sz
        call    l_pint

.i_9
.i_7
.i_5
.i_10
;While (sz)
        ld      hl,3
        add     hl,sp
        call    l_gint
        ld      a,h
        or      l
        jp      z,i_11
        dec     hl
        ex      de,hl   ;de=--sz
        ld      hl,5
        add     hl,sp   ;str
        call    l_gint
        add     hl,de   ;str[--sz]
        push    hl

        ld      hl,5
        add     hl,sp   ;sz
        ex      de,hl
        call    l_pint

        ld      hl,9
        add     hl,sp   ;nbr
        call    l_gint
        ex      de,hl   ;de=nbr
        ld      hl,10
        call    l_div
        ex      de,hl   ;get modulus
        ld      de,48
        add     hl,de
        pop     de
        ld      a,l
        ld      (de),a
; if (nbr/=10) == 0 break
        ld      hl,7
        add     hl,sp
        push    hl
        call    l_gint
        ex      de,hl
        ld      hl,10
        call    l_div
        pop     de
        call    l_pint
        ld      a,h
        or      l
        jp      nz,i_10
;        jp      nz,i_12
;        jp      i_11
.i_12
;        jp      i_10

; if (sz)
.i_11
        ld      hl,3
        add     hl,sp
        call    l_gint
        ld      a,h
        or      l
        jp      z,i_13
;str[--sz]=sgn
        dec     hl
        ex      de,hl   ;keep --sz safe
        ld      hl,5
        add     hl,sp   ;str
        call    l_gint
        add     hl,de
        push    hl      ;str[--sz]
        ld      hl,5
        add     hl,sp   ;sz
        ex      de,hl
        call    l_pint
        pop     de      ;str[--sz]
        ld      hl,0
        add     hl,sp   ;sgn
        ld      a,(hl)
        ld      (de),a

.i_13

;        while ( sz > 0 )
;                str[--sz] = ' ' ;
.i_14
        ld      hl,3
        add     hl,sp   ;sz
        call    l_gint
        xor     a
        or      h
        jp      m,i_15
        or      l
        jp      z,i_15
        dec     hl
        ex      de,hl   ;keep --sz
        ld      hl,5
        add     hl,sp   ;str
        call    l_gint
;str[--sz]=' ';
;de=sz
        add     hl,de   ;str[--sz]
        ld      (hl),' '
        ld      hl,3
        add     hl,sp   ;store sz
        ex      de,hl
        call    l_pint
        jr      i_14
.i_15
        ld      hl,5
        add     hl,sp
        call    l_gint
        inc     sp
        ret


