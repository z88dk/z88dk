;
;	MC-1000 graphics library
;
;	$Id: pixladdr.asm $
;

;-----------  GFX paging  -------------

	SECTION	  code_driver 

	PUBLIC	pixeladdress

	PUBLIC	gfxbyte_get
	PUBLIC	pix_return

        EXTERN  __mc1000_modeval
	
.pixeladdress

	; add y-times the nuber of bytes per line (32)
	; or just multiply y by 32 and the add
	ld	e,l
	ld	a,h
	ld	b,a

	ld	h,0

	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl

	ld	de,$8000
	add	hl,de

	; add x divided by 8
	
	;or	a
	rra
	srl a
	srl a
	ld	e,a
	ld	d,0
	add	hl,de	
	
;-------
.gfxbyte_get

	ld	a,$9e
	out	($80),a

	ld	a,(hl)
	ld	d,h
	ld	e,l
	ld	hl,pixelbyte
	ld	(hl),a

	ld	a,(__mc1000_modeval)
	out	($80),a

	ld	a,b
	or	0f8h	;set all unused bits 1
	cpl			;they now become 0	
	ret


;-------
.pix_return

	ex	af,af	; dcircle uses the flags in af'.. watch out !
	ld	a,(__mc1000_modeval)
	out	($80),a

	ex	af,af	; dcircle uses the flags in af'.. watch out !
	ld	(de),a	; pixel address

	ld	a,(__mc1000_modeval)
        set     0,a
	out	($80),a
	ret

	
;-------

;;;	SECTION bss_clib -  (to be kept in the code_driver section)
	PUBLIC	pixelbyte

.pixelbyte
	 defb	0
