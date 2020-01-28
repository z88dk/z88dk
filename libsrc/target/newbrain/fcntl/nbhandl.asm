;
; NewBrain driver support file, used by "open" and "close"
;
; Stefano - 29/5/2007
;
; $Id: nbhandl.asm,v 1.3 2016-06-19 20:26:58 dom Exp $

        SECTION bss_clib
	PUBLIC	nbhandl
	
; handles:
;          10 files open at once should be enough.
;          we use stream numbers startimg from 100
;
;                 100  101 102 103 104 105 106 107 108 109
.nbhandl    defs	10

