
PUBLIC call_extrom

call_extrom:
	di
	push af
	in a,($ff)
	set 7,a
	out ($ff),a
	in a,($f4)
	ld (hssave),a
	ld a,1
	out ($f4),a
	pop af
	push hl
	ld hl,call_extrom_exit
	ex (sp),hl
	jp (hl)

hssave:
	defb 0

call_extrom_exit:
	ld a,(hssave)
	out ($f4),a
	in a,($ff)
	res 7,a
	out ($ff),a
	ei
	ret

