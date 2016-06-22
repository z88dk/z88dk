; Command line parsing

; Push pointers to argv[n] onto the stack now
; We must start from the end 
; Entry:  hl = end of arguments
;	   c = length of arguments
;	   b = 0
; Exit:	  bc = argc
;         hl = argv

	ld	de,0	;NULL pointer at end, just in case
	push	de
; Try to find the end of the arguments
argv_loop_1:
	ld	a,(hl)
	cp	' '
	jr	nz,argv_loop_2
	ld	(hl),0
	dec	hl
	dec	c
	jr	nz,argv_loop_1
; We've located the end of the last argument, try to find the start
argv_loop_2:
	ld	a,(hl)
	cp	' '
	jr	nz,argv_loop_3
	;ld	(hl),0
	inc	hl

IF !DEFINED_noredir
IF !DEFINED_nostreams
	EXTERN freopen
	xor	a
	add	b
	jr	nz,no_redir_stdout
	ld	a,(hl)
	cp	'>'
	jr	nz,no_redir_stdout
	push	hl
	inc	hl
	cp	(hl)
	dec	hl
	ld	de,redir_fopen_flag	; "a" or "w"
	jr	nz,noappendb
	ld	a,'a'
	ld	(de),a
	inc	hl
noappendb:
	inc	hl
		
	push	bc
	push	hl					; file name ptr
	push	de
	ld	de,__sgoioblk+4		; file struct for stdout
	push	de
	call	freopen
	pop	de
	pop	de
	pop	hl
	pop	bc

	pop	hl
		
	dec	hl
	jr	argv_zloop
no_redir_stdout:

	ld	a,(hl)
	cp	'<'
	jr	nz,no_redir_stdin
	push	hl
	inc	hl
	ld	de,redir_fopen_flagr
	
	push	bc
	push	hl					; file name ptr
	push	de
	ld	de,__sgoioblk		; file struct for stdin
	push	de
	call	freopen
	pop	de
	pop	de
	pop	hl
	pop	bc

	pop	hl
		
	dec	hl
	jr	argv_zloop
no_redir_stdin:
ENDIF
ENDIF

	push	hl
	inc	b
	dec	hl

; skip extra blanks
argv_zloop:
	ld	(hl),0
	dec	c
	jr	z,argv_done
	dec	hl
	ld	a,(hl)
	cp	' '
	jr	z,argv_zloop
	inc c
	inc hl

argv_loop_3:
	dec	hl
	dec	c
	jr	nz,argv_loop_2

argv_done:
	ld	hl,end	;name of program (NULL)
	push	hl
	inc	b
	ld	hl,0
	add	hl,sp	;address of argv
	ld	c,b
	ld	b,0

