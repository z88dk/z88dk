;
;	SN76489 (a.k.a. SN76494,SN76496,TMS9919,SN94624) sound routines
;	by Stefano Bodrato, 2018
;
;	int psg_channels(int reg, int val);
;
;	Placeholder for YM compatibility
;
;
;	$Id: psg_channels.asm $
;

IF  !__CPU_INTEL__&!__CPU_RABBIT__&!__CPU_GBZ80__
    SECTION code_clib
    PUBLIC  psg_channels
    PUBLIC  _psg_channels
    PUBLIC  ___psg_channels
    EXTERN  asm_psg_channels

psg_channels:
_psg_channels:
___psg_channels:

ret

ENDIF
