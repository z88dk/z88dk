;
;	PC-8801 specific routines
;	by Stefano Bodrato, 2018
;
;	void pc88_crtset(int width);
;
;	Clears the keyboard buffer
;
;	$Id: pc88_crtset.asm $
;

        SECTION code_clib
	PUBLIC	pc88_crtset
	PUBLIC	_pc88_crtset
	EXTERN     pc88bios
	
pc88_crtset:
_pc88_crtset:

	pop af
	pop bc		; rows
	pop hl		; columns
	push hl
	push bc
	
	push	ix
	
	ld	b,l		; columns
	
	xor	a
	ld	($E6B8),a		; disable FN key help bar
	
	ld      ix,$6F6B		; CRTSET - B=columns, C=rows
	call	pc88bios

	pop	ix
	ret
