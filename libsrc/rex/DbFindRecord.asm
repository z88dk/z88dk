;
;	System Call for REX6000
;
;	$Id: DbFindRecord.asm,v 1.1 2001-07-02 07:18:15 dmarion Exp $
;
; extern INT DbFindRecord(int, char, char,  ... );
;
; Written by Damjan Marion <dmarion@open.hr>

		XLIB	DbFindRecord


.DbFindRecord
	sub	3		;except 1st 3 params
 	ld 	b,a
 	ld 	ix,2
 	add 	ix,sp
.DbFindRecord_1
 	ld 	l,(ix+0)
        ld 	h,(ix+1)
 	push 	hl
 	inc 	ix
 	inc 	ix
	djnz 	DbFindRecord_1	;repush args in REX order

  	ld 	hl,0
  	add 	hl,sp
	push 	hl
  	ld 	hl,0
  	add 	hl,sp
  	ld	($c008),hl 	; param 5 - points to pointer to other parameters
 	ld 	l,(ix+0)
        ld 	h,0
  	ld	($c006),hl 	; param 4
	inc 	ix
	inc 	ix
 	ld 	l,(ix+0)
        ld 	h,0
  	ld	($c004),hl 	; param 2
	inc 	ix
	inc 	ix
 	ld 	l,(ix+0)
        ld 	h,(ix+1)
        ld      ($c002),hl 	; param 1
        ld      de,$00e0    	;DB_FINDRECORD
        ld      ($c000),de
        push 	af	    	; save number of args
        rst	$10
	pop	af
        pop 	hl

;get parameters from stack
 	ld 	b,a
.DbFindRecord_2
 	pop 	ix		
 	djnz DbFindRecord_2

 	ld      hl,($c00e)
 	ret 
