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
IF !__CPU_INTEL__
	push ix
ENDIF

	call const
	and  a
	jr   z,getk_end

.empty_buffer
	call conin
	ld   e,a
	push de
	call const
	pop  de
	and  a
	jr   nz,empty_buffer
	
	ld   a,e
	
.getk_end
	ld   h,0
	ld   l,a
IF !__CPU_INTEL__
	pop ix
ENDIF
	ret


.conin
	ld   de,6
	jr   console
.const
	ld   de,3
.console
	ld   hl,(1)	; WBOOT (BIOS)
	add  hl,de
	jp   (hl)

