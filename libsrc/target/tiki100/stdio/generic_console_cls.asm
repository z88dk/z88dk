

	SECTION		code_graphics
	PUBLIC		generic_console_cls

	EXTERN		swapgfxbk
	EXTERN		swapgfxbk1

generic_console_cls:
	call	swapgfxbk
	ld	hl,0
	ld	de,1
	ld	bc,32767
	ld	(hl),0		; TODO - as colour??
	ldir
	call	swapgfxbk1
	ret
