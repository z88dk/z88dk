;
;		Direct I/O to the second Z80 CPU for the video generation
;		internal function to upload and execute code on the SUB-CPU
;		hl=program addr
;		de=length
;
;		Stefano Bodrato, 2023
;
;
;	$Id: mbc_sub.asm $
;
		SECTION code_clib

		PUBLIC    mbc_sub
		
		EXTERN  mbc_sendchar


mbc_sub:

	push hl
	push de
	
	; ESC 'L':  upload code
	ld l,27
	call mbc_sendchar
	ld l,'L'
	call mbc_sendchar

	pop de
	
	ld l,d
	call mbc_sendchar
	ld l,e
	call mbc_sendchar
	
	pop hl

upload_code:
	ld a,(hl)

	push hl
	ld l,a
	call mbc_sendchar
	pop hl

	inc hl
	dec de
	ld a,d
	or e
	jr nz,upload_code


	; ESC 'JP':  execute the uploaded code
	ld l,27
	call mbc_sendchar
	ld l,'J'
	call mbc_sendchar
	ld l,'P'
	jp mbc_sendchar

