	SECTION code_clib	
	PUBLIC	VRAMToHL

;==============================================================
; VRAM to HL
;==============================================================
; Sets VRAM write address to hl
;==============================================================
.VRAMToHL
	push	af
	ld 	a,l
        out 	($bf),a
        ld 	a,h
        or 	$40
        out 	($bf),a
	pop 	af
	ret
