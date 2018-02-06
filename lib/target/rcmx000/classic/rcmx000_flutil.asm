
fel:
	ld hl,felstr
	call outstr
endhere: jr endhere

felstr: defm "Something went wrong while flashing",10,0
	
dot:
	push hl
	push de
	push bc
	push ix
	push iy
	push af

	ld hl,dotstr
	call outstr

	pop af
	pop iy
	pop ix
	pop bc
	pop de
	pop hl
	ret


; Temp storage for flashbytes and flashbyte
start_seg:
	defb 0
offset:
	defw 0
ramptr:
	defw 0
numbytes:
	defw 0


flashbytes:
	; a contains start segment
	; hl contains offset
	; bc contains pointer to bytes to burn (in RAM)
	; de contains number of bytes to burn

	ld (start_seg),a
	ld (offset),hl
	ld (ramptr),bc
	ld (numbytes),de

morebytes:

	ld hl,(ramptr)
	ld c,(hl)
	ld a,(start_seg)
	ld hl,(offset)
	ld de,(numbytes)
	call flashbyte		; bc will get destroyed

	; Check if writing went well..
	ld a,(start_seg)
	ld hl,(offset)
	call peekb ; result now in a...	

	ld d,a
	ld bc,(ramptr)
	ld a,(bc)
	cp d
	jr nz,fel		
	
	call dot

	
	ld hl,(offset)
	ld bc,(ramptr)
	ld de,(numbytes)
	inc hl
	inc bc
	dec de
	ld (offset),hl
	ld (ramptr),bc
	ld (numbytes),de

	; This will wrap hl=4096 back to 0 and increment a
	ld hl,(offset)	
	ld a,(start_seg)
	call checkseg
	ld (offset),hl
	ld (start_seg),a

	ld de,(numbytes)
	ld a,d
	or e             ; Flags set here ...
	jr nz,morebytes  ; ... should still be intact here
	
	ld a,(start_seg)
	ld hl,(offset)
	ld bc,(ramptr)
	ld de,(numbytes)

	ret

checkseg:
	; Here we should check so hl < 4096
	; and if so set it back to 0 and increment segment reg (a)

	push af

	ld a,h
	cp 16  ; b=16 => hl=4096, time to wrap...

	jr nz,dontwrap

	ld hl,0
	pop af
	inc a	
	ret	

dontwrap:
	pop af
	ret


frv:
	defm "Done flashing! Now reset target!!!",0

flashbyte:

	; a contains the start-segment
	; hl contains the offset
	; c contains byte to burn
	; bc returns number of cycles it took to program
	

	push af
	push bc
	push hl
	
	defb 0edh, 067h ; ld xpc,a

	ld a,85h
	ld hl,555h
	ld c,0aah
	call pokeb

	ld a,82h
	ld hl,0aaah
	ld c,55h
	call pokeb
	
	ld a,85h
	ld hl,555h
	ld c,0a0h
	call pokeb

	pop hl
	pop bc
	pop af

	push de
	push hl
	push af

	call pokeb


	; xpc loaded above with 80-0e so we add e000 offset to
	; get physical address 80000
	ld hl,0e000h

	;  A special optimised togglewait here for speed and granularity
	ld bc,0
togglw:
	ld a,(hl)
	ld d,a
	ld a,(hl)
	cp d
	inc bc
	jr nz,togglw

	pop af
	pop hl
	pop de	

	ret

erase:
	ld a,85h
	ld hl,555h
	ld c,0aah
	call pokeb

	ld a,82h
	ld hl,0aaah
	ld c,55h
	call pokeb

	ld a,85h
	ld hl,555h
	ld c,80h
	call pokeb

	ld a,85h
	ld hl,555h
	ld c,0aah
	call pokeb

	ld a,82h
	ld hl,0aaah
	ld c,55h
	call pokeb

	ld a,85h
	ld hl,555h
	ld c,10h
	call pokeb
	ret

waittoggle:
	; a should contain segment of flash in memory, i.e 80h for most (all?) rabbits
	; Will return number of waitloop turns in bc
	push hl
	push de

	ld bc,0

waittoggleloop:

	ld a,80h
	ld hl,0
	call peekb
	ld d,a    ; Store away first read

	ld a,80h
	call peekb
	

	; a and b now contains the two values...
	cp d

	inc bc

	jr nz,waittoggleloop

	pop de
	pop hl

	ret

pokeb:  ; a is the segment, hl is the address and c is the data
	push af
	push bc
	push de
	push hl


	; Add offset to 16-bit address and subtract from segment
	ld de, 0e000h;
	add hl,de
	sub a,14
	defb 0edh, 067h ; ld xpc,a
	ld (hl),c

	pop hl
	pop de
	pop bc
	pop af

	ret

peekb:  ; a is the segment, hl is the address and data is returned in a
	push bc
	push de
	push hl

	; Add offset to 16-bit address and subtract from segment
	ld de, 0e000h;
	add hl,de
	sub a,14
	defb 0edh, 067h ; ld xpc,a
	ld a,(hl)
	pop hl
	pop de
	pop bc

	ret
	
fin_str:
	defm 10,"Finnished flashing, now reset target...",10,0
erase_str:
	defm "Erased flash...",10,0

dotstr:	defm ".",0


outstr:
	ld (_s_ostr), hl
	call _OUTSTR
	ret

