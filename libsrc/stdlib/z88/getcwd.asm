;
;       Z88 Small C+ Library Functions
;
;       Find current directory
;
;       Added to Small C archive 12/3/99
;
;       char *getcwd(char *buffer, int maxlen)
;
;       *** Z88 SPECIFIC ROUTINE - UNTESTED!!! ***
;
;       This functions needs Gunthers' standard.lib
;

                INCLUDE "#syspar.def"

                XLIB    getcwd
                LIB    readbyte        ;standard.lib

.getcwd
        ld      hl,2
        add     hl,sp
        ld      c,(hl)          ;max length
        inc     hl
        ld      b,(hl)
        inc     hl
        ld      e,(hl)          ;buffer to dump it into
        inc     hl
        ld      d,(hl)
        push    de
        push    bc
        ld      bc,NQ_dir       ;ask for current directory
        call_oz(os_nq)
        exx
        pop     bc              ;max len
        pop     de              ;buffer
        ld      l,d             ;keep buffer safe in hl
        ld      h,e
        exx
        ret     c
;Copying loop here..
.getcwd2
        exx
        ld      a,c
        or      b
        ret     z               ;we've filled our buffer
        exx
        call    readbyte
        inc     hl
        exx
        ld      (de),a
        and     a
        ret     z               ;end of dir string
        inc     de
        dec     bc
        jr      getcwd2
        
        
