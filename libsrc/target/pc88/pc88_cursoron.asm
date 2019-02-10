;
;	PC-8801 specific routines
;	by Stefano Bodrato, 2018
;
;	void pc88_cursoron();
;
;	Enable the text cursor
;
;	$Id: pc88_cursoron.asm $
;

        SECTION code_clib
	PUBLIC	pc88_cursoron
	PUBLIC	_pc88_cursoron
	
pc88_cursoron:
_pc88_cursoron:
	; jp 4290h
	
	ld a,($E6A7)		; CursorMode
	set	0,a				; show cursor
	ld ($E6A7),a
	or	$80				; complete CRTC command for cursor mode
	ld ($E6A8),a		; CursorCommand
	
;	; Cursor control is System/Interrupt driven, the following part should not be necessary
;	out ($51),a			; Output command to CRTC
;	LD A,($EF87)		; TTYPOS X
;	out ($50),a			; parameter (x pos)
;	LD A,($EF86)		; TTYPOS Y
;	out ($50),a			; parameter (y pos)

	ret
