;
;
;	Support char table (pseudo graph symbols) for the Mattel Aquarius
;	Version for the 2x3 graphics symbols
;	Sequence: blank, top-left, top-right, top-half, medium-left, top-left + medium-left, etc..
;
;	$Id: textpixl6.asm,v 1.3 2016-06-20 21:47:41 dom Exp $
;
;

	SECTION rodata_clib
	PUBLIC	textpixl


.textpixl
		defb	$C0, $C1, $C8, $C9, $C2, $C3, $CA, $CB
		defb	$D0, $D1, $D8, $D9, $D2, $D3, $DA, $DB
		defb	$C4, $C5, $CC, $CD, $C6, $C7, $CE, $CF
		defb	$D4, $D5, $DC, $DD, $D6, $D7, $DE, $DF
		defb	$E0, $E1, $E8, $E9, $E2, $E3, $EA, $EB
		defb	$F0, $F1, $F8, $F9, $F2, $F3, $FA, $FB
		defb	$E4, $E5, $EC, $ED, $E6, $E7, $EE, $EF
		defb	$F4, $F5, $FC, $FD, $F6, $F7, $FE, $FF
