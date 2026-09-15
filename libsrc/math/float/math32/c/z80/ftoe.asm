;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.6.0 #16639 (Linux)
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
	EXTERN __muluchar
	EXTERN __muluchar_callee
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
	EXTERN ___mulsint2slong
	EXTERN ___mulsint2slong_callee
	EXTERN ___muluint2ulong
	EXTERN ___muluint2ulong_callee
	EXTERN ___sdcc_call_hl
	EXTERN ___sdcc_call_iy
	EXTERN ___sdcc_enter_ix
	EXTERN banked_call
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
	GLOBAL _ftoe
;--------------------------------------------------------
; Externals used
;--------------------------------------------------------
	GLOBAL _vscanf_unlocked_callee
	GLOBAL _vscanf_unlocked
	GLOBAL _vprintf_unlocked_callee
	GLOBAL _vprintf_unlocked
	GLOBAL _vfscanf_unlocked_callee
	GLOBAL _vfscanf_unlocked
	GLOBAL _vfprintf_unlocked_callee
	GLOBAL _vfprintf_unlocked
	GLOBAL _ungetc_unlocked_callee
	GLOBAL _ungetc_unlocked
	GLOBAL _scanf_unlocked
	GLOBAL _rewind_unlocked_fastcall
	GLOBAL _rewind_unlocked
	GLOBAL _puts_unlocked_fastcall
	GLOBAL _puts_unlocked
	GLOBAL _putchar_unlocked_fastcall
	GLOBAL _putchar_unlocked
	GLOBAL _putc_unlocked_callee
	GLOBAL _putc_unlocked
	GLOBAL _printf_unlocked
	GLOBAL _gets_unlocked_fastcall
	GLOBAL _gets_unlocked
	GLOBAL _getline_unlocked_callee
	GLOBAL _getline_unlocked
	GLOBAL _getdelim_unlocked_callee
	GLOBAL _getdelim_unlocked
	GLOBAL _getchar_unlocked
	GLOBAL _getc_unlocked_fastcall
	GLOBAL _getc_unlocked
	GLOBAL _fwrite_unlocked_callee
	GLOBAL _fwrite_unlocked
	GLOBAL _ftell_unlocked_fastcall
	GLOBAL _ftell_unlocked
	GLOBAL _fsetpos_unlocked_callee
	GLOBAL _fsetpos_unlocked
	GLOBAL _fseek_unlocked_callee
	GLOBAL _fseek_unlocked
	GLOBAL _fscanf_unlocked
	GLOBAL _freopen_unlocked_callee
	GLOBAL _freopen_unlocked
	GLOBAL _fread_unlocked_callee
	GLOBAL _fread_unlocked
	GLOBAL _fputs_unlocked_callee
	GLOBAL _fputs_unlocked
	GLOBAL _fputc_unlocked_callee
	GLOBAL _fputc_unlocked
	GLOBAL _fprintf_unlocked
	GLOBAL _fileno_unlocked_fastcall
	GLOBAL _fileno_unlocked
	GLOBAL _fgets_unlocked_callee
	GLOBAL _fgets_unlocked
	GLOBAL _fgetpos_unlocked_callee
	GLOBAL _fgetpos_unlocked
	GLOBAL _fgetc_unlocked_fastcall
	GLOBAL _fgetc_unlocked
	GLOBAL _fflush_unlocked_fastcall
	GLOBAL _fflush_unlocked
	GLOBAL _ferror_unlocked_fastcall
	GLOBAL _ferror_unlocked
	GLOBAL _feof_unlocked_fastcall
	GLOBAL _feof_unlocked
	GLOBAL _fclose_unlocked_fastcall
	GLOBAL _fclose_unlocked
	GLOBAL _clearerr_unlocked_fastcall
	GLOBAL _clearerr_unlocked
	GLOBAL _vsscanf_callee
	GLOBAL _vsscanf
	GLOBAL _vsprintf_callee
	GLOBAL _vsprintf
	GLOBAL _vsnprintf_callee
	GLOBAL _vsnprintf
	GLOBAL _vscanf_callee
	GLOBAL _vscanf
	GLOBAL _vprintf_callee
	GLOBAL _vprintf
	GLOBAL _vfscanf_callee
	GLOBAL _vfscanf
	GLOBAL _vfprintf_callee
	GLOBAL _vfprintf
	GLOBAL _vasprintf_callee
	GLOBAL _vasprintf
	GLOBAL _ungetc_callee
	GLOBAL _ungetc
	GLOBAL _sscanf
	GLOBAL _sprintf
	GLOBAL _snprintf
	GLOBAL _scanf
	GLOBAL _rewind_fastcall
	GLOBAL _rewind
	GLOBAL _puts_fastcall
	GLOBAL _puts
	GLOBAL _putchar_fastcall
	GLOBAL _putchar
	GLOBAL _putc_callee
	GLOBAL _putc
	GLOBAL _printf
	GLOBAL _perror_fastcall
	GLOBAL _perror
	GLOBAL _open_memstream_callee
	GLOBAL _open_memstream
	GLOBAL _obstack_vprintf_callee
	GLOBAL _obstack_vprintf
	GLOBAL _obstack_printf
	GLOBAL _gets_fastcall
	GLOBAL _gets
	GLOBAL _getline_callee
	GLOBAL _getline
	GLOBAL _getdelim_callee
	GLOBAL _getdelim
	GLOBAL _getchar
	GLOBAL _getc_fastcall
	GLOBAL _getc
	GLOBAL _fwrite_callee
	GLOBAL _fwrite
	GLOBAL _funlockfile_fastcall
	GLOBAL _funlockfile
	GLOBAL _ftrylockfile_fastcall
	GLOBAL _ftrylockfile
	GLOBAL _ftell_fastcall
	GLOBAL _ftell
	GLOBAL _fsetpos_callee
	GLOBAL _fsetpos
	GLOBAL _fseek_callee
	GLOBAL _fseek
	GLOBAL _fscanf
	GLOBAL _freopen_callee
	GLOBAL _freopen
	GLOBAL _fread_callee
	GLOBAL _fread
	GLOBAL _fputs_callee
	GLOBAL _fputs
	GLOBAL _fputc_callee
	GLOBAL _fputc
	GLOBAL _fprintf
	GLOBAL _fopen_callee
	GLOBAL _fopen
	GLOBAL _fmemopen_callee
	GLOBAL _fmemopen
	GLOBAL _flockfile_fastcall
	GLOBAL _flockfile
	GLOBAL _fileno_fastcall
	GLOBAL _fileno
	GLOBAL _fgets_callee
	GLOBAL _fgets
	GLOBAL _fgetpos_callee
	GLOBAL _fgetpos
	GLOBAL _fgetc_fastcall
	GLOBAL _fgetc
	GLOBAL _fflush_fastcall
	GLOBAL _fflush
	GLOBAL _ferror_fastcall
	GLOBAL _ferror
	GLOBAL _feof_fastcall
	GLOBAL _feof
	GLOBAL _fdopen_callee
	GLOBAL _fdopen
	GLOBAL _fclose_fastcall
	GLOBAL _fclose
	GLOBAL _clearerr_fastcall
	GLOBAL _clearerr
	GLOBAL _asprintf
	GLOBAL __fmemopen__callee
	GLOBAL __fmemopen_
	GLOBAL _poly_callee
	GLOBAL _poly
	GLOBAL _exp10_fastcall
	GLOBAL _exp10
	GLOBAL _mul10u_fastcall
	GLOBAL _mul10u
	GLOBAL _mul2_fastcall
	GLOBAL _mul2
	GLOBAL _div2_fastcall
	GLOBAL _div2
	GLOBAL _invsqrt_fastcall
	GLOBAL _invsqrt
	GLOBAL _inv_fastcall
	GLOBAL _inv
	GLOBAL _sqr_fastcall
	GLOBAL _sqr
	GLOBAL _neg_fastcall
	GLOBAL _neg
	GLOBAL _isunordered_callee
	GLOBAL _isunordered
	GLOBAL _islessgreater_callee
	GLOBAL _islessgreater
	GLOBAL _islessequal_callee
	GLOBAL _islessequal
	GLOBAL _isless_callee
	GLOBAL _isless
	GLOBAL _isgreaterequal_callee
	GLOBAL _isgreaterequal
	GLOBAL _isgreater_callee
	GLOBAL _isgreater
	GLOBAL _fma_callee
	GLOBAL _fma
	GLOBAL _fmin_callee
	GLOBAL _fmin
	GLOBAL _fmax_callee
	GLOBAL _fmax
	GLOBAL _fdim_callee
	GLOBAL _fdim
	GLOBAL _nexttoward_callee
	GLOBAL _nexttoward
	GLOBAL _nextafter_callee
	GLOBAL _nextafter
	GLOBAL _nan_fastcall
	GLOBAL _nan
	GLOBAL _copysign_callee
	GLOBAL _copysign
	GLOBAL _remquo_callee
	GLOBAL _remquo
	GLOBAL _remainder_callee
	GLOBAL _remainder
	GLOBAL _fmod_callee
	GLOBAL _fmod
	GLOBAL _modf_callee
	GLOBAL _modf
	GLOBAL _trunc_fastcall
	GLOBAL _trunc
	GLOBAL _lround_fastcall
	GLOBAL _lround
	GLOBAL _round_fastcall
	GLOBAL _round
	GLOBAL _lrint_fastcall
	GLOBAL _lrint
	GLOBAL _rint_fastcall
	GLOBAL _rint
	GLOBAL _nearbyint_fastcall
	GLOBAL _nearbyint
	GLOBAL _floor_fastcall
	GLOBAL _floor
	GLOBAL _ceil_fastcall
	GLOBAL _ceil
	GLOBAL _tgamma_fastcall
	GLOBAL _tgamma
	GLOBAL _lgamma_fastcall
	GLOBAL _lgamma
	GLOBAL _erfc_fastcall
	GLOBAL _erfc
	GLOBAL _erf_fastcall
	GLOBAL _erf
	GLOBAL _cbrt_fastcall
	GLOBAL _cbrt
	GLOBAL _sqrt_fastcall
	GLOBAL _sqrt
	GLOBAL _pow_callee
	GLOBAL _pow
	GLOBAL _hypot_callee
	GLOBAL _hypot
	GLOBAL _fabs_fastcall
	GLOBAL _fabs
	GLOBAL _logb_fastcall
	GLOBAL _logb
	GLOBAL _log2_fastcall
	GLOBAL _log2
	GLOBAL _log1p_fastcall
	GLOBAL _log1p
	GLOBAL _log10_fastcall
	GLOBAL _log10
	GLOBAL _log_fastcall
	GLOBAL _log
	GLOBAL _ilogb_fastcall
	GLOBAL _ilogb
	GLOBAL _scalbln_callee
	GLOBAL _scalbln
	GLOBAL _scalbn_callee
	GLOBAL _scalbn
	GLOBAL _ldexp_callee
	GLOBAL _ldexp
	GLOBAL _frexp_callee
	GLOBAL _frexp
	GLOBAL _expm1_fastcall
	GLOBAL _expm1
	GLOBAL _exp2_fastcall
	GLOBAL _exp2
	GLOBAL _exp_fastcall
	GLOBAL _exp
	GLOBAL _tanh_fastcall
	GLOBAL _tanh
	GLOBAL _sinh_fastcall
	GLOBAL _sinh
	GLOBAL _cosh_fastcall
	GLOBAL _cosh
	GLOBAL _atanh_fastcall
	GLOBAL _atanh
	GLOBAL _asinh_fastcall
	GLOBAL _asinh
	GLOBAL _acosh_fastcall
	GLOBAL _acosh
	GLOBAL _tan_fastcall
	GLOBAL _tan
	GLOBAL _sin_fastcall
	GLOBAL _sin
	GLOBAL _cos_fastcall
	GLOBAL _cos
	GLOBAL _atan2_callee
	GLOBAL _atan2
	GLOBAL _atan_fastcall
	GLOBAL _atan
	GLOBAL _asin_fastcall
	GLOBAL _asin
	GLOBAL _acos_fastcall
	GLOBAL _acos
	GLOBAL _stderr
	GLOBAL _stdout
	GLOBAL _stdin
	GLOBAL __MAX_FOPEN
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
; absolute ram data
;--------------------------------------------------------
	SECTION IGNORE
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	SECTION code_crt_init
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	SECTION code_home
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION code_compiler
;	---------------------------------
; Function pow10_int
; ---------------------------------
_pow10_int:
	push	ix
	ld	ix,	+0
	add	ix, sp
	push	af
	push	af
	ld	(ix-4),0x01
	xor	a, a
	ld	(ix-3),a
	ld	(ix-2),a
	ld	(ix-1),a
	ld	de,0x0000
	ld	hl,0x000a
l_pow10_int_00103:
	xor	a, a
	cp	a,(ix+4)
	sbc	a,(ix+5)
	jp	po, l_pow10_int_00132
	xor	a,0x80
l_pow10_int_00132:
	jp	p, l_pow10_int_00105
	bit	0,(ix+4)
	jr	z,l_pow10_int_00102
	push	hl
	push	de
	push	de
	push	hl
	ld	c,(ix-2)
	ld	b,(ix-1)
	push	bc
	ld	c,(ix-4)
	ld	b,(ix-3)
	push	bc
	call	__mullong_callee
	ld	(ix-4),l
	ld	(ix-3),h
	ld	(ix-2),e
	ld	(ix-1),d
	pop	de
	pop	hl
l_pow10_int_00102:
	push	de
	push	hl
	push	de
	push	hl
	call	__mullong_callee
	sra	(ix+5)
	rr	(ix+4)
	jr	l_pow10_int_00103
l_pow10_int_00105:
	pop	hl
	pop	de
	ld	sp,ix
	pop	ix
	ret
	SECTION rodata_compiler
_pow10f_tab:
	DEFB +0xee,0xe3, +0x6c, +0x00
	DEFB +0xea,0x1c, +0x08, +0x02
	DEFB +0x25,0x24, +0xaa, +0x03
	DEFB +0x2e,0xad, +0x54, +0x05
	DEFB +0x3d,0xec, +0x04, +0x07
	DEFB +0x4c,0x27, +0xa6, +0x08
	DEFB +0x1f,0xb1, +0x4f, +0x0a
	DEFB +0xb3,0xce, +0x01, +0x0c
	DEFB +0x60,0x42, +0xa2, +0x0d
	DEFB +0xf8,0xd2, +0x4a, +0x0f
	DEFB +0xb6,0x87, +0xfd, +0x10
	DEFB +0xd2,0x74, +0x9e, +0x12
	DEFB +0x06,0x12, +0x46, +0x14
	DEFB +0x88,0x96, +0xf7, +0x15
	DEFB +0x15,0xbe, +0x9a, +0x17
	DEFB +0x9a,0x6d, +0x41, +0x19
	DEFB +0x01,0xc9, +0xf1, +0x1a
	DEFB +0xa0,0x1d, +0x97, +0x1c
	DEFB +0x08,0xe5, +0x3c, +0x1e
	DEFB +0x4a,0x1e, +0xec, +0x1f
	DEFB +0xef,0x92, +0x93, +0x21
	DEFB +0xaa,0x77, +0x38, +0x23
	DEFB +0x95,0x95, +0xe6, +0x24
	DEFB +0x7d,0x1d, +0x90, +0x26
	DEFB +0xdc,0x24, +0x34, +0x28
	DEFB +0x13,0x2e, +0xe1, +0x29
	DEFB +0xcc,0xbc, +0x8c, +0x2b
	DEFB +0xff,0xeb, +0x2f, +0x2d
	DEFB +0xff,0xe6, +0xdb, +0x2e
	DEFB +0x5f,0x70, +0x89, +0x30
	DEFB +0x77,0xcc, +0x2b, +0x32
	DEFB +0x95,0xbf, +0xd6, +0x33
	DEFB +0xbd,0x37, +0x86, +0x35
	DEFB +0xac,0xc5, +0x27, +0x37
	DEFB +0x17,0xb7, +0xd1, +0x38
	DEFB +0x6f,0x12, +0x83, +0x3a
	DEFB +0x0a,0xd7, +0x23, +0x3c
	DEFB +0xcd,0xcc, +0xcc, +0x3d
	DEFB +0x00,0x00, +0x80, +0x3f
	DEFB +0x00,0x00, +0x20, +0x41
	DEFB +0x00,0x00, +0xc8, +0x42
	DEFB +0x00,0x00, +0x7a, +0x44
	DEFB +0x00,0x40, +0x1c, +0x46
	DEFB +0x00,0x50, +0xc3, +0x47
	DEFB +0x00,0x24, +0x74, +0x49
	DEFB +0x80,0x96, +0x18, +0x4b
	DEFB +0x20,0xbc, +0xbe, +0x4c
	DEFB +0x28,0x6b, +0x6e, +0x4e
	DEFB +0xf9,0x02, +0x15, +0x50
	DEFB +0xb7,0x43, +0xba, +0x51
	DEFB +0xa5,0xd4, +0x68, +0x53
	DEFB +0xe7,0x84, +0x11, +0x55
	DEFB +0x21,0xe6, +0xb5, +0x56
	DEFB +0xa9,0x5f, +0x63, +0x58
	DEFB +0xca,0x1b, +0x0e, +0x5a
	DEFB +0xbc,0xa2, +0xb1, +0x5b
	DEFB +0x6b,0x0b, +0x5e, +0x5d
	DEFB +0x23,0xc7, +0x0a, +0x5f
	DEFB +0xec,0x78, +0xad, +0x60
	DEFB +0x27,0xd7, +0x58, +0x62
	DEFB +0x78,0x86, +0x07, +0x64
	DEFB +0x16,0x68, +0xa9, +0x65
	DEFB +0x1c,0xc2, +0x53, +0x67
	DEFB +0x51,0x59, +0x04, +0x69
	DEFB +0xa6,0x6f, +0xa5, +0x6a
	DEFB +0x8f,0xcb, +0x4e, +0x6c
	DEFB +0x39,0x3f, +0x01, +0x6e
	DEFB +0x08,0x8f, +0xa1, +0x6f
	DEFB +0xca,0xf2, +0x49, +0x71
	DEFB +0x7c,0x6f, +0xfc, +0x72
	DEFB +0xae,0xc5, +0x9d, +0x74
	DEFB +0x19,0x37, +0x45, +0x76
	DEFB +0xdf,0x84, +0xf6, +0x77
	DEFB +0x0c,0x13, +0x9a, +0x79
	DEFB +0xce,0x97, +0x40, +0x7b
	DEFB +0xc2,0xbd, +0xf0, +0x7c
	DEFB +0x99,0x76, +0x96, +0x7e
	SECTION code_compiler
;	---------------------------------
; Function find_expon
; ---------------------------------
_find_expon:
	push	ix
	ld	ix,	+0
	add	ix, sp
	ld	hl, -6
	add	hl, sp
	ld	sp, hl
	ld	hl,0xffda
	ex	(sp), hl
	ld	(ix-4),0x26
	xor	a, a
	ld	(ix-3),a
	ld	(ix-2),0xda
	ld	(ix-1),0xff
l_find_expon_00104:
	ld	a,(ix-4)
	sub	a,(ix-6)
	ld	a,(ix-3)
	sbc	a,(ix-5)
	jp	po, l_find_expon_00133
	xor	a,0x80
l_find_expon_00133:
	jp	m, l_find_expon_00106
	ld	a,(ix-6)
	add	a,(ix-4)
	ld	c, a
	ld	a,(ix-5)
	adc	a,(ix-3)
	ld	b, a
	sra	b
	rr	c
	ld	hl,0x0026
	add	hl, bc
	add	hl, hl
	add	hl, hl
	ld	de,_pow10f_tab
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	push	bc
	ld	l, a
	push	hl
	push	de
	ld	l,(ix+6)
	ld	h,(ix+7)
	push	hl
	ld	l,(ix+4)
	ld	h,(ix+5)
	push	hl
	call	___fslt_callee
	pop	bc
	bit	0, l
	jr	nz,l_find_expon_00102
	ld	(ix-2),c
	ld	(ix-1),b
	inc	bc
	pop	de
	push	bc
	jr	l_find_expon_00104
l_find_expon_00102:
	ld	a, c
	add	a,0xff
	ld	(ix-4),a
	ld	a, b
	adc	a,0xff
	ld	(ix-3),a
	jr	l_find_expon_00104
l_find_expon_00106:
	ld	l,(ix-2)
	ld	h,(ix-1)
	ld	sp, ix
	pop	ix
	ret
;	---------------------------------
; Function ftoe
; ---------------------------------
_ftoe:
	push	ix
	ld	ix,	+0
	add	ix, sp
	ld	hl, -18
	add	hl, sp
	ld	sp, hl
	bit	7,(ix+9)
	jr	z,l_ftoe_00102
	ld	(ix+8),0x06
	xor	a, a
	ld	(ix+9),a
l_ftoe_00102:
	ld	a,0x07
	cp	a,(ix+8)
	ld	a,0x00
	sbc	a,(ix+9)
	jp	po, l_ftoe_00331
	xor	a,0x80
l_ftoe_00331:
	jp	p, l_ftoe_00104
	ld	(ix+8),0x07
	xor	a, a
	ld	(ix+9),a
l_ftoe_00104:
	ld	hl,4
	add	hl, sp
	ex	de, hl
	ld	hl,22
	add	hl, sp
	ld	bc,0x0004
	ldir
	ld	hl,4
	add	hl, sp
	ex	de, hl
	ld	hl,0
	add	hl, sp
	ex	de, hl
	ld	bc,0x0004
	ldir
	pop	bc
	push	bc
	ld	e,(ix-16)
	ld	a,(ix-15)
	and	a,0x7f
	ld	d, a
	ld	a,(ix+10)
	ld	(ix-6),a
	ld	l, a
	ld	a,(ix+11)
	ld	(ix-5),a
	ld	h,a
	inc	hl
	ld	(ix-4),l
	ld	(ix-3),h
	ld	a, c
	or	a, a
	or	a, b
	jr	nz,l_ftoe_00110
	ld	a, e
	sub	a,0x80
	jr	nz,l_ftoe_00110
	ld	a, d
	sub	a,0x7f
	jr	nz,l_ftoe_00110
	bit	7,(ix-15)
	jr	z,l_ftoe_00108
	ld	l,(ix-6)
	ld	h,(ix-5)
	ld	(hl),0x2d
	ld	a,(ix-4)
	ld	(ix+10),a
	ld	a,(ix-3)
	ld	(ix+11),a
l_ftoe_00108:
	ld	l,(ix+10)
	ld	h,(ix+11)
	ld	(hl),0x69
	inc	hl
	ld	(ix+10),l
	ld	(ix+11),h
	ld	(hl),0x6e
	inc	hl
	ld	(ix+10),l
	ld	(ix+11),h
	ld	(hl),0x66
	inc	hl
	ld	(ix+10),l
	ld	(ix+11),h
	ld	(hl),0x00
	jp	l_ftoe_00145
l_ftoe_00110:
	ld	a,(ix+7)
	and	a,0x7f
	or	a,(ix+6)
	or	a,(ix+5)
	or	a,(ix+4)
	jr	nz,l_ftoe_00113
	xor	a, a
	ld	(ix-2),a
	ld	(ix-1),a
	ld	l,(ix-6)
	ld	h,(ix-5)
	ld	(hl),0x30
	ld	a,(ix-4)
	ld	(ix+10),a
	ld	l, a
	ld	a,(ix-3)
	ld	(ix+11),a
	ld	h,a
	ld	(hl),0x2e
	inc	hl
	ld	(ix+10),l
	ld	(ix+11),h
	ld	bc,0x0000
l_ftoe_00137:
	ld	a, c
	sub	a,(ix+8)
	ld	a, b
	sbc	a,(ix+9)
	jp	po, l_ftoe_00335
	xor	a,0x80
l_ftoe_00335:
	jp	p, l_ftoe_00195
	ld	(hl),0x30
	inc	hl
	inc	bc
	jr	l_ftoe_00137
l_ftoe_00113:
	ld	hl,0x0000
	push	hl
	push	hl
	ld	l,(ix+6)
	ld	h,(ix+7)
	push	hl
	ld	l,(ix+4)
	ld	h,(ix+5)
	push	hl
	call	___fslt_callee
	ld	a, l
	or	a, a
	jr	z,l_ftoe_00115
	ld	l,(ix-6)
	ld	h,(ix-5)
	ld	(hl),0x2d
	ld	a,(ix-4)
	ld	(ix+10),a
	ld	a,(ix-3)
	ld	(ix+11),a
	ld	a,(ix+7)
	xor	a,0x80
	ld	(ix+7),a
l_ftoe_00115:
	ld	hl,8
	add	hl, sp
	ex	de, hl
	ld	hl,22
	add	hl, sp
	ld	bc,4
	ldir
	ld	a,(ix-7)
	and	a,0x7f
	or	a,(ix-8)
	or	a,(ix-9)
	or	a,(ix-10)
	jr	z,l_ftoe_00117
	bit	7,(ix-16)
	jr	nz,l_ftoe_00118
	ld	a,(ix-15)
	and	a,0x7f
	jr	nz,l_ftoe_00118
	ld	a,(ix-18)
	or	a,(ix-17)
	jr	nz,l_ftoe_00338
	ld	a,(ix-16)
	and	a,0x7f
	jr	z,l_ftoe_00118
l_ftoe_00338:
l_ftoe_00117:
	xor	a, a
	ld	(ix-2),a
	ld	(ix-1),a
	ld	l,(ix+10)
	ld	h,(ix+11)
	ld	(hl),0x30
	inc	hl
	ld	(ix+10),l
	ld	(ix+11),h
	ld	(hl),0x2e
	inc	hl
	ld	(ix+10),l
	ld	(ix+11),h
	ex	de,hl
	ld	bc,0x0000
l_ftoe_00140:
	ld	a, c
	sub	a,(ix+8)
	ld	a, b
	sbc	a,(ix+9)
	jp	po, l_ftoe_00339
	xor	a,0x80
l_ftoe_00339:
	jp	p, l_ftoe_00196
	ld	a,0x30
	ld	(de), a
	inc	de
	inc	bc
	jr	l_ftoe_00140
l_ftoe_00118:
	ld	l,(ix-8)
	ld	h,(ix-7)
	push	hl
	ld	l,(ix-10)
	ld	h,(ix-9)
	push	hl
	call	_find_expon
	pop	af
	pop	af
	ld	(ix-2),l
	ld	(ix-1),h
	ld	a,(ix+8)
	sub	a,(ix-2)
	ld	(ix-4),a
	ld	a,(ix+9)
	sbc	a,(ix-1)
	ld	(ix-3),a
	bit	7,a
	jp	nz, l_ftoe_00125
	ld	c,(ix-4)
	ld	b,(ix-3)
	ld	a,0x26
	cp	a, c
	ld	a,0x00
	sbc	a, b
	ld	a,0x00
	rla
	ld	(ix-5),a
	or	a, a
	jr	z,l_ftoe_00147
	ld	a, c
	add	a,0xda
	ld	e, a
	ld	a, b
	adc	a,0xff
	jr	l_ftoe_00148
l_ftoe_00147:
	xor	a,a
	ld	e,a
l_ftoe_00148:
	ld	(ix-4),e
	ld	(ix-3),a
	ld	de,_pow10f_tab+0
	ld	a,(ix-5)
	or	a, a
	jr	z,l_ftoe_00149
	ld	bc,0x0026
l_ftoe_00149:
	ld	hl,0x0026
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	push	bc
	ld	l,(ix-8)
	ld	h,(ix-7)
	push	hl
	ld	l,(ix-10)
	ld	h,(ix-9)
	push	hl
	call	___fsmul_callee
	ld	c,(ix-4)
	ld	b,(ix-3)
l_ftoe_00121:
	ld	(ix-4),c
	ld	(ix-3),b
	dec	bc
	ld	a,(ix-3)
	or	a,(ix-4)
	jp	z, l_ftoe_00126
	push	bc
	push	de
	push	hl
	ld	hl,0x4120
	push	hl
	ld	hl,0x0000
	push	hl
	call	___fsmul_callee
	pop	bc
	jr	l_ftoe_00121
l_ftoe_00125:
	ld	a,(ix-2)
	sub	a,(ix+8)
	ld	c, a
	ld	a,(ix-1)
	sbc	a,(ix+9)
	ld	b, a
	ld	hl,0x0026
	add	hl, bc
	ld	(ix-4),l
	ld	(ix-3),h
	ld	(ix-6),l
	ld	(ix-5),h
	ld	b,0x02
l_ftoe_00340:
	sla	(ix-6)
	rl	(ix-5)
	djnz	l_ftoe_00340
	ld	de,_pow10f_tab
	ld	l,(ix-6)
	ld	h,(ix-5)
	add	hl, de
	ld	(ix-4),l
	ld	(ix-3),h
	ex	de,hl
	ld	hl,12
	add	hl, sp
	ex	de, hl
	ld	bc,0x0004
	ldir
	ld	l,(ix-4)
	ld	h,(ix-3)
	push	hl
	ld	l,(ix-6)
	ld	h,(ix-5)
	push	hl
	ld	l,(ix-8)
	ld	h,(ix-7)
	push	hl
	ld	l,(ix-10)
	ld	h,(ix-9)
	push	hl
	call	___fsdiv_callee
l_ftoe_00126:
	ld	bc,0x3f00
	push	bc
	ld	bc,0x0000
	push	bc
	push	de
	push	hl
	call	___fsadd_callee
	push	de
	push	hl
	call	___fs2ulong_callee
	ld	(ix-6),l
	ld	(ix-5),h
	ld	(ix-4),e
	ld	(ix-3),d
	ld	c,(ix+8)
	ld	b,(ix+9)
	inc	bc
	push	bc
	call	_pow10_int
	pop	af
	ld	a,(ix-6)
	sub	a, l
	ld	a,(ix-5)
	sbc	a, h
	ld	a,(ix-4)
	sbc	a, e
	ld	a,(ix-3)
	sbc	a, d
	jr	c,l_ftoe_00128
	ld	hl,0x0000
	push	hl
	ld	l,0x0a
	push	hl
	ld	l,(ix-4)
	ld	h,(ix-3)
	push	hl
	ld	l,(ix-6)
	ld	h,(ix-5)
	push	hl
	call	__divulong_callee
	ld	(ix-6),l
	ld	(ix-5),h
	ld	(ix-4),e
	ld	(ix-3),d
	inc	(ix-2)
	jr	nz,l_ftoe_00341
	inc	(ix-1)
l_ftoe_00341:
l_ftoe_00128:
	ld	c,(ix+8)
	ld	b,(ix+9)
l_ftoe_00143:
	bit	7, b
	jp	nz, l_ftoe_00132
	push	bc
	push	bc
	call	_pow10_int
	pop	af
	ld	(ix-10),l
	ld	(ix-9),h
	ld	(ix-8),e
	ld	(ix-7),d
	push	de
	push	hl
	ld	l,(ix-4)
	ld	h,(ix-3)
	push	hl
	ld	l,(ix-6)
	ld	h,(ix-5)
	push	hl
	call	__divulong_callee
	pop	bc
	ld	e,(ix+10)
	ld	d,(ix+11)
	ld	a, l
	add	a,0x30
	ld	(de), a
	inc	de
	ld	(ix+10),e
	ld	(ix+11),d
	ld	a, h
	rlca
	sbc	a, a
	ld	d, a
	push	bc
	push	hl
	ld	l,(ix-8)
	ld	h,(ix-7)
	ex	(sp), hl
	push	hl
	ld	l,(ix-10)
	ld	h,(ix-9)
	ex	(sp), hl
	ld	e, a
	push	de
	push	hl
	call	__mullong_callee
	pop	bc
	ld	a,(ix-6)
	sub	a, l
	ld	(ix-6),a
	ld	a,(ix-5)
	sbc	a, h
	ld	(ix-5),a
	ld	a,(ix-4)
	sbc	a, e
	ld	(ix-4),a
	ld	a,(ix-3)
	sbc	a, d
	ld	(ix-3),a
	ld	l,(ix+8)
	ld	h,(ix+9)
	xor	a, a
	sbc	hl, bc
	jr	nz,l_ftoe_00144
	ld	l,(ix+10)
	ld	h,(ix+11)
	ld	(hl),0x2e
	inc	hl
	ld	(ix+10),l
	ld	(ix+11),h
l_ftoe_00144:
	dec	bc
	jp	l_ftoe_00143
l_ftoe_00195:
	ld	(ix+10),l
	ld	(ix+11),h
	jr	l_ftoe_00132
l_ftoe_00196:
	ld	(ix+10),e
	ld	(ix+11),d
l_ftoe_00132:
	ld	l,(ix+10)
	ld	h,(ix+11)
	ld	(hl),0x65
	inc	hl
	ld	(ix+10),l
	ld	(ix+11),h
	ld	c, l
	ld	b, h
	inc	bc
	bit	7,(ix-1)
	jr	z,l_ftoe_00134
	ld	(hl),0x2d
	ld	(ix+10),c
	ld	(ix+11),b
	xor	a, a
	sub	a,(ix-2)
	ld	(ix-2),a
	sbc	a, a
	sub	a,(ix-1)
	ld	(ix-1),a
	jr	l_ftoe_00135
l_ftoe_00134:
	ld	(hl),0x2b
	ld	(ix+10),c
	ld	(ix+11),b
l_ftoe_00135:
	ld	c,(ix+10)
	ld	b,(ix+11)
	push	bc
	ld	hl,0x000a
	push	hl
	ld	l,(ix-2)
	ld	h,(ix-1)
	push	hl
	call	__divsint_callee
	pop	bc
	ld	a, l
	add	a,0x30
	ld	(bc), a
	inc	bc
	ld	(ix+10),c
	ld	(ix+11),b
	push	bc
	ld	hl,0x000a
	push	hl
	ld	l,(ix-2)
	ld	h,(ix-1)
	push	hl
	call	__modsint_callee
	pop	bc
	ld	a, l
	add	a,0x30
	ld	(bc), a
	inc	bc
	ld	(ix+10),c
	ld	l, c
	ld	(ix+11),b
	ld	h,b
	ld	(hl),0x00
l_ftoe_00145:
	ld	sp, ix
	pop	ix
	ret
	SECTION IGNORE
