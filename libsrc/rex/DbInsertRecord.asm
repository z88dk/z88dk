;
;	System Call for REX6000
;
;	$Id: DbInsertRecord.asm,v 1.1 2001-07-24 09:11:43 dmarion Exp $
;
; extern INT DbInsertRecord( int, ... );
;

		XLIB	DbInsertRecord

.DbInsertRecord
 	ld 	b,a
 	ld 	ix,2
 	add 	ix,sp
.DbInsertRecord_1
 	ld 	l,(ix+0)
        ld 	h,(ix+1)
 	push 	hl
 	inc 	ix
 	inc 	ix
	djnz 	DbInsertRecord_1

        ld      de,$00d8 	;DB_INSERTRECORD
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
.DbInsertRecord_2
 	pop 	ix
 	djnz DbInsertRecord_2

 	ld      hl,($c00e)
 	ret 

