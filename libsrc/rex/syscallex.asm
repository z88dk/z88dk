;
;	System Call for REX6000
;
;	$Id: syscallex.asm,v 1.5 2001-06-23 19:44:53 dom Exp $
;
; extern INT SYSCALLEX( int, ... );
;
;	Latest version from Damjan..it works. 
; 

		XLIB	syscallex

.syscallex
 	ld 	b,a
 	ld 	ix,2
 	add 	ix,sp
.syscallex_1
 	ld 	l,(ix+0)
        ld 	h,(ix+1)
 	push 	hl
 	inc 	ix
 	inc 	ix
	djnz 	syscallex_1

        ld      de,$00ce
        ld      ($c000),de
        ld      ($c002),hl
  	ld 	hl,2
  	add 	hl,sp
	push 	hl
  	ld 	hl,0
  	add 	hl,sp
  	ld	($c004),hl
        push 	af
        rst	$10
	pop	af
        pop 	hl

 	ld 	b,a
.syscallex_2
 	pop 	ix
 	djnz syscallex_2

 	ld      hl,($c00e)
 	ret 

IF INCORRECT
; we supply a pointer to a pointer to the args push'd
;
; We need to repush our arguments in the correct order (well, correct for
; the SDK)
; 

.syscallex
	ld	b,a	;number of parameters give
	add	a,a	
	ld	e,a
	ld	d,0
	ld	ix,0
	add	ix,sp
	add	ix,de	;ix now points to first given parameter i.e. syscall
	ld	e,(ix+0)
	ld	d,(ix+1)
	ld	($c002),de	;store the actual syscall we want
	dec	ix
	dec	ix
	dec	b		;now holds number of parameters left
; Now we have to get the parameters in the correct order
	ld	c,b		;number of parameters - keep it safe!
.syscallex1
	ld	l,(ix+0)
	ld	h,(ix+1)
	push	hl
	dec	ix	
	dec	ix
	djnz	syscallex1
	ld	b,0
	push	bc
	pop	ix		;get number of stack
	ld	hl,0
	add	hl,sp		;address of our parameters
	push	hl	
	ld	hl,0
	add	hl,sp		;ptr to ptr to params
	ld	($c004),hl
	ld	hl,$00ce	;DS_SYSCALL_EXTENDED
	ld	($c000),hl
	rst	$10		;ix survives the call
	ld	b,ixl		;terrible inefficient, but I'm lazy
	pop	de		;discard ptr to ptr to args
.syscallex2
	pop	de
	djnz	syscallex2
	ld	hl,($c00e)
	ret
ENDIF



IF INCORRECT
; A holds the number arguments
.syscallex
	ld	b,a
	add	a,a
	ld	e,a
	ld	d,0
	ld	hl,0
	add	hl,sp
	add	hl,de	;now points to top parameter
	ld	ix,$c000	;start of variables
.lp1
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	dec	hl
	dec	hl
	dec	hl
	ld	(ix+0),e
	ld	(ix+1),d
	inc	ix
	inc	ix
	djnz	lp1	;loop round till we have to params
	rst	$10	;call the stuff
	ld	hl,($c00e)
	ret
ENDIF


