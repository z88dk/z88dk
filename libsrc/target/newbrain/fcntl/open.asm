;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 29/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; open a file
;
; it reads the default store device in NB_DEV2 ($13)
; WARNING: might not work in paged memory mode
;     
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; int open(char *name, int flags, mode_t mode);
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: open.asm,v 1.5 2017-01-02 21:02:22 aralbrec Exp $
;

        SECTION code_clib
	PUBLIC	open
   PUBLIC   _open
	
	EXTERN	nbhandl
	EXTERN	nb_open
	EXTERN	nb_close
	

.open
._open
	push	ix		;save callers
	ld	ix,4
	add	ix,sp


	ld	b,10
	ld	c,0
	ld	hl,nbhandl
.hloop
	ld	a,(hl)
.notlast
	and	a
	jr	z,hfound
	inc	hl
	inc	c
	djnz	hloop
	pop	ix	;restore callers
	ret
.hfound
	inc	a
	ld	(hl),a
	ld	b,0	;c = file number

	ld	hl,100
	add	hl,bc
	
	push	hl
	call	nb_close	; close if already open
	pop	hl
	
	ld	a,(ix+2)	; get flags
	and	a
	ld	d,a
	ld	e,$32		; read mode (code for 'openin' ZCALL)
	jr	z,open_it
	ld	e,$33		; write mode (code for 'openout' ZCALL)
;	dec	a
;	jr	z,open_it
;.open_abort
;	ld	hl,-1		; invalid mode
;	scf
;	ret

; nb_open( int mode, int stream, int device, int port, char *paramstr );

.open_it
	push	de		; mode (Read or Write)
	push	hl		; stream -> handle
	ld	hl,($13)	; NB_DEV2 ..
	push	hl		; ..(default storage device: tape 1/2, disk, etc..)
	ld	bc,1
	push	bc		; port 1
	ld	l,(ix+4)
	ld	h,(ix+5)	; file name to paramstr
	push	hl
	call	nb_open
	ld	a,l		; keep result
	pop	hl		; pointer to fname
	pop	bc		; port
	pop	hl		; device
	pop	hl		; file handle
	pop	de
	pop	ix		;restore callers
	and	a
	ret	z

	ld	hl,-1		; open error !
	ret
