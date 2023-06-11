;
;	Keyboard routines for the VEB MPM KC85/2,3,4
;
;	By Stefano Bodrato - Oct. 2016
;
;	getk() Read key status
;
;	Patched in #2081
;

	SECTION code_clib
	PUBLIC  getk
	PUBLIC  _getk

	INCLUDE  "target/kc/def/caos.def"

.getk
._getk
	push iy
	ld iy,$1f0
	call PV1
	defb FNKBDS
	pop iy
	jr NC,nokey

IF STANDARDESCAPECHARS
	cp 13
	jr NZ,not_return
	ld a,10
.not_return
ENDIF

	ld l,a
	jr gkret
.nokey
	ld l,0
.gkret
	ld h,0
	ret
