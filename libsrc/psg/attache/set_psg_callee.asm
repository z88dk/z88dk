;
;	Otrona Attachè specific routines
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg_callee.asm $
;

        SECTION code_clib
	PUBLIC	set_psg_callee
	PUBLIC	_set_psg_callee

	PUBLIC ASMDISP_SET_PSG_CALLEE

	
set_psg_callee:
_set_psg_callee:

   pop hl	; Register Number
   pop de	; Data
   ex (sp),hl
	
.asmentry
	
	di	
    	
	;;; ld bc,0x00FA	
	;;; ld wz,0x00E7
        ;;; out(c),z
	;;;
	ld bc,0x00F8 ; Put register number on DPIOA
	out (c),l
	
	ld hl,0x00c3 ; magic select
	ld bc,0x00FA ; strobe select latch on dpiob - enable
	out (c),l
	ld hl,0x00E3 ; disable latch to dpiob
	out (c),l
	
	ld bc,0x00F8	
	out (c),e    ; put data on DPIOA

	ld bc,0x00FA ; Set back to DPIOB
	ld hl,0x00E7 ; strobe
	out(c),l
	ld hl,0x00C7
	out(c),l
	ld hl,0x00E7
	out(c),l
	ei
	ret

DEFC ASMDISP_SET_PSG_CALLEE = # asmentry - set_psg_callee
