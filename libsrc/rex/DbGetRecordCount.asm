;
;	System Call for REX6000
;
;	$Id: DbGetRecordCount.asm,v 1.1 2001-07-02 07:18:44 dmarion Exp $
;
; extern unsigned long DbGetRecordCount( int );
;
; Written by Damjan Marion <dmarion@open.hr>

		XLIB	DbGetRecordCount


.DbGetRecordCount
	pop	ix
	pop	hl
	push 	hl
	push 	ix
        ld      de,$00ee    	;DB_GETRECORDCOUNT
        ld      ($c000),de
        ld      ($c002),hl 	; param 1
	ld	hl,0
	push 	hl
	push	hl
	add 	hl,sp
        ld      ($c004),hl 	; param 2, ptr to long
	rst	$10
	pop	hl
	pop	de
	ret
	
