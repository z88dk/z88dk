;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.9.0 #11195 (Linux)
;--------------------------------------------------------
; Processed by Z88DK
;--------------------------------------------------------
	
	EXTERN __divschar
	EXTERN __divschar_callee
	EXTERN __divsint
	EXTERN __divsint_callee
	EXTERN __divslong
	EXTERN __divslong_callee
	EXTERN __divslonglong
	EXTERN __divslonglong_callee
	EXTERN __divsuchar
	EXTERN __divsuchar_callee
	EXTERN __divuchar
	EXTERN __divuchar_callee
	EXTERN __divuint
	EXTERN __divuint_callee
	EXTERN __divulong
	EXTERN __divulong_callee
	EXTERN __divulonglong
	EXTERN __divulonglong_callee
	EXTERN __divuschar
	EXTERN __divuschar_callee
	EXTERN __modschar
	EXTERN __modschar_callee
	EXTERN __modsint
	EXTERN __modsint_callee
	EXTERN __modslong
	EXTERN __modslong_callee
	EXTERN __modslonglong
	EXTERN __modslonglong_callee
	EXTERN __modsuchar
	EXTERN __modsuchar_callee
	EXTERN __moduchar
	EXTERN __moduchar_callee
	EXTERN __moduint
	EXTERN __moduint_callee
	EXTERN __modulong
	EXTERN __modulong_callee
	EXTERN __modulonglong
	EXTERN __modulonglong_callee
	EXTERN __moduschar
	EXTERN __moduschar_callee
	EXTERN __mulint
	EXTERN __mulint_callee
	EXTERN __mullong
	EXTERN __mullong_callee
	EXTERN __mullonglong
	EXTERN __mullonglong_callee
	EXTERN __mulschar
	EXTERN __mulschar_callee
	EXTERN __mulsuchar
	EXTERN __mulsuchar_callee
	EXTERN __muluschar
	EXTERN __muluschar_callee
	EXTERN __rlslonglong
	EXTERN __rlslonglong_callee
	EXTERN __rlulonglong
	EXTERN __rlulonglong_callee
	EXTERN __rrslonglong
	EXTERN __rrslonglong_callee
	EXTERN __rrulonglong
	EXTERN __rrulonglong_callee
	EXTERN ___sdcc_call_hl
	EXTERN ___sdcc_call_iy
	EXTERN ___sdcc_enter_ix
	EXTERN _banked_call
	EXTERN _banked_ret
	EXTERN ___fs2schar
	EXTERN ___fs2schar_callee
	EXTERN ___fs2sint
	EXTERN ___fs2sint_callee
	EXTERN ___fs2slong
	EXTERN ___fs2slong_callee
	EXTERN ___fs2slonglong
	EXTERN ___fs2slonglong_callee
	EXTERN ___fs2uchar
	EXTERN ___fs2uchar_callee
	EXTERN ___fs2uint
	EXTERN ___fs2uint_callee
	EXTERN ___fs2ulong
	EXTERN ___fs2ulong_callee
	EXTERN ___fs2ulonglong
	EXTERN ___fs2ulonglong_callee
	EXTERN ___fsadd
	EXTERN ___fsadd_callee
	EXTERN ___fsdiv
	EXTERN ___fsdiv_callee
	EXTERN ___fseq
	EXTERN ___fseq_callee
	EXTERN ___fsgt
	EXTERN ___fsgt_callee
	EXTERN ___fslt
	EXTERN ___fslt_callee
	EXTERN ___fsmul
	EXTERN ___fsmul_callee
	EXTERN ___fsneq
	EXTERN ___fsneq_callee
	EXTERN ___fssub
	EXTERN ___fssub_callee
	EXTERN ___schar2fs
	EXTERN ___schar2fs_callee
	EXTERN ___sint2fs
	EXTERN ___sint2fs_callee
	EXTERN ___slong2fs
	EXTERN ___slong2fs_callee
	EXTERN ___slonglong2fs
	EXTERN ___slonglong2fs_callee
	EXTERN ___uchar2fs
	EXTERN ___uchar2fs_callee
	EXTERN ___uint2fs
	EXTERN ___uint2fs_callee
	EXTERN ___ulong2fs
	EXTERN ___ulong2fs_callee
	EXTERN ___ulonglong2fs
	EXTERN ___ulonglong2fs_callee
	EXTERN ____sdcc_2_copy_src_mhl_dst_deix
	EXTERN ____sdcc_2_copy_src_mhl_dst_bcix
	EXTERN ____sdcc_4_copy_src_mhl_dst_deix
	EXTERN ____sdcc_4_copy_src_mhl_dst_bcix
	EXTERN ____sdcc_4_copy_src_mhl_dst_mbc
	EXTERN ____sdcc_4_ldi_nosave_bc
	EXTERN ____sdcc_4_ldi_save_bc
	EXTERN ____sdcc_4_push_hlix
	EXTERN ____sdcc_4_push_mhl
	EXTERN ____sdcc_lib_setmem_hl
	EXTERN ____sdcc_ll_add_de_bc_hl
	EXTERN ____sdcc_ll_add_de_bc_hlix
	EXTERN ____sdcc_ll_add_de_hlix_bc
	EXTERN ____sdcc_ll_add_de_hlix_bcix
	EXTERN ____sdcc_ll_add_deix_bc_hl
	EXTERN ____sdcc_ll_add_deix_hlix
	EXTERN ____sdcc_ll_add_hlix_bc_deix
	EXTERN ____sdcc_ll_add_hlix_deix_bc
	EXTERN ____sdcc_ll_add_hlix_deix_bcix
	EXTERN ____sdcc_ll_asr_hlix_a
	EXTERN ____sdcc_ll_asr_mbc_a
	EXTERN ____sdcc_ll_copy_src_de_dst_hlix
	EXTERN ____sdcc_ll_copy_src_de_dst_hlsp
	EXTERN ____sdcc_ll_copy_src_deix_dst_hl
	EXTERN ____sdcc_ll_copy_src_deix_dst_hlix
	EXTERN ____sdcc_ll_copy_src_deixm_dst_hlsp
	EXTERN ____sdcc_ll_copy_src_desp_dst_hlsp
	EXTERN ____sdcc_ll_copy_src_hl_dst_de
	EXTERN ____sdcc_ll_copy_src_hlsp_dst_de
	EXTERN ____sdcc_ll_copy_src_hlsp_dst_deixm
	EXTERN ____sdcc_ll_lsl_hlix_a
	EXTERN ____sdcc_ll_lsl_mbc_a
	EXTERN ____sdcc_ll_lsr_hlix_a
	EXTERN ____sdcc_ll_lsr_mbc_a
	EXTERN ____sdcc_ll_push_hlix
	EXTERN ____sdcc_ll_push_mhl
	EXTERN ____sdcc_ll_sub_de_bc_hl
	EXTERN ____sdcc_ll_sub_de_bc_hlix
	EXTERN ____sdcc_ll_sub_de_hlix_bc
	EXTERN ____sdcc_ll_sub_de_hlix_bcix
	EXTERN ____sdcc_ll_sub_deix_bc_hl
	EXTERN ____sdcc_ll_sub_deix_hlix
	EXTERN ____sdcc_ll_sub_hlix_bc_deix
	EXTERN ____sdcc_ll_sub_hlix_deix_bc
	EXTERN ____sdcc_ll_sub_hlix_deix_bcix
	EXTERN ____sdcc_load_debc_deix
	EXTERN ____sdcc_load_dehl_deix
	EXTERN ____sdcc_load_debc_mhl
	EXTERN ____sdcc_load_hlde_mhl
	EXTERN ____sdcc_store_dehl_bcix
	EXTERN ____sdcc_store_debc_hlix
	EXTERN ____sdcc_store_debc_mhl
	EXTERN ____sdcc_cpu_pop_ei
	EXTERN ____sdcc_cpu_pop_ei_jp
	EXTERN ____sdcc_cpu_push_di
	EXTERN ____sdcc_outi
	EXTERN ____sdcc_outi_128
	EXTERN ____sdcc_outi_256
	EXTERN ____sdcc_ldi
	EXTERN ____sdcc_ldi_128
	EXTERN ____sdcc_ldi_256
	EXTERN ____sdcc_4_copy_srcd_hlix_dst_deix
	EXTERN ____sdcc_4_and_src_mbc_mhl_dst_deix
	EXTERN ____sdcc_4_or_src_mbc_mhl_dst_deix
	EXTERN ____sdcc_4_xor_src_mbc_mhl_dst_deix
	EXTERN ____sdcc_4_or_src_dehl_dst_bcix
	EXTERN ____sdcc_4_xor_src_dehl_dst_bcix
	EXTERN ____sdcc_4_and_src_dehl_dst_bcix
	EXTERN ____sdcc_4_xor_src_mbc_mhl_dst_debc
	EXTERN ____sdcc_4_or_src_mbc_mhl_dst_debc
	EXTERN ____sdcc_4_and_src_mbc_mhl_dst_debc
	EXTERN ____sdcc_4_cpl_src_mhl_dst_debc
	EXTERN ____sdcc_4_xor_src_debc_mhl_dst_debc
	EXTERN ____sdcc_4_or_src_debc_mhl_dst_debc
	EXTERN ____sdcc_4_and_src_debc_mhl_dst_debc
	EXTERN ____sdcc_4_and_src_debc_hlix_dst_debc
	EXTERN ____sdcc_4_or_src_debc_hlix_dst_debc
	EXTERN ____sdcc_4_xor_src_debc_hlix_dst_debc

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	GLOBAL _m32_roundf
;--------------------------------------------------------
; Externals used
;--------------------------------------------------------
	GLOBAL _m32_poly
	GLOBAL _m32_invsqrtf
	GLOBAL _m32_invf
	GLOBAL _m32_sqr
	GLOBAL _m32_fmodf
	GLOBAL _m32_modff
	GLOBAL _m32_floor
	GLOBAL _m32_ceil
	GLOBAL _m32_ldexpf
	GLOBAL _m32_frexpf
	GLOBAL _m32_fabsf
	GLOBAL _m32_hypotf
	GLOBAL _m32_powf
	GLOBAL _m32_log10f
	GLOBAL _m32_logf
	GLOBAL _m32_expf
	GLOBAL _m32_sqrtf
	GLOBAL _m32_atanhf
	GLOBAL _m32_acoshf
	GLOBAL _m32_asinhf
	GLOBAL _m32_tanhf
	GLOBAL _m32_coshf
	GLOBAL _m32_sinhf
	GLOBAL _m32_atan2f
	GLOBAL _m32_atanf
	GLOBAL _m32_acosf
	GLOBAL _m32_asinf
	GLOBAL _m32_tanf
	GLOBAL _m32_cosf
	GLOBAL _m32_sinf
	GLOBAL __MAX_OPEN
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION bss_compiler
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	
IF 0
	
; .area _INITIALIZED removed by z88dk
	
	
ENDIF
	
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	SECTION IGNORE
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	SECTION code_crt_init
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	SECTION IGNORE
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION code_compiler
;	---------------------------------
; Function m32_roundf
; ---------------------------------
_m32_roundf:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	iy, -20
	add	iy, sp
	ld	sp, iy
	ld	(ix-8),l
	ld	(ix-7),h
	ld	(ix-6),e
	ld	(ix-5),d
	ld	hl,0
	add	hl, sp
	ex	de, hl
	ld	hl,0x000c
	add	hl, sp
	ld	bc,0x0004
	ldir
	ld	hl,0
	add	hl, sp
	ld	(ix-16),l
	ld	(ix-15),h
	ld	l,(ix-16)
	ld	h,(ix-15)
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	(ix-14),c
	ld	(ix-13),b
	ld	(ix-12),e
	ld	(ix-11),d
	ld	a,(ix-12)
	and	a,0x80
	ld	e, a
	ld	d,(ix-11)
	res	7, d
	ld	b,0x07
l_m32_roundf_00141:
	srl	d
	rr	e
	djnz	l_m32_roundf_00141
	ld	a, e
	add	a,0x81
	ld	(ix-10),a
	ld	a, d
	adc	a,0xff
	ld	(ix-9),a
	ld	a,(ix-10)
	sub	a,0x17
	ld	a,(ix-9)
	rla
	ccf
	rra
	sbc	a,0x80
	jp	NC, l_m32_roundf_00112
	bit	7,(ix-9)
	jr	Z,l_m32_roundf_00106
	ld	(ix-4),0x00
	ld	(ix-3),0x00
	ld	(ix-2),0x00
	ld	a,(ix-11)
	and	a,0x80
	ld	(ix-1),a
	ld	a,(ix-10)
	inc	a
	jp	NZ,l_m32_roundf_00113
	ld	a,(ix-9)
	inc	a
	jp	NZ,l_m32_roundf_00113
	ld	a,(ix-4)
	ld	(ix-4),a
	ld	a,(ix-3)
	ld	(ix-3),a
	ld	a,(ix-2)
	or	a,0x80
	ld	(ix-2),a
	ld	a,(ix-1)
	or	a,0x3f
	ld	(ix-1),a
	jp	l_m32_roundf_00113
l_m32_roundf_00106:
	ld	b,(ix-10)
	ld	de,0xffff
	ld	hl,0x007f
	inc	b
	jr	l_m32_roundf_00146
l_m32_roundf_00145:
	sra	h
	rr	l
	rr	d
	rr	e
l_m32_roundf_00146:
	djnz	l_m32_roundf_00145
	ld	c, e
	ld	b, d
	ld	hl,0x0000
	ld	a, c
	and	a,(ix-14)
	ld	c, a
	ld	a, b
	and	a,(ix-13)
	ld	b, a
	ld	a, l
	and	a,(ix-12)
	ld	l, a
	ld	a, h
	and	a,(ix-11)
	or	a, l
	or	a, b
	or	a, c
	jr	NZ,l_m32_roundf_00104
	ld	l,(ix-8)
	ld	h,(ix-7)
	ld	e,(ix-6)
	ld	d,(ix-5)
	jp	l_m32_roundf_00114
l_m32_roundf_00104:
	ld	a,(ix-10)
	push	af
	ld	bc,0x0000
	ld	hl,0x0040
	pop	af
	inc	a
	jr	l_m32_roundf_00148
l_m32_roundf_00147:
	sra	h
	rr	l
	rr	b
	rr	c
l_m32_roundf_00148:
	dec	a
	jr	NZ, l_m32_roundf_00147
	ld	a,(ix-14)
	add	a, c
	ld	c, a
	ld	a,(ix-13)
	adc	a, b
	ld	b, a
	ld	a,(ix-12)
	adc	a, l
	ld	l, a
	ld	a,(ix-11)
	adc	a, h
	ld	h, a
	ld	(ix-12),c
	ld	(ix-11),b
	ld	(ix-10),l
	ld	(ix-9),h
	ld	a, e
	cpl
	ld	c, a
	ld	a, d
	cpl
	ld	b, a
	ld	de,0x0000
	ld	a,(ix-12)
	and	a, c
	ld	(ix-4),a
	ld	a,(ix-11)
	and	a, b
	ld	(ix-3),a
	ld	a,(ix-10)
	and	a, e
	ld	(ix-2),a
	ld	a,(ix-9)
	and	a, d
	ld	(ix-1),a
	jr	l_m32_roundf_00113
l_m32_roundf_00112:
	ld	a,(ix-10)
	sub	a,0x80
	or	a,(ix-9)
	jr	NZ,l_m32_roundf_00109
	ld	l,(ix-6)
	ld	h,(ix-5)
	push	hl
	ld	l,(ix-8)
	ld	h,(ix-7)
	push	hl
	ld	l,(ix-6)
	ld	h,(ix-5)
	push	hl
	ld	l,(ix-8)
	ld	h,(ix-7)
	push	hl
	call	___fsadd_callee
	ld	(ix-4),l
	ld	(ix-3),h
	ld	(ix-2),e
	ld	(ix-1),d
	ld	l,(ix-4)
	ld	h,(ix-3)
	ld	e,(ix-2)
	ld	d,(ix-1)
	jr	l_m32_roundf_00114
l_m32_roundf_00109:
	ld	l,(ix-8)
	ld	h,(ix-7)
	ld	e,(ix-6)
	ld	d,(ix-5)
	jr	l_m32_roundf_00114
l_m32_roundf_00113:
	ld	e,(ix-16)
	ld	d,(ix-15)
	ld	hl,0x0010
	add	hl, sp
	ld	bc,0x0004
	ldir
	ld	hl,0
	add	hl, sp
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	l, c
	ld	h, b
l_m32_roundf_00114:
	ld	sp, ix
	pop	ix
	ret
	SECTION IGNORE
