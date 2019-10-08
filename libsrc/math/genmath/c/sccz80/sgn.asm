;
;       Z88dk Generic Floating Point Math Library
;
;       set z and Z flags per fa
;
;	$Id: sgn.asm,v 1.4 2016-06-21 21:16:49 dom Exp $:


        SECTION code_fp
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

