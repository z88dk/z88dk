;
;       Amstrad CPC Graphics Functions
;
;	by Stefano Bodrato  - Jul 2004
;
;
;	$Id: undrawr.asm,v 1.4 2015-01-19 01:32:47 pauloscustodio Exp $
;


                
        PUBLIC    undrawr
		EXTERN     drawr

        INCLUDE "cpcfirm.def"

        INCLUDE	"graphics/grafix.inc"

.hlsave	defw	0

.undrawr
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

