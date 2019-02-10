;
;	System Call for REX6000
;
;	$Id: syscallex.asm,v 1.8 2015-01-19 01:33:06 pauloscustodio Exp $
;
; extern INT SYSCALLEX( int, ... );
;
;	Latest version from Damjan..it works. 
; 

		PUBLIC	syscallex

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



