; void wherey()
; 09.2017 stefano

SECTION code_clib
PUBLIC wherey
PUBLIC _wherey

EXTERN __console_y

.wherey
._wherey

    ld      a,(__console_y)
    ld      l,a
    ld      h,0
IF __CPU_GBZ80__
    ld      d,h
    ld      e,l
ENDIF
    ret
