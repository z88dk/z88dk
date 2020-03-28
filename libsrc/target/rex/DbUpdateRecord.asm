;
;	System Call for REX6000
;
;	$Id: DbUpdateRecord.asm,v 1.3 2017-01-03 00:11:31 aralbrec Exp $
;
; extern INT DbUpdateRecord( int, ... );
;

		PUBLIC	DbUpdateRecord
      PUBLIC   _DbUpdateRecord

.DbUpdateRecord
._DbUpdateRecord
 	ld 	b,a
 	ld 	ix,2
 	add 	ix,sp
.DbUpdateRecord_1
 	ld 	l,(ix+0)
        ld 	h,(ix+1)
 	push 	hl
 	inc 	ix
 	inc 	ix
	djnz 	DbUpdateRecord_1

        ld      de,$00e6 	;DB_UPDATERECORD
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
.DbUpdateRecord_2
 	pop 	ix
 	djnz DbUpdateRecord_2

 	ld      hl,($c00e)
 	ret 

