;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	void ozscroll(unsigned numbytes);
;
;
; ------
; $Id: ozscroll.asm,v 1.1 2003-10-21 17:15:20 stefano Exp $
;

	XLIB	ozscroll
	
	XREF	ozactivepage
	LIB	restore_a000


ozscroll:
        pop     hl
        exx

        ld      de,(ozactivepage)

        ld      a,e
	out	(3),a
        ld      a,d
	out	(4),a

       ld      hl,0a000h

       pop     bc
       push    bc

       add     hl,bc

       ex      de,hl

       ld      hl,2400
       sbc     hl,bc
       ld      c,l
       ld      b,h   ;; length of move

       ex      de,hl

       ld      de,0a000h

       ldir

       call    restore_a000

       exx
       jp      (hl)

