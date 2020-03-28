;
;	System Call for REX6000
;
;	I've never tested this function, hope it works. Daniel
;
;	$Id: syscall1p.asm,v 1.4 2015-01-19 01:33:06 pauloscustodio Exp $

		PUBLIC	syscall1p


.syscall1p
	pop	bc
	pop	de	;parameter
	pop	hl	;call number
	push	hl
	push	de
	push	bc
	ld	($c000),hl	
	ld	($c002),de
	ld      a,h
        ld      hl,0
        and     a,$e0           ; compare if points to $8000-$9FFF
        add     a,$80           
        jp      Z, syscall1p_1 
        in      a,(1)           ; load mem page of addin code
        ld      l,a
.syscall1p_1
        ld      ($c004),hl      ;par 2
	rst	$10
	ld	hl,($c00e)
	ret


