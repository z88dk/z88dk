;
; BASIC driver support file, used by "open" and "close"
;
; Stefano - 5/7/2006
;
; $Id: zxhandl.asm,v 1.2 2015-01-19 01:32:43 pauloscustodio Exp $

	PUBLIC	zxhandl
	
; handles: list of used streams, we keep #14 an #15 reserved,
;          10 files open at once should be enough.
;          #3 is used for printer, #1 and #2 are used by BASIC
;
;                   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
.zxhandl    defb    1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 255

