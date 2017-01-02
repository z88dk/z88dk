; strupr function for use with far pointers
; 1/4/00 GWL

;
; $Id: strupr_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;

        SECTION   code_clib
		EXTERN farseg1,incfar
                PUBLIC strupr_far
                PUBLIC _strupr_far


;far *strupr(far *s)
; converts s to uppercase

.strupr_far
._strupr_far
	pop	hl
	pop	bc
	pop	de		; EBC=far pointer
	push	de
	push	bc
	push	hl
	ld	a,($04d1)
	ex	af,af'		; save seg 1 binding
	call	farseg1		; bind to segment 1, with address in HL
.strupr1
        ld      a,(hl)
        and     a
	jr	z,struprend
	cp	'a'
	jr	c,strupr2
	cp	'z'+1
	jr	nc,strupr2
	and	223
	ld	(hl),a
.strupr2
        call    incfar
        jr      strupr1
.struprend
	ex	af,af'
	ld	($04d1),a
	out	($d1),a		; rebind segment 1
	pop	hl
	pop	bc
	pop	de		; get EBC=pointer again
	push	de
	push	bc
	jp	(hl)		; save 1 byte returning!
