;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2012
;
;	write_bytes_to_file(char *filename, int address, int bank, unsigned long len)
;
; Input Registers:
; HL = null-terminated ascii filename of file to be appended to
; IX = address of source data
; B = bank of source data
; C:DE = number of bytes to write
;
; Output Registers :  FLOS style error handling
;
;
;	$Id: write_bytes_to_file.asm,v 1.1 2012-03-05 20:40:15 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  write_bytes_to_file
	LIB   flos_err
	
write_bytes_to_file:
	ld	ix,2
	add	ix,sp

	ld	e,(ix+0)	; len
	ld	d,(ix+1)
	ld	c,(ix+2)

	ld	b,(ix+4)	; bank

	ld	h,(ix+7)	; address
	ld	l,(ix+6)
	push hl

	ld	h,(ix+9)	; file name
	ld	l,(ix+8)
	
	pop ix			; address

	call	kjt_write_bytes_to_file
	jp		flos_err
