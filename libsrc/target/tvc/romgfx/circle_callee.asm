;
;   Videoton TV Computer asm stub
;   Sandor Vass - 2022
;
;  Using generic trick to adapt a classic function to the CALLEE mode
;
; ----- void __CALLEE__ circle(int x0, int y0, int radius, int skip)
;
;
;

SECTION code_clib

PUBLIC circle_callee
PUBLIC _circle_callee

	EXTERN     circle

.circle_callee
._circle_callee
	ld	hl,retaddr
	ex (sp),hl
	ld	(retaddr0+1),hl
	ld	hl,circle
	jp (hl)
	
.retaddr
		pop bc
		pop bc
		pop bc
		pop bc
.retaddr0
		ld	hl,0
		jp (hl)

