;
;	Sharp MZ80B Routines
;
;	fgetc_cons() Wait for keypress
;
;
;	UncleBod - 2018-09-28
;	No Monitor will be used
;
;
;	No auto-repeat for now.
;	Maybe someone wants to improve this ?
;
;	$Id: fgetc_cons.asm,v 1.5 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons

		call	getky   ;get key
		and	a
		jr		nz,fgetc_cons

.wkey
		call	getky   ;get key
		and a
		jr	z,wkey

		cp	$66	; was it ENTER ?
		jr	nz,noenter
IF STANDARDESCAPECHARS
		ld	a,10
ELSE
		ld	a,13
ENDIF
.noenter
; Handling of DEL key
		cp	$60	;DEL
		jr	nz,nodelkey
		ld	a,8	;DEL_KEY
.nodelkey		

		ld	l,a
		ld	h,0
		ret
.getky
		push	bc
		push	de
		push	hl
		call	key
		pop		hl
		pop		de
		pop		bc
		cp		$1e
		ret		nz
		xor		a
		ret
		
; This will be easy I thought. Just copy from the Monitor source I found on internet
; The official listing and the SB5510 I dissasembled differs...
; Even more, the dissassembled listing seems to have bugs....
.key						;sub_9050h to sub_0a6eh -1
.kswep	in		a,($e8)
		and		$f0
		or		$1b
		ld		d,a			;D=strobe
		out		($e8),a
		xor		a
		ld		(kdatw),a
		ld		(kdatw1),a
		in		a,($ea)
		cpl
		ld		b,a			;B=bit data
		ld		c,$ea		;C=I/O port
.swep
		dec		c
		dec		c
		dec		d
		out		(c),d
		inc		c
		inc		c
		push	de
		ld		h,kstd
		ld		a,d
		and		$of
		ld		e,a
		ld		d,0
		add		hl,de
		in		a,(c)
		ld		e,a
		cpl
		and		(hl)
		ld		(hl),e
		pop		de
		ld		e,a
		or		a
		call	nz,data1
		ld		a,d			;stobe end?
		and		$0f
		jr		nz,swep
		ld		de,(kdatw)
		ld		a,e
		or		a
		jr		nz,data		;kswep end
.nokd	xor		a
		ld		(keda),a
		ld		(kestrb),a
.nokd1	ld		hl,kybda	;Special bit data
		ld		a,b
		cp		(hl)
		jr		z,kfina
		ld		(hl),a
.nokd2	ld		hl,mode		;RGSX
		cp		$01
		jr		z,grpho		;G
		cp		$02
		jr		z,small0	;SL
		cp		$03			;Disp CR
		jr		z,crdis		;G+SL
		cp		$05
		jr		z,gshfo		;G+S
		cp		$06
		jr		z,smshfo	;SL+S
		cp		$08
		jr		z,rvso		;R
		cp		$0c
		jr		nz,kfina
.rshfo	ld		a,$0c		;R+S
.kdis	ret
.grpho	bit		6,(hl)
		jr		z,kfina
.lmod	ld		a,$0e
		ret					; KDIS
		;Till 09c9
