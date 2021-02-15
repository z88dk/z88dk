

SECTION code_clib

PUBLIC getk
PUBLIC _getk

EXTERN __CRT_KEY_DEL
EXTERN VGL_KEY_STATUS_ADDRESS
EXTERN VGL_KEY_CURRENT_ADDRESS

EXTERN error_mc



getk:
_getk:
	ld	hl,0
	ld	a,(VGL_KEY_STATUS_ADDRESS)
	cp	0xd0
	ret	nz
	ld	a,(VGL_KEY_CURRENT_ADDRESS)
	ld	l,a
	and	a
	jp	z,error_mc
	cp	0x60        ;VGL_KEY_BREAK=0x60
	jr	z, key_esc
	cp	0x7c
	jr	z,key_lf
	cp	0xf4
	jr	z,key_bs
	ret

key_esc:
	ld	l,27
	ret
key_lf:
	ld	l,10
	ret
key_bs:
	ld	l,__CRT_KEY_DEL
	ret

