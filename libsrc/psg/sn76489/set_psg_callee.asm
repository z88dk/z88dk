;
;	SN76489 (a.k.a. SN76494,SN76496,TMS9919,SN94624) sound routines
;	by Stefano Bodrato, 2018
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg_callee.asm $
;

IF !__CPU_INTEL__ & !__CPU_RABBIT__ & !__CPU_GBZ80__
        SECTION code_clib
	PUBLIC	set_psg_callee
	PUBLIC	_set_psg_callee

	PUBLIC ASMDISP_SET_PSG_CALLEE


	INCLUDE	"sn76489.inc"

	
set_psg_callee:
_set_psg_callee:

   pop hl
   pop de
   ex (sp),hl
	
.asmentry

    LD	BC,psgport
	OUT	(C),L
	OUT	(C),E
	ret

DEFC ASMDISP_SET_PSG_CALLEE = asmentry - set_psg_callee

ENDIF
