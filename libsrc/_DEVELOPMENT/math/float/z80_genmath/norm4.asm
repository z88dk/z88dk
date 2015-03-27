;
;       Z88dk Generic Floating Point Math Library
;
;       Normalise 48bit number in c ix de b
;	current exponent in fa+5
;	Result -> fa +5
;
;       $Id: norm4.asm,v 1.1 2015-03-27 06:03:29 aralbrec Exp $:


		PUBLIC	norm4


		EXTERN	fa

.norm4  XOR     A
.norm6  LD      (fa+5),A
        RET
