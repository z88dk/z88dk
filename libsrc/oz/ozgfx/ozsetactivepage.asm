;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	gfx functions
;
;	Videmo memory page handling
;	void ozsetactivepage(byte page)
;
;
; ------
; $Id: ozsetactivepage.asm,v 1.2 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozsetactivepage
	
	EXTERN	ozactivepage


ozsetactivepage:
        pop     hl
        pop     bc
        push    bc
        ld      a,c
        or      a
        jr      nz,PageOne
        xor     a
        ld      (ozactivepage),a
;; assume high byte is 4
        jp      (hl)
PageOne:
        ld      a,4
        ld      (ozactivepage),a
;; assume high byte is 4
        jp      (hl)

