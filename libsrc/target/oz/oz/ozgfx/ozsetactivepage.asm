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
; $Id: ozsetactivepage.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozsetactivepage
	PUBLIC	_ozsetactivepage
	
	EXTERN	ozactivepage


ozsetactivepage:
_ozsetactivepage:
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

