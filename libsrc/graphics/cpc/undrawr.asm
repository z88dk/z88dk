;
;       Amstrad CPC Graphics Functions
;
;	by Stefano Bodrato  - Jul 2004
;
;
;	$Id: undrawr.asm,v 1.5 2016-06-19 21:10:08 dom Exp $
;


        SECTION   code_clib                
        PUBLIC    undrawr
        PUBLIC    _undrawr
		EXTERN     drawr

        INCLUDE "cpcfirm.def"

        INCLUDE	"graphics/grafix.inc"


.undrawr
._undrawr
        ld      a,bcolor
        call    firmware
        defw    gra_set_pen
        pop     hl
        ld      (hlsave),hl
        call	drawr
        ld      hl,(hlsave)
        push	hl
        ld      a,fcolor
        call    firmware
        defw    gra_set_pen
        ret

	SECTION	bss_clib
.hlsave	defw	0
