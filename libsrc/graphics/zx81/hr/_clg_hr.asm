;--------------------------------------------------------------
; This code comes from the 'HRG_Tool' 
; by Matthias Swatosch
;--------------------------------------------------------------
;
;       Fast CLS for hi-rez ZX81
;
;       Stefano - 10/1/2007
;
;
;	$Id: _clg_hr.asm,v 1.3 2016-06-27 20:26:33 dom Exp $
;
                SECTION code_clib
                PUBLIC    _clg_hr
                PUBLIC    __clg_hr
                EXTERN	base_graphics
                EXTERN	hr_rows

._clg_hr
.__clg_hr
;----------------------------------------------------------------
;
; HRG_Tool_Clear
; hl = pointer to display array
;
; to fill hr_rows lines by 32 characters
; here we use the stack (!) to fill hr_rows x 8 x 16 words with push
;
;----------------------------------------------------------------

	ld	hl,(base_graphics)
	ld	a,(hr_rows)		; 8 or 24

	ld	b,a			; * 256
	ld	c,0
	add	hl,bc
	ld	(HRG_ClearSpReg),sp
	ld	sp,hl

	ld	hl,0
	
	add	a			; 8 or 24
	add	a
	add	a			; * 8
	ld	b,a
	
HRG_ClearLoop:
	push	hl
	push	hl
	push	hl
	push	hl
	push	hl
	push	hl
	push	hl
	push	hl
	push	hl
	push	hl
	push	hl
	push	hl
	push	hl
	push	hl
	push	hl
	push	hl
	djnz	HRG_ClearLoop

	ld	sp,(HRG_ClearSpReg)
	
	ret

HRG_ClearSpReg:	defw	0
