;
;	ZX81 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 8/5/2000
;
;
;	$Id: getk.asm $
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
	EXTERN  __lambda_keyboard
	call	__lambda_keyboard
ELSE
	call	699
ENDIF

        LD      B,H             ;
        LD      C,L             ;
        LD      D,C             ;
        INC     D  

IF FORlambda
	EXTERN  __lambda_decode
	call	nz,__lambda_decode
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
