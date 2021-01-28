
	MODULE	l_f32_uchar2f
	SECTION	code_fp_dai32

	PUBLIC	l_f32_uchar2f
	PUBLIC	l_f32_uint2f
	PUBLIC	l_f32_schar2f
	PUBLIC	l_f32_sint2f
	PUBLIC  l_f32_ulong2f
	PUBLIC  l_f32_slong2f

	EXTERN	___dai32_xflt
	EXTERN	___dai32_fpac
	EXTERN	___dai32_return

; Convert signed char/int in l to floating point value in dehl
l_f32_uchar2f:
    ld      h,0
l_f32_uint2f:
    ld      de,0
    jp      do_float
l_f32_schar2f:
    ld      a,l
    rlca
    sbc     a
    ld      h,a
l_f32_sint2f:
    ld      a,h
    rlca
    sbc     a
    ld      e,a
    ld      d,a
l_f32_ulong2f:
l_f32_slong2f:
do_float:
    ld      a,h
    ld      h,l
    ld      l,a
    ld      (___dai32_fpac+2),hl
    ex      de,hl
    ld      a,h
    ld      h,l
    ld      l,a
    ld      (___dai32_fpac+0),hl
    call    ___dai32_xflt
    jp      ___dai32_return

