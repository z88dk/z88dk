;       Small C+ Z88 Support Library
;
;	Increment long on hl
;	Kept little endian
;
;       djm 26/2/2000

                XLIB    l_long_inc

.l_long_inc
	inc	(hl)
	ret	nz
	inc	(hl)
	ret	nz
	inc	(hl)
	ret	nz
	inc	(hl)
	ret
