;
;       Routine to handle menu options
;
;       Called from getk() getkey()
;
;       We've just read in 0 from os_*in so we need to get the command
;       code - this should never occur from BASIC, so the basic crt0
;       file can just be a ret
;
;
;	$Id: getcmd.asm,v 1.2 2001-04-13 14:14:00 stefano Exp $
;

                XLIB    getcmd
                XREF    processcmd

                INCLUDE "#stdio.def"


.getcmd
        call_oz(os_in)
        ld      l,a             ;hl=0 no key pressed if exit
        ld      h,0
        and     a
        ret     z
	cp	$B1		;[]ENTER
	ret	nc		;command code ret with code
        jp      processcmd      ; in crt0
