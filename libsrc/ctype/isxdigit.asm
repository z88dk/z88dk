;
; Small C+ z88 Character functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
;
; 1/3/99 djm
;
; This routine is a little bit unwieldy to say the least

                XLIB    isxdigit


;isxdigit (c) char c - test for hex characters
;return address, c

.isxdigit
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
        ld      hl,0    ;fail
        cp      '0'
        ret     c       
        inc     hl      ;hl=1 success
        cp      '9'+1   ;':'
        ret     c       ;success, have matched digit

;Now we have to check for characters 'afAF'

        dec     hl      ;hl=0 fail
        cp      'A'
        ret     c
        cp      'f'+1
        ret     nc
        and     223
        cp      'A'
        ret     c
        cp      'F'+1
        ret     nc
        inc     hl      ;success
        ret




