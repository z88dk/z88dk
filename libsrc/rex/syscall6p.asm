;
;	System Call for REX6000
;
;	$Id: syscall6p.asm,v 1.3 2001-06-25 12:59:13 dom Exp $
;
;

		XLIB	syscall6p

.syscall6p
        ld      ix,2
        add     ix,sp
        ld      l,(ix+0)        ;par 6
        ld      h,(ix+1)
        ld      ($c00c),hl
       ld      a,h
        ld      hl,0
        and     a,$e0           ; compare if points to $8000-$9FFF
        add     a,$80           
        jp      NZ, syscall6p_1 
        in      a,(1)           ; load mem page of addin code
        ld      l,a
.syscall6p_1
        ld      ($c00e),hl      ;par 7

        ld      l,(ix+2)        ;par 5
        ld      h,(ix+3)
        ld      ($c00a),hl
        ld      l,(ix+4)        ;par 4
        ld      h,(ix+5)
        ld      ($c008),hl
        ld      l,(ix+6)        ;par 3
        ld      h,(ix+7)
        ld      ($c006),hl
        ld      l,(ix+8)        ;par 2
        ld      h,(ix+9)
        ld      ($c004),hl
        ld      l,(ix+10)       ;par 1
        ld      h,(ix+11)
        ld      ($c002),hl
        ld      l,(ix+12)       ;call
        ld      h,(ix+13)
        ld      ($c000),hl
        rst     $10
        ld      hl,($c00e)
        ret


IF INCORRECT

.syscall6p
	ld	ix,2
	add	ix,sp
	ld	l,(ix+0)	;par 6
	ld	h,(ix+1)
	ld	($c00e),hl
	ld	l,(ix+2)	;par 6
	ld	h,(ix+3)
	ld	($c00c),hl
	ld	l,(ix+4)	;par 5
	ld	h,(ix+5)
	ld	($c00a),hl
	ld	l,(ix+6)	;par 4
	ld	h,(ix+7)
	ld	($c008),hl
	ld	l,(ix+8)	;par 3
	ld	h,(ix+9)
	ld	($c006),hl
	ld	l,(ix+10)	;par 2
	ld	h,(ix+11)
	ld	($c004),hl
	ld	l,(ix+12)	;par 1
	ld	h,(ix+13)
	ld	($c002),hl
	ld	l,(ix+14)	;call
	ld	h,(ix+15)
	ld	($c000),hl
	rst	$10
	ld	hl,($c00e)
	ret

ENDIF
