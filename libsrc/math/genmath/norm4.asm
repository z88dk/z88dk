;
;       Z88dk Generic Floating Point Math Library
;
;       Normalise 48bit number in c ix de b
;	current exponent in fa+5
;	Result -> fa +5
;
;       $Id: norm4.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $:


		XLIB	norm4


		XREF	fa

.NORM4  XOR     A
.NORM6  LD      (FA+5),A
        RET
