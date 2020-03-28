;
;	ZX81 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 8/5/2000
;
;
;	$Id: getk.asm,v 1.7 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk
	EXTERN	zx81toasc

        EXTERN    restore81

.getk
._getk
	call	restore81
	
IF FORlambda
	call	3444
ELSE
	call	699
ENDIF

        LD      B,H             ;
        LD      C,L             ;
        LD      D,C             ;
        INC     D  
IF FORlambda
	call	nz,6263
ELSE
	call	nz,1981	;exits with e = key
ENDIF
	jr	nc,nokey

	call	zx81toasc
	ld	l,a
	ld	h,0
	ret
nokey:
	ld	hl,0
	ret
