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

    PUBLIC asm_set_psg


    INCLUDE	"sn76489.inc"

	
set_psg_callee:
_set_psg_callee:

   pop hl
   pop de
   ex (sp),hl
.asm_set_psg

    LD	BC,psgport
    OUT	(C),L
IF PSGLatchPort
    in a,(PSGLatchPort)
ENDIF
    OUT	(C),E
IF PSGLatchPort
    in a,(PSGLatchPort)
ENDIF
    ret

ENDIF
