;
;  itox -- converts nbr to hex string of length sz
;              right adjusted and blank filled, returns str
; 
;             if sz > 0 terminate with null byte
;             if sz  =  0 find end of string
;             if sz < 0 use last byte for data
;
;
;       Used by printf, compiled C and hand optimized
;
;       13/10/98 djm

;itox(int nbr. char str[], int sz]



                PUBLIC    itox
                EXTERN     l_gint
                EXTERN     l_pint
                EXTERN     l_neg
                EXTERN     l_and
                EXTERN     l_asr

.itox
; if (sz > 0)
        ld      hl,2
        add     hl,sp
        push    hl
        call    l_gint
        pop     de
        xor     a
        or      h
        jp      m,i_2
        or      l
        jr      z,i_2
; str[--sz] = NULL
        dec     hl      ;--sz
        call    l_pint  ;store sz
        ex      de,hl   ;keep it
        ld      hl,4
        add     hl,sp   ;str
        call    l_gint
        add     hl,de
        ld      (hl),0
        jr      i_3

; else if (sz <0)
;get here with hl=sz
;and    de=&sz
.i_2
        xor     a
        or      h
        jp      p,i_4
;sz=-sz
        call    l_neg
        call    l_pint  ;store sz (de=&sz - unaffected by l_neg)
        jr      i_5
.i_4
; else while (str[sz] != NULL) ++sz
;when we get here: hl=sz de=&sz
.i_6
        push    de      ;&sz
        ex      de,hl   ;keep safe (de=sz)
        ld      hl,4
        add     hl,sp   ;str
        call    l_gint
        add     hl,de
.i_djm1
        ld      a,(hl)
        inc     hl
        inc     de
        and     a
        jr      nz,i_djm1
;We've incremeted sz one too far so undo
        dec     de
        ex      de,hl
        pop     de      ;sz
        call    l_pint

.i_7
.i_5
.i_3
.i_8
; while (sz)
; digit= nbr & 15;
        ld      hl,2
        add     hl,sp   ;sz
        call    l_gint
        ld      a,h
        or      l
        jp      z,i_9
        ld      hl,6
        add     hl,sp   ;nbr
        ld      a,(hl)
        and     15
        ex      af,af'  ;keep digit
; nbr = ( nbr >> 4) & fff

        ld      hl,6
        add     hl,sp   ;nbr
        push    hl
        call    l_gint
        ex      de,hl
        ld      hl,4
        call    l_asr
        ex      de,hl
        ld      hl,4095
        call    l_and
        pop     de      ;nbr
        call    l_pint

        ex      af,af'  ;retrieve digit
        ld      e,'0'
        cp      10
        jr      c,i_djm2
        ld      e,55    ;'A'-10
.i_djm2
        add     a,e     ;gets the correct hex digit
        ex      af,af'  ;save it
;str[--sz] = digit+offset;
        ld      hl,2
        add     hl,sp   ;sz
        push    hl
        call    l_gint
        dec     hl
        pop     de
        call    l_pint  ;store sz
        ex      de,hl   ;save sz
        ld      hl,4
        add     hl,sp   ;str
        call    l_gint
        add     hl,de   ;str[--sz]
        ex      af,af'  ;a=digit+offset
        ld      (hl),a
; if (nbr == 0) break;
        ld      hl,6
        add     hl,sp   ;nbr
        call    l_gint
        ld      a,h
        or      l
        jr      nz,i_8
.i_9
.i_13
        ld      hl,2
        add     hl,sp   ;sz
        push    hl
        call    l_gint
        pop     de
        ld      a,h
        or      l
        jp      z,i_14
        dec     hl      ;--sz
        call    l_pint  ;store sz
        ex      de,hl   ;keep sz in de
        ld      hl,4
        add     hl,sp   ;str
        call    l_gint
        add     hl,de
        ld      (hl),' '
        jr      i_13
.i_14
        ld      hl,4
        add     hl,sp   ;str
        call    l_gint
        ret


