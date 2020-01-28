;
;	f_ansi_dline - clear line
;
;	djm 6/6/2000
;
;	Entry: a = row
;
;
;	$Id: f_ansi_dline.asm,v 1.6 2016-04-04 18:31:23 dom Exp $
;

	INCLUDE	"stdio.def"

	SECTION	code_clib
	PUBLIC	ansi_del_line


.ansi_del_line
	push	af
	ld	a,1
	call_oz(os_out)
	ld	a,'3'
	call_oz(os_out)
	ld	a,'@'
	call_oz(os_out)
	pop	af
	add	a,32
	call_oz(os_out)
	ld	hl,rest
	call_oz(gn_sop)
	ret
.rest
	defb	32,1,'2','C',253,0
