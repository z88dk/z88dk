;
;       Small C+ Library Functions
;
;       djm 11/3/99
;
;       Check whether a file handle is null or std*
;       If so ret with z=1

                INCLUDE "libdefs.def"


                PUBLIC    fhand_ck

;Entry: de=handle

.fhand_ck
        ld      a,d
        or      e
        ret     z
        ld      hl,stdin
        and     a
        sbc     hl,de
        ret     z
        ld      hl,stdout
        and     a
        sbc     hl,de
        ret     z
        ld      hl,stderr
        and     a
        sbc     hl,de
        ret

