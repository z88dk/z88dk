;
;       Z88dk Generic Floating Point Math Library
;
;       Normalise 48bit number in c ix de b
;	current exponent in fa+5
;	Result -> fa +5
;
;       $Id: norm4.asm,v 1.2 2014-04-08 07:06:20 stefano Exp $:


		XLIB	norm4


		XREF	fa

.norm4  XOR     A
.norm6  LD      (fa+5),A
        RET
