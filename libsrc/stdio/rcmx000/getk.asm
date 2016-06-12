;
;	RCM2/3000 Stdio
;
;	$Id: getk.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk
	EXTERN	rcmx000_cnvtab

	EXTERN __recvchar

.getk
._getk
	; extern int __LIB__ fgetc(FILE *fp);

	; return result in HL, when done
	; We ignore FILE* fp (in BC) for now
	
	call __recvchar	

	ld h,0
	ld l,a

	ret 
