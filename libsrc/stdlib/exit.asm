;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>
;
;Exit routine, rewritten 27/11/98 so to traverse the atexit stack
;
;Constantly revisited through April
;Some of the opt rules cause this routine to be jumped to instead
;of called, so we don't use the stack, instead we use hl as our
;entrance variable...we're buggered if we define a pointer to here
;though...
;
; -----
; $Id: exit.asm,v 1.2 2001-04-18 12:43:04 stefano Exp $


                XLIB    exit    ;outta here!

                XREF    cleanup
                XREF    exitsp
                XREF    exitcount
                XREF    l_dcal


;This also allows for an atexit function to print a bye bye message
;or whatever... - no parameters are passed into it...

.exit
        push    hl      ;preserve exit value
        ld      a,(exitcount)
        and     a
        jr      z,exit2
;Now, traverse the atexit routines in reverse ordr
        ld      b,a
.exit1
        push    bc
        dec     b               ;so calc correct offset
        ld      l,b
        ld      h,0
        add     hl,hl           ;x2
        ld      de,(exitsp)     ;start of atexit stack
        add     hl,de
        ld      a,(hl)
        inc     hl
        ld      h,(hl)
        ld      l,a
        call    l_dcal  ;jp(hl)
        pop     bc
        djnz    exit1
;Disrupt the stack completely, and exit with an appropriate error
.exit2
        pop     hl      ;return value. load into a then we can display
        ld      a,l     ;a warning message (basic)
        jp      cleanup


        





IF ARCHAIC
.exit
        ld      hl,(prog_atexitrout)
        ld      a,h
        or      l
        jp      z,cleanup
        ld      de,cleanup      ;system clean up address
        push    de
        jp      (hl)
ENDIF
