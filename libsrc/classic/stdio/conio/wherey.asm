; void wherey()
; 09.2017 stefano

SECTION code_clib
PUBLIC wherey
PUBLIC _wherey

EXTERN __console_y
EXTERN __console_h

.wherey
._wherey
    ld      a,(__console_h)
    ld      l,a
    ld      a,(__console_y)
    cp      l
    jr      c,not_max
    ld      a,l
    dec     a
not_max:
    ld      l,a
    ld      h,0
IF __CPU_GBZ80__
    ld      d,h
    ld      e,l
ENDIF
    ret
