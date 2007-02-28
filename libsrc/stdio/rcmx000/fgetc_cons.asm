;
;	RCM2/3000 Stdio
;
;	$Id: fgetc_cons.asm,v 1.1 2007-02-28 11:23:17 stefano Exp $
;

	XLIB	fgetc_cons
	LIB	rcmx000_cnvtab

	XREF __recvchar

.fgetc_cons
	; extern int __LIB__ fgetc(FILE *fp);

	; return result in HL, when done
	; We ignore FILE* fp (in BC) for now
	
	call __recvchar	

	ld h,0
	ld l,a

	ret 
