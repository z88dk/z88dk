;
;       Z88dk Generic Floating Point Math Library
;
;       set z and Z flags per fa
;
;	$Id: sgn.asm,v 1.1 2008-07-27 21:44:58 aralbrec Exp $:


		XLIB	sgn
	
		XDEF	setflgs

		XREF	fa

.SGN    LD      A,(FA+5)
        OR      A
        RET     Z
        LD      A,(FA+4)
        DEFB    $FE    ;"ignore next byte"
.SETFLGS
        CPL
        RLA
        SBC     A,A
        RET     NZ
        INC     A
        RET

