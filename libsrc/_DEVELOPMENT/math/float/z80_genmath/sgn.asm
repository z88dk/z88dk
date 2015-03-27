;
;       Z88dk Generic Floating Point Math Library
;
;       set z and Z flags per fa
;
;	$Id: sgn.asm,v 1.1 2015-03-27 06:03:29 aralbrec Exp $:


		PUBLIC	sgn
	
		PUBLIC	setflgs

		EXTERN	fa

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

