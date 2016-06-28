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
; $Id: ozscroll.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozscroll
	PUBLIC	_ozscroll
	
	EXTERN	ozactivepage
	EXTERN	restore_a000


ozscroll:
_ozscroll:
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

