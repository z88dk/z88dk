;       Small C+ Z88 stdlib functions
;
;       Provides for a routine to be executed on exit
;
;       18/10/98 djm
;       27/11/98 djm - allows upto 32 levels of exit routines
;
; -----
; $Id: atexit.asm,v 1.2 2001-04-18 12:43:04 stefano Exp $


;int atexit((void *)(void))


                XLIB    atexit

;                XREF    prog_atexitrout

                XREF    exitsp
                XREF    exitcount



.atexit
        pop     bc
        pop     de      ;this should be ok, even for long pointers!
        push    de      ;routines always in main 64k
        push    bc
;de holds the address of an atexit routine
        ld      hl,exitcount
        ld      a,(hl)
        cp      32      ;can only hold 32 levels..
        ret     z       ;if full, hl!=0 (hl=exitcount!)
;It's okay, we can add another level
        inc     (hl)    ;increment it then...
;find the offset from exitsp..a still holds original level..
        add     a,a     
        ld      c,a
        ld      b,0
        ld      hl,(exitsp)
        add     hl,bc
        ld      (hl),e
        inc     hl
        ld      (hl),d
        ld      hl,0    ;was fine, exit hl=0
        ret

        



IF ARCHAIC

.atexit
        pop     bc      ;ret addr
        pop     hl      ;routine
        push    hl
        push    bc
        ld      (prog_atexitrout),hl
        ret
ENDIF
