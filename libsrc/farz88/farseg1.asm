; Sample subroutine to bind a far address to segment 1
; 23/3/0 GWL
; 1/4/00 Fixed local memory bug
;
; Entry: EBC=far pointer
;	 A'=binding of seg 1 for local memory
; Exit:  EBC=far pointer (still!)
;	 A'=binding of seg 1 for local memory (still!)
;	 HL=local address (bound to seg 1)
;
;
; $Id: farseg1.asm,v 1.4 2016-06-10 22:42:22 dom Exp $
;


	SECTION code_clib
	PUBLIC	farseg1

        EXTERN    malloc_table


.farseg1
        ld      a,e
        and     a
        jr      z,localfar      ; move on if we've got a local pointer
        ld      hl,malloc_table
        dec     e
	ld	d,e
	ld	e,b
	add	hl,de
	add	hl,de		; HL points to 2-byte entry
	ld	e,d
        inc     e               ; restore EBC
	ld	a,(hl)		; A=bank
	inc	hl
	ld	h,(hl)		; H=address high byte (in seg 1)
	ld	l,c		; low byte is the same
	ld	($04d1),a
	out	($d1),a		; bind to segment 1
	ret
.localfar
	ex	af,af'
	ld	($04d1),a
	out	($d1),a		; bind local memory to seg 1
	ex	af,af'
        ld      h,b
        ld      l,c
        ret
