; 
; Bootstrap for Pasopia7
;
; Loads track by track until it's all in memory
;

	SECTION	BOOTSTRAP
	EXTERN	__DATA_END_tail

	org	$f000
	
	di
	ld	hl,$d000
	ld	de,$f000
	ld	bc,512
	ldir
	jp	entry
entry:
	push	af
	ld	hl,banner
	call	print_msg
	pop	af
	ld	b, +(__DATA_END_tail / 2048) + 1
	ld	hl,0		;Destination 
	ld	de, $0201	;Start track 2
load_track:
	push	af		;drive
	push	bc		;number of tracks to read
	push	de		;sector
	push	hl		;address
        ld      bc,$1012
        call    $41f9
        ld      c,$13
        call    $41f9
        jr      c,load_failure
	ld	hl,dot
	call	print_msg
	pop	hl
	ld	a,h		;Step up address
	add	8
	ld	h,a
	pop	de
	inc	d		;Move to next track
	pop	bc
	pop	af
	djnz	load_track
	ld	a,2		;All RAM mode
        out     ($3c),a
jump_to_start:
	jp	0		;And start

	


load_failure:
	ld	hl,failed
	call	print_msg
loop:
	jr	loop

print_msg:
	xor	a
        out    ($3c),a
msg1:
	ld	a,(hl)
	and	a
	jr	z,done
	rst	$18
	inc	hl
	jr	msg1
done:
	ld	a,1
	out	($3c),a
	ret

failed:
	defm	"Error loading from disc"
	defb	0

banner:
	defm	"z88dk Pasopia Bootstrap - Loading"
	defb	10,13
	defb	0

dot:
	defm	"."
	defb	0

