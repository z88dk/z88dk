;
;	PC-6001 specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int get_psg(int reg);
;
;	Get a PSG register
;
;
;	$Id: get_psg.asm,v 1.3 2016-06-10 21:13:58 dom Exp $
;

        SECTION code_clib
	PUBLIC	get_psg
	PUBLIC	_get_psg
	
;;read & write
;        ld      a,register
;        ld      e,data
;        call    $1BBE



get_psg:
_get_psg:
    LD	BC,$A0
	OUT	(C),l

	IN	a,($A2)
	ld	l,a	; NOTE: A register has to keep the same value
	ret
