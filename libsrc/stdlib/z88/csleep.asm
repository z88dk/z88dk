;
; Small C z88 Misc functions
;
; sleep(time)
;
; Pause for time centiseconds
;
; djm 1/12/98
;
; If we can't have usleep we'll have csleep instead!


                INCLUDE "#time.def"

                XLIB    csleep

;csleep(int time);


.csleep
        pop     hl
        pop     bc      ;number of centi-seconds..
        push    bc
        push    hl
        ld      a,b
        or      c
        jr      z,csleep1
        call_oz(os_dly)
        ld      hl,1
        ret     c
.csleep1
        ld      hl,0
        ret


