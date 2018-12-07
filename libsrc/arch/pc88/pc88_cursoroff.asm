;
;	PC-8801 specific routines
;	by Stefano Bodrato, 2018
;
;	void pc88_cursoroff();
;
;	Hide the text cursor
;
;	$Id: pc88_cursoroff.asm $
;

        SECTION code_clib
	PUBLIC	pc88_cursoroff
	PUBLIC	_pc88_cursoroff
	
pc88_cursoroff:
_pc88_cursoroff:
	; jp 428Bh
	
	ld a,($E6A7)		; CursorMode
	res	0,a				; hide cursor
	ld ($E6A7),a
	or	$80				; complete CRTC command for cursor mode
	ld ($E6A8),a		; CursorCommand
	
;	; Cursor control is System/Interrupt driven, the following part should not be necessary
	;out ($51),a			; Output command to CRTC
	;xor a
	;out ($50),a			; parameter (x pos)
	;out ($50),a			; parameter (y pos)

	ret
