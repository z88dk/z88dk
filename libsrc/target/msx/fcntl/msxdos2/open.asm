;       int open(char *name,int access, mode_t mode)
; 
;       Flags is one of: O_RDONLY, O_WRONLY, O_RDWR
;       Or'd with any of: O_CREAT, O_TRUNC, O_APPEND
;#define O_RDONLY  0
;#define O_WRONLY  1
;#define O_RDWR    2
;#define O_APPEND  256
;#define O_TRUNC   512
;#define O_CREAT   1024

                SECTION code_clib
		INCLUDE	"target/msx/def/msxdos2.def"

		PUBLIC	open
		PUBLIC	_open
		PUBLIC	___open

		EXTERN	MSXDOS
		EXTERN	msxdos_error

; char *name, int flags, mode_t mode)
.open
._open
.___open
	push	ix
	ld	ix,2
	add	ix,sp
	ld	e,(ix+6)	;Filename
	ld	d,(ix+7)
	ld	a,(ix+5)	;High byte flags
	and	2
	jr	z,no_truncate
	; Delete the file
	ld	c,_DELETE
	call	MSXDOS		;We don't care about the result
	; And now create it
create_file:
	ld	e,(ix+6)	;Filename
	ld	d,(ix+7)
	call	get_mode	;Mode in c
	ld	a,c
	ld	b,@10000000	;Create new
	ld	c,_CREATE
	call	MSXDOS
	jr	return

no_truncate:
	; We don't want to truncate, try top open it
	call	get_mode	;Mode in c
	ld	a,c
	ld	c,_OPEN
	call	MSXDOS
	and	a
	jr	z,return
	; We failed to open it, check for O_CREAT
	bit	2,(ix+5)
	jr	nz,create_file
return:
	ld	(msxdos_error),a
	pop	ix	;Return callers
	ld	hl,0
	ld	h,b
	and	a
	ret	z
	ld	hl,-1
	ret


get_mode:
        ld      a,(ix+4)	;Low byte flags
        ld      c,1
        and     a               ;O_RDONLY
	ret	z
        ld      c,2
        dec     a               ;O_WRONLY
	ret	z
        ld      c,0		;O_RDWR
	ret
