;
; NewBrain driver support file, used by "open" and "close"
;
; Stefano - 29/5/2007
;
; $Id: nbhandl.asm,v 1.2 2015-01-19 01:32:43 pauloscustodio Exp $

	PUBLIC	nbhandl
	
; handles:
;          10 files open at once should be enough.
;          we use stream numbers startimg from 100
;
;                 100  101 102 103 104 105 106 107 108 109
.nbhandl    defb    0,   0,  0,  0,  1,  1,  0,  0,  0,  0, 255

