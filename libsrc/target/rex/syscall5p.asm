;
;	System Call for REX6000
;
;	never tested this function
;	again with Damjan's algorithm
;	Daniel
;
;	$Id: syscall5p.asm,v 1.3 2015-01-19 01:33:06 pauloscustodio Exp $

		PUBLIC	syscall5p

.syscall5p
        ld      ix,2
        add     ix,sp
        ld      l,(ix+0)        ;par 5
        ld      h,(ix+1)
        ld      ($c00a),hl
	ld      a,h
        ld      hl,0
        and     a,$e0           ; compare if points to $8000-$9FFF
        add     a,$80           
        jp      Z, syscall5p_1 
        in      a,(1)           ; load mem page of addin code
        ld      l,a
.syscall5p_1
        ld      ($c00c),hl      ;par 6

        ld      l,(ix+2)        ;par 4
        ld      h,(ix+3)
        ld      ($c008),hl
        ld      l,(ix+4)        ;par 3
        ld      h,(ix+5)
        ld      ($c006),hl
        ld      l,(ix+6)        ;par 2
        ld      h,(ix+7)
        ld      ($c004),hl
        ld      l,(ix+8)        ;par 1
        ld      h,(ix+9)
        ld      ($c002),hl
        ld      l,(ix+10)       ;call
        ld      h,(ix+11)
        ld      ($c000),hl
        rst     $10
        ld      hl,($c00e)
        ret
