
	XLIB	Bind_bank_s1

; ******************************************************************************
;
;	Bind	bank, defined in A,	into	segment 1. Return old bank binding	in A.
;	This	is the functional equivalent of OS_MPB,	but much faster.
;
;	Register affected on return:
;		..BCDEHL/IXIY
;		AF....../.... af
;
;	Design & programming by Gunther Strube,	Copyright	(C) InterLogic	1995
;
;
; -----
; $Id: bindbnk1.asm,v 1.2 2001-04-18 12:43:04 stefano Exp $


.Bind_bank_s1		PUSH	BC
				LD	B,A
				EX	AF,AF'
				LD	A,($04D1)
				CP	B
				POP	BC
				RET	Z				; bank already	bound into segment
				PUSH	AF
				EX	AF,AF'
				LD	($04D1),A
				OUT	($D1),A
				POP	AF
				RET
