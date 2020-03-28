;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 19/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; int nb_open( int mode, int stream, int device, int port, char *paramstr );
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: nb_open.asm,v 1.3 2016-06-19 20:33:40 dom Exp $
;

        SECTION smc_clib
	PUBLIC nb_open
	PUBLIC _nb_open
	
	EXTERN ZCALL

.nb_open
._nb_open
	push	ix		;save callers
	ld	ix,4
	add	ix,sp

	ld	a,(ix+8)	; mode
	ld	(openmode),a
		
	ld	l,(ix+0)	; parameter string
	ld	h,(ix+1)

	;parameter string length count
	ld	bc,0
	push	hl
.strct
	ld	a,(hl)
	and	a
	jr	z,strcount
	inc	hl
	inc	bc
	jr	strct
.strcount
	pop	hl

	ld	e,(ix+6)	; stream
	ld	a,(ix+4)	; device
	ld	d,(ix+2)	; port

	call	ZCALL
.openmode			;SMC!
	defb	$0	; zopenin = $32; zopenout = $33;

	
	ld	hl,0
	jp	nc,noerror
	ld	l,a	; return error code
.noerror
	pop	ix	;restore callers
	ret

