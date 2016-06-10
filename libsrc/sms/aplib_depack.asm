	
	SECTION code_clib
	PUBLIC	aplib_depack
	PUBLIC	_aplib_depack

	EXTERN	aPLibMemory_bits
	EXTERN	aPLibMemory_byte
	EXTERN	aPLibMemory_LWM
	EXTERN	aPLibMemory_R0

;==============================================================
; aplib_depack(unsigned char *src, unsigned char *dest)	
;==============================================================
; Uncompresses data previously compressed with apLib
;==============================================================
.aplib_depack
._aplib_depack
	ld	hl, 2
	add	hl, sp
	ld	e, (hl)		; Destination address
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	a, (hl)		; Source address
	inc	hl
	ld	h, (hl)
	ld	l, a
	jp	depack

; Usage:
;
; .include this file in your code
; somewhere after that, an aPLibMemoryStruct called aPLibMemory must be defined somewhere in RAM
; ie. "aPLibMemory instanceof aPLibMemoryStruct" inside a .ramsection or .enum
;
; Then do
;
; ld hl,<source address>
; ld de,<destination address>
; call depack
;
; In my tests, depack() used a maximum of 12 bytes of stack, but this may vary with different data.
; This file is using WLA-DX syntax quite heavily, you'd better use it too...

;.struct aPLibMemoryStruct
;bits     db
;byte     db ; not directly referenced, assumed to come after bits
;LWM      db
;R0       dw
;.endst

; Reader's note:
; The structure of the code has been arranged such that the entry point is in the middle -
; this is so it can use jr to branch out to the various subsections to save a few bytes,
; but it makes it somewhat harder to read. "depack" is the entry point and "aploop" is
; the main loop.
; Subsections which are only referenced by calls are defined in separate .sections to enable
; better code packing in the output (more finely divided blobs).
; More optimisations may be possible; in general, size optimisations are favoured over speed.

.ap_getbit
	push bc
		ld bc,(aPLibMemory_bits)
		rrc c
		jr nc,ap_getbit_continue
		ld b,(hl)
		inc hl
.ap_getbit_continue
		ld a,c
		and b
		ld (aPLibMemory_bits),bc
	pop bc
	ret

.ap_getbitbc ;doubles BC and adds the read bit
	sla c
	rl b
	call ap_getbit
	ret z
	inc bc
	ret

.ap_getgamma
	ld bc,1
.ap_getgammaloop
	call ap_getbitbc
	call ap_getbit
	jr nz,ap_getgammaloop
	ret

.apbranch2
	;use a gamma code * 256 for offset, another gamma code for length
	call ap_getgamma
	dec bc
	dec bc
	ld a,(aPLibMemory_LWM)
	or a
	jr nz,ap_not_LWM
	;bc = 2? ; Maxim: I think he means 0
	ld a,b
	or c
	jr nz,ap_not_zero_gamma
	;if gamma code is 2, use old R0 offset, and a new gamma code for length
	call ap_getgamma
	push hl
		ld h,d
		ld l,e
		push bc
			ld bc,(aPLibMemory_R0)
			sbc hl,bc
		pop bc
		ldir
	pop hl
	jr ap_finishup
	
.ap_not_zero_gamma
	dec bc
.ap_not_LWM
	;do I even need this code? ; Maxim: seems so, it's broken without it
	;bc=bc*256+(hl), lazy 16bit way
	ld b,c
	ld c,(hl)
	inc hl
	ld (aPLibMemory_R0),bc
	push bc
		call ap_getgamma
		ex (sp),hl
		;bc = len, hl=offs
		push de
			ex de,hl
			;some comparison junk for some reason
			; Maxim: optimised to use add instead of sbc
      ld hl,-32000
      add hl,de
			jr nc,skip1
			inc bc
.skip1
      ld hl,-1280
      add hl,de
			jr nc,skip2
			inc bc
.skip2
      ld hl,-128
      add hl,de
			jr c,skip3
			inc bc
			inc bc
.skip3
			;bc = len, de = offs, hl=junk
		pop hl
		push hl
			or a
			sbc hl,de
		pop de
		;hl=dest-offs, bc=len, de = dest
		ldir
	pop hl
.ap_finishup
	ld a,1
	ld (aPLibMemory_LWM),a
	jr aploop
.apbranch1 ; Maxim: moved this one closer to where it's jumped from to allow jr to work and save 2 bytes
	ldi
	xor a
	ld (aPLibMemory_LWM),a
	jr aploop

.depack
	;hl = source
	;de = dest
	ldi
	xor a
	ld (aPLibMemory_LWM),a
	inc a
	ld (aPLibMemory_bits),a

.aploop
	call ap_getbit
	jr z, apbranch1
	call ap_getbit
	jr z, apbranch2
	call ap_getbit
	jr z, apbranch3
	;LWM = 0
	xor a
	ld (aPLibMemory_LWM),a
	;get an offset
	ld bc,0
	call ap_getbitbc
	call ap_getbitbc
	call ap_getbitbc
	call ap_getbitbc
	ld a,b
	or c
	jr nz,apbranch4
;	xor a  ;write a 0 ; Maxim: a is zero already (just failed nz test), optimise this line away
	ld (de),a
	inc de
	jr aploop
.apbranch4
	ex de,hl ;write a previous bit (1-15 away from dest)
	push hl
		sbc hl,bc
		ld a,(hl)
	pop hl
	ld (hl),a
	inc hl
	ex de,hl
	jr aploop
.apbranch3
	;use 7 bit offset, length = 2 or 3
	;if a zero is encountered here, it's EOF
	ld c,(hl)
	inc hl
	rr c
	ret z
	ld b,2
	jr nc,ap_dont_inc_b
	inc b
.ap_dont_inc_b
	;LWM = 1
	ld a,1
	ld (aPLibMemory_LWM),a

	push hl
		ld a,b
		ld b,0
		;R0 = c
		ld (aPLibMemory_R0),bc
		ld h,d
		ld l,e
		or a
		sbc hl,bc
		ld c,a
		ldir
	pop hl
	jr aploop
