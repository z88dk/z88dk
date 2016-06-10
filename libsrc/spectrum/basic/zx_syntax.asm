;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 05/02/2008
;
;	int zx_syntax(char *statement);
;
;	Test a BASIC command syntax
;	Returns (true) if OK, (false) on error.
;
;  statement:	pointer to BASIC command to be loaded for immediate execution.
;		Terminate the string with carriage return.
;
;
;	$Id: zx_syntax.asm,v 1.4 2016-06-10 20:02:04 dom Exp $
;

SECTION code_clib
PUBLIC	zx_syntax
PUBLIC	_zx_syntax
EXTERN	zx_interface1
EXTERN	call_rom3

	; max space for BASIC command(s)
	defc	cmdlen = 20
	
zx_syntax:
_zx_syntax:
		push	hl
		call	zx_interface1	; force IF1 activation to avoid crashes
		call	call_rom3
		defw	$16b0		; clear buffers
		pop	de
		
		ld	hl,($5c5d)	; save CH-ADD
		push	hl
		ld	hl,($5c5f)	; save X-PTR
		push	hl

		ld	hl,($5c59)	; E-LINE
		push	hl
		ld	bc,cmdlen
		push	bc
		push	de
		call	call_rom3
		defw	$1655		; MAKE_ROOM
		pop	hl
		pop	bc
		pop	de
		ldir			; copy command to E-LINE

		ld	hl,$5c44	; NSPPC
		ld	a,(hl)
		push	af
		ld	(hl),1		; set to first statement in line

		ld	a,($5c47)	;
		push	af		; keep SUBPPC (statement number 
					; within line being executed)

		ld	bc,($5c3d)
		push	bc		; save original ERR_SP

		ld	bc,return
		push	bc
		ld	($5c3d),sp	; update error handling routine
		
		call	call_rom3
		defw	$1b17		; check syntax
		;ld	(iy+0),255	; set ERR_NR to OK
		pop	bc
return:
		pop	bc
		ld	($5c3d),bc	; restore ERR_SP

		xor	a
		bit	7,(iy+0)	; test ERR_NR
		ld	(iy+0),255	; reset ERR_NR
		jr	z,nook
		inc	a
nook:
		ld	(result+1),a
		
		; Restore system variables to original values

		set	7,(iy+48)	; signal line execution

		pop	af
		ld	($5c47),a	; restore original SUBPPC

		pop	af
		ld	($5c44),a	; restore original NSPPC
		
;		bit	0,(iy+124)	; test FLAGS3: coming from paged ROM ?
;		jr	nz,stderr
;		ld	(iy+124),0	; yes, reset FLAGS3
;stderr:

		;set     5,(iy+$37)	; force to EDIT mode
		;call	$1097		; CLEAR-SP
		;res     5,(iy+$37)	; unset EDIT mode
		call	call_rom3
		defw	$16b0		; clear buffers
		
		pop	hl
		ld	($5c5f),hl	; restore X-PTR
		pop	hl
		ld	($5c5d),hl	; restore CH-ADD

result:		ld	hl,0
		ret
