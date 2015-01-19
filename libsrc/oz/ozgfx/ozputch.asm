;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	gfx functions
;
;	int ozputch (int x, int y, char c);
;
; ------
; $Id: ozputch.asm,v 1.2 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozputch

	EXTERN	ozputs

ozputchbuf:
        defb 0	; Char to be printed
        defb 0	; string terminator

ozputch:
        ;ld   hl,6
        ld	hl,2
        add  hl,sp
        ld   a,(hl)
        ld   (ozputchbuf),a
        ld   bc,ozputchbuf
        ld   (hl),c
        inc  hl
        ld   (hl),b
        jp   ozputs
