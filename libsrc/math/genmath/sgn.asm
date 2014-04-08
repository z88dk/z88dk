;
;       Z88dk Generic Floating Point Math Library
;
;       set z and Z flags per fa
;
;	$Id: sgn.asm,v 1.2 2014-04-08 07:06:20 stefano Exp $:


		XLIB	sgn
	
		XDEF	setflgs

		XREF	fa

.sgn    LD      A,(fa+5)
        OR      A
        RET     Z
        LD      A,(fa+4)
        DEFB    $FE    ;"ignore next byte"
.setflgs
        CPL
        RLA
        SBC     A,A
        RET     NZ
        INC     A
        RET

