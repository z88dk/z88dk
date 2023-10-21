;
;	ZX81 libraries - Stefano
;
;-------------------------------------------------------------------
;
;	$Id: zx_cls.asm $
;
;-------------------------------------------------------------------
;
; ROM mode CLS.. useful to expand collapsed display file.
; It also restores the ROM character set if a UDG font was defined.
;
;-------------------------------------------------------------------

        SECTION code_clib
	PUBLIC   zx_cls
	PUBLIC   _zx_cls
	
IF FORzx80
	EXTERN    filltxt
ELSE
	EXTERN    restore81
	EXTERN    zx_topleft
ENDIF

zx_cls:
_zx_cls:
IF FORzx80
	LD      A,$0E           ; set the I register to $0E to tell
	LD      I,A             ; the video hardware where to find
							; the character set ($0E00).
	ld	l,0
	jp	filltxt
ENDIF
IF FORzx81
	LD      A,$1E           ; address for this ROM is $1E00.
	LD      I,A             ; set I register from A.
	call  restore81
	call  $A2A
	jp    zx_topleft
ENDIF
IF FORlambda
	call  restore81
	EXTERN  __lambda_cls
	call    __lambda_cls
	jp    zx_topleft
ENDIF
