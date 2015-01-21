;
;	RCM2/3000 Stdio
;
;	$Id: fgetc_cons.asm,v 1.2 2015-01-21 08:09:27 stefano Exp $
;

	PUBLIC	fgetc_cons
	EXTERN	rcmx000_cnvtab

	EXTERN __recvchar

.fgetc_cons
	; extern int __LIB__ fgetc(FILE *fp);

	; return result in HL, when done
	; We ignore FILE* fp (in BC) for now
	
	call __recvchar	

	ld h,0
	ld l,a

	ret 
