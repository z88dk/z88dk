;
;       Small C+ TCP Implementation
;
;       htonl() Convert host to network format and back again!
;
;       djm 24/4/99


                SECTION   code_crt0_sccz80
                PUBLIC    htonl

.htonl
        ld      a,l
        ld      l,d
        ld      d,a
        ld      a,h
        ld      h,e
        ld      e,a
        ret

