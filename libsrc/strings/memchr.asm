;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.61 Date: 21/12/99 
;
;	Reconstructed for the z80 Module Assembler
;	By Dominic Morris <djm@jb.man.ac.uk>
;
;	Compile time: Thu Dec 23 04:41:51 1999
;
;	Mildly hand optimized by djm 22/12/99



	MODULE	memchr.c

	INCLUDE "#z88_crt0.hdr"



.memchr
.i_3
	pop	de
	pop	hl
	dec	hl
	push	hl
	push	de
	inc	hl
	ld	a,h
	or	l
IF ORIGINAL
	jp	z,i_4
ELSE
	ret	z	;return 0
ENDIF
	ld	hl,6	;const
	add	hl,sp
	call	l_gint
IF ORIGINAL
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,6	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	pop	de
	call	l_eq
	jp	nc,i_5
ELSE
	ex	de,hl	;s
	ld	a,(de)
	ld	hl,6-2	;const
	add	hl,sp
	cp	(hl)
	jp	nz,i_5
	ex	de,hl	;s->hl
	ret
ENDIF
IF ORIGNAL
	ld	hl,6	;const
	add	hl,sp
	call	l_gint
	ret
ENDIF


.i_5
	ld	hl,6	;const
	add	hl,sp
	push	hl
	call	l_gint
	inc	hl
	pop	de
	call	l_pint
IF ORIGINAL
	dec	hl
ENDIF
	jp	i_3




; --- Start of Static Variables ---



; --- Start of Scope Defns ---

	LIB	strcmp
	LIB	strcpy
	LIB	strlen
	LIB	memcpy
	LIB	strpos
	LIB	strlwr
	LIB	strtok
	LIB	strspn
	LIB	strstr
	LIB	strupr
	LIB	memset
	LIB	stricmp
	LIB	strncat
	LIB	strcspn
	LIB	strstrip
	LIB	strncmp
	LIB	strncpy
	LIB	strpbrk
	LIB	reverse
	LIB	strrchr
	LIB	strrstr
	LIB	strrstrip
	LIB	strnicmp
	LIB	strcat
	LIB	strchr


; --- End of Scope Defns ---


; --- End of Compilation ---
