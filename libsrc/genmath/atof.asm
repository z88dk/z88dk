;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.71pre3 Date: 29/1/2001 
;
;	Reconstructed for the z80 Module Assembler
;	By Dominic Morris <djm@jb.man.ac.uk>
;
;	Module compile time: Mon Jan 29 16:47:32 2001



;	Small C+ Library Function

	XLIB	atof

	defc DEFINED_atof = 1
	INCLUDE "#z88_crt0.hdr"



._atof
	ld	hl,-23	;const
	add	hl,sp
	ld	sp,hl
	ld	hl,25	;const
	add	hl,sp
	call	l_gint	;
	ld	a,(hl)
	cp	#(45 % 256)
	jp	nz,i_3
	ld	hl,4	;const
	add	hl,sp
	ld	(hl),#(1 % 256)
	inc	hl
	ld	(hl),#(1 / 256)
	ld	hl,25	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	inc	hl
	pop	de
	call	l_pint
	jp	i_4
.i_3
	ld	hl,4	;const
	add	hl,sp
	ld	de,0	;const
	ex	de,hl
	call	l_pint
.i_4
	ld	hl,9	;const
	add	hl,sp
	ex	de,hl
	ld	hl,27-2	;const
	add	hl,sp
	call	l_gint	;
	call	l_pint
	ld	hl,0	;const
	pop	bc
	push	hl
.i_5
	ld	hl,25	;const
	add	hl,sp
	call	l_gint	;
	ld	e,(hl)
	ld	d,0
	ld	hl,46	;const
	call	l_eq
	pop	de
	pop	bc
	push	hl
	push	de
	ld	a,h
	or	l
	jp	nz,i_7
	ld	hl,25	;const
	add	hl,sp
	call	l_gint	;
	ld	l,(hl)
	ld	h,0
	push	hl
	call	isdigit
	pop	bc
	ld	a,h
	or	l
	jp	nz,i_7
	jr	i_8
.i_7
	ld	hl,1	;const
.i_8
	ld	a,h
	or	l
	jp	z,i_6
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	a,h
	or	l
	jp	z,i_9
	pop	hl
	inc	hl
	push	hl
.i_9
	ld	hl,25	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	inc	hl
	pop	de
	call	l_pint
	jp	i_5
.i_6
	ld	hl,7	;const
	add	hl,sp
	ex	de,hl
	ld	hl,27-2	;const
	add	hl,sp
	call	l_gint	;
	call	l_pint
	ld	hl,17	;const
	add	hl,sp
	push	hl
	ld	hl,i_2+0
	call	dload
	pop	hl
	call	dstore
	pop	hl
	push	hl
	ld	a,h
	or	l
	jp	z,i_10
	ld	hl,25	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	dec	hl
	pop	de
	call	l_pint
.i_11
	ld	hl,25	;const
	add	hl,sp
	call	l_gint	;
	ld	a,(hl)
	cp	#(46 % 256)
	jp	z,i_12
	ld	hl,17	;const
	add	hl,sp
	push	hl
	ld	hl,19	;const
	add	hl,sp
	call	dldpsh
	ld	hl,33	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	dec	hl
	pop	de
	call	l_pint
	inc	hl
	ld	l,(hl)
	ld	h,0
	ld	bc,-48
	add	hl,bc
	push	hl
	call	_float
	pop	bc
	call	float
	call	dadd
	call	dpush
	ld	hl,i_2+6
	call	dload
	call	dmul
	pop	hl
	call	dstore
	jp	i_11
.i_12
.i_10
	ld	hl,11	;const
	add	hl,sp
	push	hl
	ld	hl,i_2+12
	call	dload
	pop	hl
	call	dstore
.i_13
	ld	hl,25	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	dec	hl
	pop	de
	call	l_pint
	ex	de,hl
	ld	hl,11-2	;const
	add	hl,sp
	call	l_gint	;
	call	l_uge
	jp	nc,i_14
	ld	hl,17	;const
	add	hl,sp
	push	hl
	call	dldpsh
	ld	hl,19	;const
	add	hl,sp
	call	dldpsh
	ld	hl,39	;const
	add	hl,sp
	call	l_gint	;
	ld	l,(hl)
	ld	h,0
	ld	bc,-48
	add	hl,bc
	push	hl
	call	_float
	pop	bc
	call	float
	call	dmul
	call	dadd
	pop	hl
	call	dstore
	ld	hl,11	;const
	add	hl,sp
	push	hl
	call	dldpsh
	ld	hl,i_2+6
	call	dload
	call	dmul
	pop	hl
	call	dstore
	jp	i_13
.i_14
	ld	hl,6	;const
	add	hl,sp
	push	hl
	ld	hl,9	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	inc	hl
	pop	de
	call	l_pint
	dec	hl
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	hl,6	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	push	hl
	call	tolower
	pop	bc
	ld	de,101	;const
	ex	de,hl
	call	l_eq
	jp	nc,i_15
	push	bc
	push	bc
	push	bc
	ld	hl,4	;const
	add	hl,sp
	push	hl
	dec	hl
	dec	hl
	ld	de,0	;const
	ex	de,hl
	call	l_pint
	pop	de
	call	l_pint
	ld	hl,13	;const
	add	hl,sp
	call	l_gint	;
	ld	a,(hl)
	cp	#(45 % 256)
	jp	nz,i_16
	ld	hl,4	;const
	add	hl,sp
	ld	(hl),#(1 % 256)
	inc	hl
	ld	(hl),#(1 / 256)
	ld	hl,13	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	inc	hl
	pop	de
	call	l_pint
.i_16
.i_17
	ld	hl,12	;const
	add	hl,sp
	push	hl
	ld	hl,15	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	inc	hl
	pop	de
	call	l_pint
	dec	hl
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	l,a
	ld	h,0
	ld	de,48	;const
	ex	de,hl
	call	l_uge
	jp	nc,i_19
	ld	hl,12	;const
	add	hl,sp
	ld	a,(hl)
	cp	#(57 % 256)
	jr	z,ASMPC+5
	jp	nc,i_20
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	push	hl
	ld	hl,14	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	pop	de
	add	hl,de
	ld	bc,-48
	add	hl,bc
	pop	de
	pop	bc
	push	hl
	push	de
	jp	i_17
.i_20
.i_19
.i_18
	pop	bc
	pop	de
	push	de
	push	bc
	ld	hl,38	;const
	call	l_gt
	jp	nc,i_21
	ld	hl,i_1+0
	push	hl
	call	puts
	pop	bc
	ld	hl,0	;const
	pop	de
	pop	bc
	push	hl
	push	de
.i_21
	ld	hl,32	;const
	pop	bc
	push	hl
	ld	hl,17	;const
	add	hl,sp
	push	hl
	ld	hl,i_2+12
	call	dload
	pop	hl
	call	dstore
.i_22
	pop	hl
	push	hl
	ld	a,h
	or	l
	jp	z,i_23
	ld	hl,17	;const
	add	hl,sp
	push	hl
	call	dldpsh
	ld	hl,25	;const
	add	hl,sp
	call	dload
	call	dmul
	pop	hl
	call	dstore
	pop	de
	push	de
	ld	hl,4-2	;const
	add	hl,sp
	call	l_gint	;
	call	l_and
	ld	a,h
	or	l
	jp	z,i_24
	ld	hl,17	;const
	add	hl,sp
	push	hl
	call	dldpsh
	ld	hl,i_2+6
	call	dload
	call	dmul
	pop	hl
	call	dstore
.i_24
	pop	de
	push	de
	ld	l,#(1 % 256)
	call	l_asr
	pop	bc
	push	hl
	jp	i_22
.i_23
	ld	hl,4	;const
	add	hl,sp
	call	l_gint	;
	ld	a,h
	or	l
	jp	z,i_25
	ld	hl,23	;const
	add	hl,sp
	push	hl
	call	dldpsh
	ld	hl,25	;const
	add	hl,sp
	call	dload
	call	dmul
	pop	hl
	call	dstore
	jp	i_26
.i_25
	ld	hl,23	;const
	add	hl,sp
	push	hl
	call	dldpsh
	ld	hl,25	;const
	add	hl,sp
	call	dload
	call	dmul
	pop	hl
	call	dstore
.i_26
	pop	bc
	pop	bc
	pop	bc
.i_15
	ld	hl,4	;const
	add	hl,sp
	call	l_gint	;
	ld	a,h
	or	l
	jp	z,i_27
	ld	hl,17	;const
	add	hl,sp
	push	hl
	ld	hl,19	;const
	add	hl,sp
	call	dload
	call	minusfa
	pop	hl
	call	dstore
.i_27
	ld	hl,17	;const
	add	hl,sp
	call	dload
	call	ifix
	exx
	ld	hl,23	;const
	add	hl,sp
	ld	sp,hl
	exx
	ret


.i_1
	defm	"overflow"&0

.i_2
	defb	0,0,0,0,0,0,0,0,0,0
	defb	32,132,0,0,0,0,0,129

; --- Start of Static Variables ---



; --- Start of Scope Defns ---

	LIB	vfprintf_mini
	LIB	feof
	LIB	fprand
	LIB	fpseed
	XDEF	_atof
	LIB	getk
	LIB	isprint
	LIB	fmod
	LIB	sprintf
	LIB	tolower
	LIB	ispunct
	LIB	ftoa
	LIB	ftoe
	LIB	read
	LIB	isupper
	LIB	open
	LIB	fgetc
	LIB	freopen
	LIB	fgets
	LIB	open_z88
	LIB	fopen_z88
	LIB	creat
	LIB	close
	LIB	isxdigit
	LIB	toupper
	LIB	puts
	XREF	_float
	LIB	fseek
	LIB	rename
	LIB	floor
	LIB	fopen
	LIB	fchkstd
	LIB	ftell
	LIB	readbyte
	LIB	fprintf
	LIB	vsscanf
	XREF	__sgoioblk
	LIB	fgetc_cons
	LIB	fgets_cons
	LIB	fputc
	LIB	isalpha
	LIB	remove
	LIB	isdigit
	LIB	scanf
	LIB	isascii
	LIB	fputs
	LIB	isalnum
	LIB	lseek
	LIB	vsprintf
	LIB	vfscanf
	LIB	toascii
	LIB	nropen
	LIB	writebyte
	LIB	fclose
	LIB	iscntrl
	LIB	fgetpos
	LIB	printf
	LIB	sscanf
	LIB	fdopen
	LIB	printk
	LIB	printn
	LIB	fdtell
	LIB	closeall
	LIB	freopen_z88
	LIB	ungetc
	LIB	getarg
	LIB	vfprintf_comp
	LIB	fscanf
	LIB	fabandon
	LIB	fdgetpos
	LIB	ceil
	LIB	fabs
	XREF	_vfprintf
	LIB	islower
	LIB	write
	LIB	fputc_cons
	LIB	puts_cons
	LIB	amax
	LIB	amin
	LIB	isspace


; --- End of Scope Defns ---


; --- End of Compilation ---
