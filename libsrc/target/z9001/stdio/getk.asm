;
;	CPM Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2000
;	Stefano Bodrato - Mar. 2004 - fixed
;	Stefano Bodrato - 2019 - using BIOS rather than BDOS
;
;
;	$Id: getk.asm $
;

	SECTION	code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	ld	c,11
	call	5
	ld	hl,0
	and	a
	ret	z
        LD      c,1
        ld      e,255
        call    5
IF STANDARDESCAPECHARS
        cp      13
        ld      hl,10
        ret     z
        cp      10
        ld      hl,13
        ret     z
ENDIF
        ld      l,a
        ld      h,0
        ret
