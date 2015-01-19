;
;       Z88dk Generic Floating Point Math Library
;
;       Normalise 48bit number in c ix de b
;	current exponent in fa+5
;	Result -> fa +5
;
;       $Id: norm4.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $:


		PUBLIC	norm4


		EXTERN	fa

.norm4  XOR     A
.norm6  LD      (fa+5),A
        RET
