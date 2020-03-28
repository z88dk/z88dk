;
;	Database Call for REX6000
;
;	DbUpdateField
;
;	$Id: DbUpdateField.asm,v 1.3 2017-01-03 00:11:31 aralbrec Exp $



		PUBLIC	DbUpdateField
      PUBLIC   _DbUpdateField


.DbUpdateField
._DbUpdateField
	sub	2		;except 1st 2 params
 	ld 	b,a
 	ld 	ix,2
 	add 	ix,sp
	ld	hl,0
	push	hl		; probably page address
.DbUpdateField_1
 	ld 	l,(ix+0)
        ld 	h,(ix+1)
 	push 	hl
 	inc 	ix
 	inc 	ix
	djnz 	DbUpdateField_1	;repush args in REX order

  	ld 	hl,0
  	add 	hl,sp
	push 	hl
  	ld 	hl,0
  	add 	hl,sp
  	ld	($c006),hl 	; param 4 - points to pointer to other parameters
 	ld 	l,(ix+0)
        ld 	h,(ix+1)
  	ld	($c004),hl 	; param 3
	inc 	ix
	inc 	ix
 	ld 	l,(ix+0)
        ld 	h,(ix+1)
        ld      ($c002),hl 	; param 2
        ld      de,$00e8    	;DB_UPDATERECORD
        ld      ($c000),de
        push 	af	    	; save number of args
        rst	$10
	pop	af
        pop 	hl

;get parameters from stack

 	ld 	b,a
.DbUpdateField_2
 	pop 	ix		
 	djnz 	DbUpdateField_2
	pop	hl
 	ld      hl,($c00e)
 	ret 
