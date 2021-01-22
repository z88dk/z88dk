

SECTION code_clib

PUBLIC fgetc_cons
PUBLIC _fgetc_cons
EXTERN getk

EXTERN VGL_KEY_STATUS_ADDRESS



fgetc_cons:
_fgetc_cons:
        ld      a,0xc0
        ld      (VGL_KEY_STATUS_ADDRESS),a
loop1:
        ld      a,(VGL_KEY_STATUS_ADDRESS)
	cp	$d0
	jr	nz,loop1
	call	getk
	ld	a,l
	and	a
	jr	z,fgetc_cons
	ret


