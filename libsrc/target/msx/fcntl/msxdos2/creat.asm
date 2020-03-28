; creat(const char *name, mode_t mode)

                SECTION code_clib

		PUBLIC	creat
		PUBLIC	_creat

		INCLUDE	"target/msx/def/msxdos2.def"
		EXTERN	MSXDOS
		EXTERN	msxdos_error

.creat
._creat
	push	ix
	ld	ix,2
	add	ix,sp

	ld	e,(ix+4)	;Filename
	ld	d,(ix+5)
        ld      c,_DELETE
        call    MSXDOS          ;We don't care about the result
        ; And now create it
        ld      e,(ix+4)        ;Filename
        ld      d,(ix+5)
	ld	a,1		;O_WRONLY
        ld      b,@10000000     ;Create new
        ld      c,_CREATE
        call    MSXDOS
	ld	(msxdos_error),a
	pop	ix
	ld	hl,0
	ld	h,b
	and	a
	ret	z
	ld	hl,-1
	ret

	
