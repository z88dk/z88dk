;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	int ozkeylower(char mask);
;	returns key pressed bitmap for lower part of keyboard
;
; ------
; $Id: ozkeylower.asm,v 1.3 2015-01-19 01:33:02 pauloscustodio Exp $
;


	PUBLIC	ozkeylower


ozkeylower:
        ;ld      hl,2
        ;add     hl,sp
        ;call    $gint
        ;push    hl     ; pushed byte
        ;pop     bc

	pop	hl
	pop	bc	; pick the mask
	push	bc
	push	hl

        xor     a
        out     (18),a
        ld      a,c
        out     (17),a
        in      a,(16)
        ld      c,a
        ld      b,0
        push    bc
        pop     hl
        ret

