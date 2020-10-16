;
;	SN76489 (a.k.a. SN76494,SN76496,TMS9919,SN94624) sound routines
;	by Stefano Bodrato, 2018
;
;	int psg_init();
;
;	Play a sound by PSG
;
;
;	$Id: psg_init.asm $
;

IF !__CPU_INTEL__ & !__CPU_RABBIT__ & !__CPU_GBZ80__
        SECTION code_clib
	PUBLIC	psg_init
	PUBLIC	_psg_init
	
	INCLUDE	"sn76489.inc"

psg_init:
_psg_init:
	
	LD	BC,psgport
	LD	A,$9F
	OUT	(C),A
	LD	A,$BF
	OUT	(C),A
	LD	A,$DF
	OUT	(C),A
	LD	A,$FF
	OUT	(C),A
	
	RET
ENDIF
