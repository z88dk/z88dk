;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	void ozscrolldown(unsigned numbytes);
;
;
; ------
; $Id: ozscrolldown.asm,v 1.1 2003-10-21 17:15:20 stefano Exp $
;

	XLIB	ozscrolldown
	
	XREF	ozactivepage
	LIB	restore_a000


ozscrolldown:
        pop     hl
        exx

        ld      de,(ozactivepage)

        ld      a,e
	out	(3),a
        ld      a,d
	out	(4),a

        ld      hl,0a000h+2400-1

        pop     bc
        push    bc

        or      a
        sbc     hl,bc

        ex      de,hl

        ld      hl,2400
        sbc     hl,bc
        ld      c,l
        ld      b,h   ;; length of move

        ex      de,hl

        ld      de,0a000h+2400-1

        lddr

        call    restore_a000

        exx
        jp      (hl)

