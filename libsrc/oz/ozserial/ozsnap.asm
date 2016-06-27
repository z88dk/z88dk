;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;	Serial libraries
;
;
; ------
; $Id: ozsnap.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozsnap
	PUBLIC	_ozsnap
	EXTERN	ozactivepage

ozsnap:
_ozsnap:
	in a,(43h)
	push af
	ld a,80h
	out (43h),a
	in a,(40h)
	push af
	in a,(41h)
	push af
	ld a,4
	out (40h),a
	xor a
	out (41h),a
	ld a,3
	out (43h),a
	
	in a,(03h)
	ld c,a
	in a,(04h)
	ld b,a
	push bc
	ld bc,(ozactivepage)
	ld a,c
	out (03h),a
	ld a,b
	out (04h),a
	xor a
	
yloop:
	push af
	
	call hexout
	ld d,0
	ld e,a
	
uartwait3:
	in a,(45h)
	bit 5,a
	jr z,uartwait3
	ld a,':'
	out (40h),a
	
	ld hl,500h
	add hl,de
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	cp a
	sbc hl,de
	add hl,hl
	
	ld b,30
xloop:	ld a,(hl)
	call hexout
	inc hl
	djnz xloop
	
uartwait4:
	in a,(45h)
	bit 5,a
	jr z,uartwait4
	ld a,13
	out (40h),a
	
uartwait5:
	in a,(45h)
	bit 5,a
	jr z,uartwait5
	ld a,10
	out (40h),a
	
	pop af
	inc a
	cp 80
	jp nz,yloop
	
	pop bc
	ld a,c
	out (03h),a
	ld a,b
	out (04h),a 
	
	ld a,80h
	out (43h),a
	pop af
	out (41h),a
	pop af
	out (40h),a
	pop af
	out (43h),a
	ret
	
hexout:
	push af
	push bc
	ld b,a
	uartwait1:
	in a,(45h)
	bit 5,a
	jr z,uartwait1
	ld a,b
	srl a
	srl a
	srl a
	srl a
	cp 10
	jr c,numeric1
	add a,7
numeric1:
	add a,30h
	out (40h),a
uartwait2:
	in a,(45h)
	bit 5,a
	jr z,uartwait2
	ld a,b
	and 0Fh
	cp 10
	jr c,numeric2
	add a,7
numeric2:
	add a,30h
	out (40h),a
	pop bc
	pop af
	ret
