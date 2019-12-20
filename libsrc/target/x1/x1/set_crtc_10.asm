;
;	Sharp X1 specific routines
;   Set 14 6845 CRTC registers at once
;
;	void set_crtc(void *reg_list);
;
;	Set 16 6845 CRTC registers at once
;
;	$Id: set_crtc_10.asm,v 1.3 2016-06-10 23:45:21 dom Exp $
;

	SECTION code_clib
	PUBLIC	set_crtc_10
	PUBLIC	_set_crtc_10
	

set_crtc_10:
_set_crtc_10:
; __FASTCALL__ : CRTC table ptr in HL

		LD DE,000Ah	
		LD BC,1800h		; CRTC
setout:
		OUT (C),D
		INC BC
		LD A,(HL)
		OUT (C),A
		DEC BC
		INC HL
		INC D
		DEC E
		JR NZ,setout
		RET

