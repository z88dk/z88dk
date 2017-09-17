; strlen function for use with far pointers
; 31/3/00 GWL

;
; $Id: strlen_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;

        SECTION   code_clib
		EXTERN farseg1,incfar
                PUBLIC strlen_far
                PUBLIC _strlen_far


;int strlen(far *s)
; finds length of s

.strlen_far
._strlen_far
	pop	hl
	pop	bc
	pop	de		; EBC=far pointer
	push	de
	push	bc
	push	hl
	ld	a,($04d1)
	ex	af,af'		; save seg 1 binding
	ld	ix,0		; our counter
	call	farseg1		; bind to segment 1, with address in HL
.strlen1
        ld      a,(hl)		; check for string end
        and     a
	jr	z,strlenend
	inc	ix		; increment counter
        call    incfar
        jr      strlen1
.strlenend
	ex	af,af'
	ld	($04d1),a
	out	($d1),a		; rebind segment 1
        push    ix
        pop     hl              ; HL=length
	ret
