;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.9 #9958 (Mac OS X i386)
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
	GLOBAL _main
	GLOBAL _suite_lshift
	GLOBAL _test_lshift32_const
	GLOBAL _test_lshift16_const
	GLOBAL _test_lshift32_var
	GLOBAL _test_lshift16_var
;--------------------------------------------------------
; Externals used
;--------------------------------------------------------
	GLOBAL _unbcd
	GLOBAL _wcmatch
	GLOBAL _extract_bits_callee
	GLOBAL _extract_bits
	GLOBAL _msleep
	GLOBAL _sleep
	GLOBAL _t_delay
	GLOBAL _wpeek
	GLOBAL _bpeek
	GLOBAL _wpoke_callee
	GLOBAL _wpoke
	GLOBAL _bpoke_callee
	GLOBAL _bpoke
	GLOBAL _swapendian
	GLOBAL _outp_callee
	GLOBAL _outp
	GLOBAL _inp
	GLOBAL _isqrt
	GLOBAL _labs
	GLOBAL _abs
	GLOBAL __ldivu__callee
	GLOBAL __ldivu_
	GLOBAL __ldiv__callee
	GLOBAL __ldiv_
	GLOBAL __divu__callee
	GLOBAL __divu_
	GLOBAL __div__callee
	GLOBAL __div_
	GLOBAL _qsort_sdcc_callee
	GLOBAL _qsort_sdcc
	GLOBAL _qsort_sccz80_callee
	GLOBAL _qsort_sccz80
	GLOBAL _l_qsort_callee
	GLOBAL _l_qsort
	GLOBAL _l_bsearch_callee
	GLOBAL _l_bsearch
	GLOBAL _getopt
	GLOBAL _atexit
	GLOBAL _exit
	GLOBAL _HeapInfo_callee
	GLOBAL _HeapInfo
	GLOBAL _HeapRealloc_callee
	GLOBAL _HeapRealloc
	GLOBAL _HeapAlloc_callee
	GLOBAL _HeapAlloc
	GLOBAL _HeapFree_callee
	GLOBAL _HeapFree
	GLOBAL _HeapCalloc_callee
	GLOBAL _HeapCalloc
	GLOBAL _HeapSbrk_callee
	GLOBAL _HeapSbrk
	GLOBAL _HeapCreate
	GLOBAL _mallinfo_callee
	GLOBAL _mallinfo
	GLOBAL _realloc_callee
	GLOBAL _realloc
	GLOBAL _malloc
	GLOBAL _free
	GLOBAL _calloc_callee
	GLOBAL _calloc
	GLOBAL _sbrk_callee
	GLOBAL _sbrk
	GLOBAL _mallinit
	GLOBAL _srand
	GLOBAL _rand
	GLOBAL _ulltoa_callee
	GLOBAL _ulltoa
	GLOBAL _strtoull_callee
	GLOBAL _strtoull
	GLOBAL _strtoll_callee
	GLOBAL _strtoll
	GLOBAL _lltoa_callee
	GLOBAL _lltoa
	GLOBAL _atoll_callee
	GLOBAL _atoll
	GLOBAL _utoa_callee
	GLOBAL _utoa
	GLOBAL _ultoa_callee
	GLOBAL _ultoa
	GLOBAL _strtoul_callee
	GLOBAL _strtoul
	GLOBAL _strtol_callee
	GLOBAL _strtol
	GLOBAL _ltoa_callee
	GLOBAL _ltoa
	GLOBAL _itoa_callee
	GLOBAL _itoa
	GLOBAL _atol
	GLOBAL _atoi
	GLOBAL _printk
	GLOBAL _puts_cons
	GLOBAL _getk
	GLOBAL _remove
	GLOBAL _rename
	GLOBAL _fdgetpos
	GLOBAL _fdtell
	GLOBAL _fabandon
	GLOBAL _fgets_cons
	GLOBAL _fputc_cons
	GLOBAL _fgetc_cons
	GLOBAL _fchkstd
	GLOBAL _getarg
	GLOBAL _vsscanf
	GLOBAL _vfscanf
	GLOBAL _sscanf
	GLOBAL _fscanf
	GLOBAL _scanf
	GLOBAL _printn
	GLOBAL _vsnprintf
	GLOBAL _vfprintf
	GLOBAL _snprintf
	GLOBAL _sprintf
	GLOBAL _fprintf
	GLOBAL _printf
	GLOBAL _gets
	GLOBAL _fwrite
	GLOBAL _fread
	GLOBAL _fseek
	GLOBAL _fgetpos
	GLOBAL _ftell
	GLOBAL _puts
	GLOBAL _feof
	GLOBAL _ungetc
	GLOBAL _fgetc
	GLOBAL _fputc_callee
	GLOBAL _fputs_callee
	GLOBAL _fputc
	GLOBAL _fputs
	GLOBAL _fgets
	GLOBAL _closeall
	GLOBAL _fflush
	GLOBAL _fclose
	GLOBAL _funopen
	GLOBAL _fmemopen
	GLOBAL __freopen1
	GLOBAL _fdopen
	GLOBAL _freopen
	GLOBAL _fopen
	GLOBAL _fopen_zsock
	GLOBAL _rnd_erase
	GLOBAL _rnd_saveblock
	GLOBAL _rnd_loadblock
	GLOBAL _getwd
	GLOBAL _rmdir
	GLOBAL _getcwd
	GLOBAL _writebyte
	GLOBAL _readbyte
	GLOBAL _lseek
	GLOBAL _write
	GLOBAL _read
	GLOBAL _close
	GLOBAL _creat
	GLOBAL _open
	GLOBAL _suite_add_test_real
	GLOBAL _suite_add_fixture
	GLOBAL _suite_setup
	GLOBAL _suite_run
	GLOBAL _Assert_real
	GLOBAL _optreset
	GLOBAL _optopt
	GLOBAL _optind
	GLOBAL _opterr
	GLOBAL _optarg
	GLOBAL __sgoioblk_end
	GLOBAL __sgoioblk
	GLOBAL __FOPEN_MAX
	GLOBAL _RND_BLOCKSIZE
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
; Function test_lshift16_var
; ---------------------------------
_test_lshift16_var:
	ld	hl,___str_1
	push	hl
	ld	hl,0x000b
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_2
	push	hl
	ld	hl,0x000d
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_3
	push	hl
	ld	hl,0x000f
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_4
	push	hl
	ld	hl,0x0011
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_5
	push	hl
	ld	hl,0x0013
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_6
	push	hl
	ld	hl,0x0015
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_7
	push	hl
	ld	hl,0x0017
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_8
	push	hl
	ld	hl,0x0019
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_9
	push	hl
	ld	hl,0x001b
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_10
	push	hl
	ld	hl,0x001d
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_11
	push	hl
	ld	hl,0x001f
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_12
	push	hl
	ld	hl,0x0021
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_13
	push	hl
	ld	hl,0x0023
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_14
	push	hl
	ld	hl,0x0025
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_15
	push	hl
	ld	hl,0x0027
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_16
	push	hl
	ld	hl,0x0029
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_17
	push	hl
	ld	hl,0x002b
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_18
	push	hl
	ld	hl,0x002d
	push	hl
	ld	hl,___str_0
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
l_test_lshift16_var_00101:
	ret
	SECTION rodata_compiler
___str_0:
	DEFM "lshift.c"
	DEFB 0x00
	SECTION rodata_compiler
___str_1:
	DEFM "<<0"
	DEFB 0x00
	SECTION rodata_compiler
___str_2:
	DEFM "<<1"
	DEFB 0x00
	SECTION rodata_compiler
___str_3:
	DEFM "<<2"
	DEFB 0x00
	SECTION rodata_compiler
___str_4:
	DEFM "<<3"
	DEFB 0x00
	SECTION rodata_compiler
___str_5:
	DEFM "<<4"
	DEFB 0x00
	SECTION rodata_compiler
___str_6:
	DEFM "<<5"
	DEFB 0x00
	SECTION rodata_compiler
___str_7:
	DEFM "<<6"
	DEFB 0x00
	SECTION rodata_compiler
___str_8:
	DEFM "<<7"
	DEFB 0x00
	SECTION rodata_compiler
___str_9:
	DEFM "<<8"
	DEFB 0x00
	SECTION rodata_compiler
___str_10:
	DEFM "<<9"
	DEFB 0x00
	SECTION rodata_compiler
___str_11:
	DEFM "<<10"
	DEFB 0x00
	SECTION rodata_compiler
___str_12:
	DEFM "<<11"
	DEFB 0x00
	SECTION rodata_compiler
___str_13:
	DEFM "<<12"
	DEFB 0x00
	SECTION rodata_compiler
___str_14:
	DEFM "<<13"
	DEFB 0x00
	SECTION rodata_compiler
___str_15:
	DEFM "<<14"
	DEFB 0x00
	SECTION rodata_compiler
___str_16:
	DEFM "<<15"
	DEFB 0x00
	SECTION rodata_compiler
___str_17:
	DEFM "<<16"
	DEFB 0x00
	SECTION rodata_compiler
___str_18:
	DEFM "<<17"
	DEFB 0x00
	SECTION code_compiler
;	---------------------------------
; Function test_lshift32_var
; ---------------------------------
_test_lshift32_var:
	ld	e,0x00
	ld	l,0x01
	ld	h,0x00
	ld	c,0x00
	ld	b,0x00
	inc	e
	jp	l_test_lshift32_var_00104
l_test_lshift32_var_00103:
	add	hl, hl
	rl	c
	rl	b
l_test_lshift32_var_00104:
	dec	e
	jr	NZ,l_test_lshift32_var_00103
	ld	a, l
	dec	a
	or	a, h
	or	a, c
	or	a, b
	jp	NZ,l_test_lshift32_var_00105
	ld	a,0x01
	jp	l_test_lshift32_var_00106
l_test_lshift32_var_00105:
	xor	a,a
l_test_lshift32_var_00106:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_20
	push	hl
	ld	hl,0x0036
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	e,0x01
	ld	l,0x01
	ld	h,0x00
	ld	c,0x00
	ld	b,0x00
	inc	e
	jp	l_test_lshift32_var_00108
l_test_lshift32_var_00107:
	add	hl, hl
	rl	c
	rl	b
l_test_lshift32_var_00108:
	dec	e
	jr	NZ,l_test_lshift32_var_00107
	ld	a, l
	sub	a,0x02
	or	a, h
	or	a, c
	or	a, b
	jp	NZ,l_test_lshift32_var_00109
	ld	a,0x01
	jp	l_test_lshift32_var_00110
l_test_lshift32_var_00109:
	xor	a,a
l_test_lshift32_var_00110:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_21
	push	hl
	ld	hl,0x0038
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x02
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00112
l_test_lshift32_var_00111:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00112:
	djnz	l_test_lshift32_var_00111
	ld	a, l
	sub	a,0x04
	or	a, h
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00113
	ld	a,0x01
	jp	l_test_lshift32_var_00114
l_test_lshift32_var_00113:
	xor	a,a
l_test_lshift32_var_00114:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_22
	push	hl
	ld	hl,0x003a
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x03
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00116
l_test_lshift32_var_00115:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00116:
	djnz	l_test_lshift32_var_00115
	ld	a, l
	sub	a,0x08
	or	a, h
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00117
	ld	a,0x01
	jp	l_test_lshift32_var_00118
l_test_lshift32_var_00117:
	xor	a,a
l_test_lshift32_var_00118:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_23
	push	hl
	ld	hl,0x003c
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x04
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00120
l_test_lshift32_var_00119:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00120:
	djnz	l_test_lshift32_var_00119
	ld	a, l
	sub	a,0x10
	or	a, h
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00121
	ld	a,0x01
	jp	l_test_lshift32_var_00122
l_test_lshift32_var_00121:
	xor	a,a
l_test_lshift32_var_00122:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_24
	push	hl
	ld	hl,0x003e
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x05
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00124
l_test_lshift32_var_00123:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00124:
	djnz	l_test_lshift32_var_00123
	ld	a, l
	sub	a,0x20
	or	a, h
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00125
	ld	a,0x01
	jp	l_test_lshift32_var_00126
l_test_lshift32_var_00125:
	xor	a,a
l_test_lshift32_var_00126:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_25
	push	hl
	ld	hl,0x0040
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x06
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00128
l_test_lshift32_var_00127:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00128:
	djnz	l_test_lshift32_var_00127
	ld	a, l
	sub	a,0x40
	or	a, h
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00129
	ld	a,0x01
	jp	l_test_lshift32_var_00130
l_test_lshift32_var_00129:
	xor	a,a
l_test_lshift32_var_00130:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_26
	push	hl
	ld	hl,0x0042
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x07
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00132
l_test_lshift32_var_00131:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00132:
	djnz	l_test_lshift32_var_00131
	ld	a, l
	sub	a,0x80
	or	a, h
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00133
	ld	a,0x01
	jp	l_test_lshift32_var_00134
l_test_lshift32_var_00133:
	xor	a,a
l_test_lshift32_var_00134:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_27
	push	hl
	ld	hl,0x0044
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x08
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00136
l_test_lshift32_var_00135:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00136:
	djnz	l_test_lshift32_var_00135
	ld	a, l
	or	a, a
	jp	NZ,l_test_lshift32_var_00137
	ld	a, h
	dec	a
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00137
	ld	a,0x01
	jp	l_test_lshift32_var_00138
l_test_lshift32_var_00137:
	xor	a,a
l_test_lshift32_var_00138:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_28
	push	hl
	ld	hl,0x0046
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x09
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00140
l_test_lshift32_var_00139:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00140:
	djnz	l_test_lshift32_var_00139
	ld	a, l
	or	a, a
	jp	NZ,l_test_lshift32_var_00141
	ld	a, h
	sub	a,0x02
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00141
	ld	a,0x01
	jp	l_test_lshift32_var_00142
l_test_lshift32_var_00141:
	xor	a,a
l_test_lshift32_var_00142:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_29
	push	hl
	ld	hl,0x0048
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x0a
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00144
l_test_lshift32_var_00143:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00144:
	djnz	l_test_lshift32_var_00143
	ld	a, l
	or	a, a
	jp	NZ,l_test_lshift32_var_00145
	ld	a, h
	sub	a,0x04
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00145
	ld	a,0x01
	jp	l_test_lshift32_var_00146
l_test_lshift32_var_00145:
	xor	a,a
l_test_lshift32_var_00146:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_30
	push	hl
	ld	hl,0x004a
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x0b
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00148
l_test_lshift32_var_00147:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00148:
	djnz	l_test_lshift32_var_00147
	ld	a, l
	or	a, a
	jp	NZ,l_test_lshift32_var_00149
	ld	a, h
	sub	a,0x08
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00149
	ld	a,0x01
	jp	l_test_lshift32_var_00150
l_test_lshift32_var_00149:
	xor	a,a
l_test_lshift32_var_00150:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_31
	push	hl
	ld	hl,0x004c
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x0c
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00152
l_test_lshift32_var_00151:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00152:
	djnz	l_test_lshift32_var_00151
	ld	a, l
	or	a, a
	jp	NZ,l_test_lshift32_var_00153
	ld	a, h
	sub	a,0x10
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00153
	ld	a,0x01
	jp	l_test_lshift32_var_00154
l_test_lshift32_var_00153:
	xor	a,a
l_test_lshift32_var_00154:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_32
	push	hl
	ld	hl,0x004e
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x0d
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00156
l_test_lshift32_var_00155:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00156:
	djnz	l_test_lshift32_var_00155
	ld	a, l
	or	a, a
	jp	NZ,l_test_lshift32_var_00157
	ld	a, h
	sub	a,0x20
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00157
	ld	a,0x01
	jp	l_test_lshift32_var_00158
l_test_lshift32_var_00157:
	xor	a,a
l_test_lshift32_var_00158:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_33
	push	hl
	ld	hl,0x0050
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x0e
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00160
l_test_lshift32_var_00159:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00160:
	djnz	l_test_lshift32_var_00159
	ld	a, l
	or	a, a
	jp	NZ,l_test_lshift32_var_00161
	ld	a, h
	sub	a,0x40
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00161
	ld	a,0x01
	jp	l_test_lshift32_var_00162
l_test_lshift32_var_00161:
	xor	a,a
l_test_lshift32_var_00162:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_34
	push	hl
	ld	hl,0x0052
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x0f
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00164
l_test_lshift32_var_00163:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00164:
	djnz	l_test_lshift32_var_00163
	ld	a, l
	or	a, a
	jp	NZ,l_test_lshift32_var_00165
	ld	a, h
	sub	a,0x80
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00165
	ld	a,0x01
	jp	l_test_lshift32_var_00166
l_test_lshift32_var_00165:
	xor	a,a
l_test_lshift32_var_00166:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_35
	push	hl
	ld	hl,0x0054
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x10
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00168
l_test_lshift32_var_00167:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00168:
	djnz	l_test_lshift32_var_00167
	ld	a, l
	or	a, a
	or	a, h
	jp	NZ,l_test_lshift32_var_00169
	ld	a, e
	dec	a
	or	a, d
	jp	NZ,l_test_lshift32_var_00169
	ld	a,0x01
	jp	l_test_lshift32_var_00170
l_test_lshift32_var_00169:
	xor	a,a
l_test_lshift32_var_00170:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_36
	push	hl
	ld	hl,0x0056
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x11
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00172
l_test_lshift32_var_00171:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00172:
	djnz	l_test_lshift32_var_00171
	ld	a, l
	or	a, a
	or	a, h
	jp	NZ,l_test_lshift32_var_00173
	ld	a, e
	sub	a,0x02
	or	a, d
	jp	NZ,l_test_lshift32_var_00173
	ld	a,0x01
	jp	l_test_lshift32_var_00174
l_test_lshift32_var_00173:
	xor	a,a
l_test_lshift32_var_00174:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_37
	push	hl
	ld	hl,0x0058
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x12
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00176
l_test_lshift32_var_00175:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00176:
	djnz	l_test_lshift32_var_00175
	ld	a, l
	or	a, a
	or	a, h
	jp	NZ,l_test_lshift32_var_00177
	ld	a, e
	sub	a,0x04
	or	a, d
	jp	NZ,l_test_lshift32_var_00177
	ld	a,0x01
	jp	l_test_lshift32_var_00178
l_test_lshift32_var_00177:
	xor	a,a
l_test_lshift32_var_00178:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_38
	push	hl
	ld	hl,0x005a
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x13
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00180
l_test_lshift32_var_00179:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00180:
	djnz	l_test_lshift32_var_00179
	ld	a, l
	or	a, a
	or	a, h
	jp	NZ,l_test_lshift32_var_00181
	ld	a, e
	sub	a,0x08
	or	a, d
	jp	NZ,l_test_lshift32_var_00181
	ld	a,0x01
	jp	l_test_lshift32_var_00182
l_test_lshift32_var_00181:
	xor	a,a
l_test_lshift32_var_00182:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_39
	push	hl
	ld	hl,0x005c
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x14
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00184
l_test_lshift32_var_00183:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00184:
	djnz	l_test_lshift32_var_00183
	ld	a, l
	or	a, a
	or	a, h
	jp	NZ,l_test_lshift32_var_00185
	ld	a, e
	sub	a,0x10
	or	a, d
	jp	NZ,l_test_lshift32_var_00185
	ld	a,0x01
	jp	l_test_lshift32_var_00186
l_test_lshift32_var_00185:
	xor	a,a
l_test_lshift32_var_00186:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_40
	push	hl
	ld	hl,0x005e
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x15
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00188
l_test_lshift32_var_00187:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00188:
	djnz	l_test_lshift32_var_00187
	ld	a, l
	or	a, a
	or	a, h
	jp	NZ,l_test_lshift32_var_00189
	ld	a, e
	sub	a,0x20
	or	a, d
	jp	NZ,l_test_lshift32_var_00189
	ld	a,0x01
	jp	l_test_lshift32_var_00190
l_test_lshift32_var_00189:
	xor	a,a
l_test_lshift32_var_00190:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_41
	push	hl
	ld	hl,0x0060
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x16
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00192
l_test_lshift32_var_00191:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00192:
	djnz	l_test_lshift32_var_00191
	ld	a, l
	or	a, a
	or	a, h
	jp	NZ,l_test_lshift32_var_00193
	ld	a, e
	sub	a,0x40
	or	a, d
	jp	NZ,l_test_lshift32_var_00193
	ld	a,0x01
	jp	l_test_lshift32_var_00194
l_test_lshift32_var_00193:
	xor	a,a
l_test_lshift32_var_00194:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_42
	push	hl
	ld	hl,0x0062
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x17
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00196
l_test_lshift32_var_00195:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00196:
	djnz	l_test_lshift32_var_00195
	ld	a, l
	or	a, a
	or	a, h
	jp	NZ,l_test_lshift32_var_00197
	ld	a, e
	sub	a,0x80
	or	a, d
	jp	NZ,l_test_lshift32_var_00197
	ld	a,0x01
	jp	l_test_lshift32_var_00198
l_test_lshift32_var_00197:
	xor	a,a
l_test_lshift32_var_00198:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_43
	push	hl
	ld	hl,0x0064
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x18
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00200
l_test_lshift32_var_00199:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00200:
	djnz	l_test_lshift32_var_00199
	ld	a, l
	or	a, a
	or	a, h
	or	a, e
	jp	NZ,l_test_lshift32_var_00201
	dec	d
	jp	NZ,l_test_lshift32_var_00201
	ld	a,0x01
	jp	l_test_lshift32_var_00202
l_test_lshift32_var_00201:
	xor	a,a
l_test_lshift32_var_00202:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_44
	push	hl
	ld	hl,0x0066
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x19
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00204
l_test_lshift32_var_00203:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00204:
	djnz	l_test_lshift32_var_00203
	ld	a, l
	or	a, a
	or	a, h
	or	a, e
	jp	NZ,l_test_lshift32_var_00205
	ld	a, d
	sub	a,0x02
	jp	NZ,l_test_lshift32_var_00205
	ld	a,0x01
	jp	l_test_lshift32_var_00206
l_test_lshift32_var_00205:
	xor	a,a
l_test_lshift32_var_00206:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_45
	push	hl
	ld	hl,0x0068
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x1a
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00208
l_test_lshift32_var_00207:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00208:
	djnz	l_test_lshift32_var_00207
	ld	a, l
	or	a, a
	or	a, h
	or	a, e
	jp	NZ,l_test_lshift32_var_00209
	ld	a, d
	sub	a,0x04
	jp	NZ,l_test_lshift32_var_00209
	ld	a,0x01
	jp	l_test_lshift32_var_00210
l_test_lshift32_var_00209:
	xor	a,a
l_test_lshift32_var_00210:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_46
	push	hl
	ld	hl,0x006a
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x1b
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00212
l_test_lshift32_var_00211:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00212:
	djnz	l_test_lshift32_var_00211
	ld	a, l
	or	a, a
	or	a, h
	or	a, e
	jp	NZ,l_test_lshift32_var_00213
	ld	a, d
	sub	a,0x08
	jp	NZ,l_test_lshift32_var_00213
	ld	a,0x01
	jp	l_test_lshift32_var_00214
l_test_lshift32_var_00213:
	xor	a,a
l_test_lshift32_var_00214:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_47
	push	hl
	ld	hl,0x006c
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x1c
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00216
l_test_lshift32_var_00215:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00216:
	djnz	l_test_lshift32_var_00215
	ld	a, l
	or	a, a
	or	a, h
	or	a, e
	jp	NZ,l_test_lshift32_var_00217
	ld	a, d
	sub	a,0x10
	jp	NZ,l_test_lshift32_var_00217
	ld	a,0x01
	jp	l_test_lshift32_var_00218
l_test_lshift32_var_00217:
	xor	a,a
l_test_lshift32_var_00218:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_48
	push	hl
	ld	hl,0x006e
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x1d
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00220
l_test_lshift32_var_00219:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00220:
	djnz	l_test_lshift32_var_00219
	ld	a, l
	or	a, a
	or	a, h
	or	a, e
	jp	NZ,l_test_lshift32_var_00221
	ld	a, d
	sub	a,0x20
	jp	NZ,l_test_lshift32_var_00221
	ld	a,0x01
	jp	l_test_lshift32_var_00222
l_test_lshift32_var_00221:
	xor	a,a
l_test_lshift32_var_00222:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_49
	push	hl
	ld	hl,0x0070
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x1e
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00224
l_test_lshift32_var_00223:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00224:
	djnz	l_test_lshift32_var_00223
	ld	a, l
	or	a, a
	or	a, h
	or	a, e
	jp	NZ,l_test_lshift32_var_00225
	ld	a, d
	sub	a,0x40
	jp	NZ,l_test_lshift32_var_00225
	ld	a,0x01
	jp	l_test_lshift32_var_00226
l_test_lshift32_var_00225:
	xor	a,a
l_test_lshift32_var_00226:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_50
	push	hl
	ld	hl,0x0072
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x1f
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00228
l_test_lshift32_var_00227:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00228:
	djnz	l_test_lshift32_var_00227
	ld	a, l
	or	a, a
	or	a, h
	or	a, e
	jp	NZ,l_test_lshift32_var_00229
	ld	a, d
	sub	a,0x80
	jp	NZ,l_test_lshift32_var_00229
	ld	a,0x01
	jp	l_test_lshift32_var_00230
l_test_lshift32_var_00229:
	xor	a,a
l_test_lshift32_var_00230:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_51
	push	hl
	ld	hl,0x0074
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x20
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00232
l_test_lshift32_var_00231:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00232:
	djnz	l_test_lshift32_var_00231
	ld	a, l
	dec	a
	or	a, h
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00233
	ld	a,0x01
	jp	l_test_lshift32_var_00234
l_test_lshift32_var_00233:
	xor	a,a
l_test_lshift32_var_00234:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_52
	push	hl
	ld	hl,0x0076
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	b,0x21
	ld	l,0x01
	ld	h,0x00
	ld	e,0x00
	ld	d,0x00
	inc	b
	jp	l_test_lshift32_var_00236
l_test_lshift32_var_00235:
	add	hl, hl
	rl	e
	rl	d
l_test_lshift32_var_00236:
	djnz	l_test_lshift32_var_00235
	ld	a, l
	sub	a,0x02
	or	a, h
	or	a, e
	or	a, d
	jp	NZ,l_test_lshift32_var_00237
	ld	a,0x01
	jp	l_test_lshift32_var_00238
l_test_lshift32_var_00237:
	xor	a,a
l_test_lshift32_var_00238:
	ld	c, a
	ld	b,0x00
	ld	hl,___str_53
	push	hl
	ld	hl,0x0078
	push	hl
	ld	hl,___str_19
	push	hl
	push	bc
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
l_test_lshift32_var_00101:
	ret
	SECTION rodata_compiler
___str_19:
	DEFM "lshift.c"
	DEFB 0x00
	SECTION rodata_compiler
___str_20:
	DEFM "<<0"
	DEFB 0x00
	SECTION rodata_compiler
___str_21:
	DEFM "<<1"
	DEFB 0x00
	SECTION rodata_compiler
___str_22:
	DEFM "<<2"
	DEFB 0x00
	SECTION rodata_compiler
___str_23:
	DEFM "<<3"
	DEFB 0x00
	SECTION rodata_compiler
___str_24:
	DEFM "<<4"
	DEFB 0x00
	SECTION rodata_compiler
___str_25:
	DEFM "<<5"
	DEFB 0x00
	SECTION rodata_compiler
___str_26:
	DEFM "<<6"
	DEFB 0x00
	SECTION rodata_compiler
___str_27:
	DEFM "<<7"
	DEFB 0x00
	SECTION rodata_compiler
___str_28:
	DEFM "<<8"
	DEFB 0x00
	SECTION rodata_compiler
___str_29:
	DEFM "<<9"
	DEFB 0x00
	SECTION rodata_compiler
___str_30:
	DEFM "<<10"
	DEFB 0x00
	SECTION rodata_compiler
___str_31:
	DEFM "<<11"
	DEFB 0x00
	SECTION rodata_compiler
___str_32:
	DEFM "<<12"
	DEFB 0x00
	SECTION rodata_compiler
___str_33:
	DEFM "<<13"
	DEFB 0x00
	SECTION rodata_compiler
___str_34:
	DEFM "<<14"
	DEFB 0x00
	SECTION rodata_compiler
___str_35:
	DEFM "<<15"
	DEFB 0x00
	SECTION rodata_compiler
___str_36:
	DEFM "<<16"
	DEFB 0x00
	SECTION rodata_compiler
___str_37:
	DEFM "<<17"
	DEFB 0x00
	SECTION rodata_compiler
___str_38:
	DEFM "<<18"
	DEFB 0x00
	SECTION rodata_compiler
___str_39:
	DEFM "<<19"
	DEFB 0x00
	SECTION rodata_compiler
___str_40:
	DEFM "<<20"
	DEFB 0x00
	SECTION rodata_compiler
___str_41:
	DEFM "<<21"
	DEFB 0x00
	SECTION rodata_compiler
___str_42:
	DEFM "<<22"
	DEFB 0x00
	SECTION rodata_compiler
___str_43:
	DEFM "<<23"
	DEFB 0x00
	SECTION rodata_compiler
___str_44:
	DEFM "<<24"
	DEFB 0x00
	SECTION rodata_compiler
___str_45:
	DEFM "<<25"
	DEFB 0x00
	SECTION rodata_compiler
___str_46:
	DEFM "<<26"
	DEFB 0x00
	SECTION rodata_compiler
___str_47:
	DEFM "<<27"
	DEFB 0x00
	SECTION rodata_compiler
___str_48:
	DEFM "<<28"
	DEFB 0x00
	SECTION rodata_compiler
___str_49:
	DEFM "<<29"
	DEFB 0x00
	SECTION rodata_compiler
___str_50:
	DEFM "<<30"
	DEFB 0x00
	SECTION rodata_compiler
___str_51:
	DEFM "<<31"
	DEFB 0x00
	SECTION rodata_compiler
___str_52:
	DEFM "<<32"
	DEFB 0x00
	SECTION rodata_compiler
___str_53:
	DEFM "<<33"
	DEFB 0x00
	SECTION code_compiler
;	---------------------------------
; Function test_lshift16_const
; ---------------------------------
_test_lshift16_const:
	ld	hl,___str_55
	push	hl
	ld	hl,0x0080
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_56
	push	hl
	ld	hl,0x0081
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_57
	push	hl
	ld	hl,0x0082
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_58
	push	hl
	ld	hl,0x0083
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_59
	push	hl
	ld	hl,0x0084
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_60
	push	hl
	ld	hl,0x0085
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_61
	push	hl
	ld	hl,0x0086
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_62
	push	hl
	ld	hl,0x0087
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_63
	push	hl
	ld	hl,0x0088
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_64
	push	hl
	ld	hl,0x0089
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_65
	push	hl
	ld	hl,0x008a
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_66
	push	hl
	ld	hl,0x008b
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_67
	push	hl
	ld	hl,0x008c
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_68
	push	hl
	ld	hl,0x008d
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_69
	push	hl
	ld	hl,0x008e
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_70
	push	hl
	ld	hl,0x008f
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_71
	push	hl
	ld	hl,0x0090
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_72
	push	hl
	ld	hl,0x0091
	push	hl
	ld	hl,___str_54
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
l_test_lshift16_const_00101:
	ret
	SECTION rodata_compiler
___str_54:
	DEFM "lshift.c"
	DEFB 0x00
	SECTION rodata_compiler
___str_55:
	DEFM "<<0"
	DEFB 0x00
	SECTION rodata_compiler
___str_56:
	DEFM "<<1"
	DEFB 0x00
	SECTION rodata_compiler
___str_57:
	DEFM "<<2"
	DEFB 0x00
	SECTION rodata_compiler
___str_58:
	DEFM "<<3"
	DEFB 0x00
	SECTION rodata_compiler
___str_59:
	DEFM "<<4"
	DEFB 0x00
	SECTION rodata_compiler
___str_60:
	DEFM "<<5"
	DEFB 0x00
	SECTION rodata_compiler
___str_61:
	DEFM "<<6"
	DEFB 0x00
	SECTION rodata_compiler
___str_62:
	DEFM "<<7"
	DEFB 0x00
	SECTION rodata_compiler
___str_63:
	DEFM "<<8"
	DEFB 0x00
	SECTION rodata_compiler
___str_64:
	DEFM "<<9"
	DEFB 0x00
	SECTION rodata_compiler
___str_65:
	DEFM "<<10"
	DEFB 0x00
	SECTION rodata_compiler
___str_66:
	DEFM "<<11"
	DEFB 0x00
	SECTION rodata_compiler
___str_67:
	DEFM "<<12"
	DEFB 0x00
	SECTION rodata_compiler
___str_68:
	DEFM "<<13"
	DEFB 0x00
	SECTION rodata_compiler
___str_69:
	DEFM "<<14"
	DEFB 0x00
	SECTION rodata_compiler
___str_70:
	DEFM "<<15"
	DEFB 0x00
	SECTION rodata_compiler
___str_71:
	DEFM "<<16"
	DEFB 0x00
	SECTION rodata_compiler
___str_72:
	DEFM "<<17"
	DEFB 0x00
	SECTION code_compiler
;	---------------------------------
; Function test_lshift32_const
; ---------------------------------
_test_lshift32_const:
	ld	hl,___str_74
	push	hl
	ld	hl,0x0099
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_75
	push	hl
	ld	hl,0x009a
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_76
	push	hl
	ld	hl,0x009b
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_77
	push	hl
	ld	hl,0x009c
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_78
	push	hl
	ld	hl,0x009d
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_79
	push	hl
	ld	hl,0x009e
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_80
	push	hl
	ld	hl,0x009f
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_81
	push	hl
	ld	hl,0x00a0
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_82
	push	hl
	ld	hl,0x00a1
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_83
	push	hl
	ld	hl,0x00a2
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_84
	push	hl
	ld	hl,0x00a3
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_85
	push	hl
	ld	hl,0x00a4
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_86
	push	hl
	ld	hl,0x00a5
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_87
	push	hl
	ld	hl,0x00a6
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_88
	push	hl
	ld	hl,0x00a7
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_89
	push	hl
	ld	hl,0x00a8
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_90
	push	hl
	ld	hl,0x00a9
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_91
	push	hl
	ld	hl,0x00aa
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_92
	push	hl
	ld	hl,0x00ab
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_93
	push	hl
	ld	hl,0x00ac
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_94
	push	hl
	ld	hl,0x00ad
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_95
	push	hl
	ld	hl,0x00ae
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_96
	push	hl
	ld	hl,0x00af
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_97
	push	hl
	ld	hl,0x00b0
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_98
	push	hl
	ld	hl,0x00b1
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_99
	push	hl
	ld	hl,0x00b2
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_100
	push	hl
	ld	hl,0x00b3
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_101
	push	hl
	ld	hl,0x00b4
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_102
	push	hl
	ld	hl,0x00b5
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_103
	push	hl
	ld	hl,0x00b6
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_104
	push	hl
	ld	hl,0x00b7
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_105
	push	hl
	ld	hl,0x00b8
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0001
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_106
	push	hl
	ld	hl,0x00b9
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0000
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
	ld	hl,___str_107
	push	hl
	ld	hl,0x00ba
	push	hl
	ld	hl,___str_73
	push	hl
	ld	hl,0x0000
	push	hl
	call	_Assert_real
	ld	hl,8
	add	hl, sp
	ld	sp, hl
l_test_lshift32_const_00101:
	ret
	SECTION rodata_compiler
___str_73:
	DEFM "lshift.c"
	DEFB 0x00
	SECTION rodata_compiler
___str_74:
	DEFM "<<0"
	DEFB 0x00
	SECTION rodata_compiler
___str_75:
	DEFM "<<1"
	DEFB 0x00
	SECTION rodata_compiler
___str_76:
	DEFM "<<2"
	DEFB 0x00
	SECTION rodata_compiler
___str_77:
	DEFM "<<3"
	DEFB 0x00
	SECTION rodata_compiler
___str_78:
	DEFM "<<4"
	DEFB 0x00
	SECTION rodata_compiler
___str_79:
	DEFM "<<5"
	DEFB 0x00
	SECTION rodata_compiler
___str_80:
	DEFM "<<6"
	DEFB 0x00
	SECTION rodata_compiler
___str_81:
	DEFM "<<7"
	DEFB 0x00
	SECTION rodata_compiler
___str_82:
	DEFM "<<8"
	DEFB 0x00
	SECTION rodata_compiler
___str_83:
	DEFM "<<9"
	DEFB 0x00
	SECTION rodata_compiler
___str_84:
	DEFM "<<10"
	DEFB 0x00
	SECTION rodata_compiler
___str_85:
	DEFM "<<11"
	DEFB 0x00
	SECTION rodata_compiler
___str_86:
	DEFM "<<12"
	DEFB 0x00
	SECTION rodata_compiler
___str_87:
	DEFM "<<13"
	DEFB 0x00
	SECTION rodata_compiler
___str_88:
	DEFM "<<14"
	DEFB 0x00
	SECTION rodata_compiler
___str_89:
	DEFM "<<15"
	DEFB 0x00
	SECTION rodata_compiler
___str_90:
	DEFM "<<16"
	DEFB 0x00
	SECTION rodata_compiler
___str_91:
	DEFM "<<17"
	DEFB 0x00
	SECTION rodata_compiler
___str_92:
	DEFM "<<18"
	DEFB 0x00
	SECTION rodata_compiler
___str_93:
	DEFM "<<19"
	DEFB 0x00
	SECTION rodata_compiler
___str_94:
	DEFM "<<20"
	DEFB 0x00
	SECTION rodata_compiler
___str_95:
	DEFM "<<21"
	DEFB 0x00
	SECTION rodata_compiler
___str_96:
	DEFM "<<22"
	DEFB 0x00
	SECTION rodata_compiler
___str_97:
	DEFM "<<23"
	DEFB 0x00
	SECTION rodata_compiler
___str_98:
	DEFM "<<24"
	DEFB 0x00
	SECTION rodata_compiler
___str_99:
	DEFM "<<25"
	DEFB 0x00
	SECTION rodata_compiler
___str_100:
	DEFM "<<26"
	DEFB 0x00
	SECTION rodata_compiler
___str_101:
	DEFM "<<27"
	DEFB 0x00
	SECTION rodata_compiler
___str_102:
	DEFM "<<28"
	DEFB 0x00
	SECTION rodata_compiler
___str_103:
	DEFM "<<29"
	DEFB 0x00
	SECTION rodata_compiler
___str_104:
	DEFM "<<30"
	DEFB 0x00
	SECTION rodata_compiler
___str_105:
	DEFM "<<31"
	DEFB 0x00
	SECTION rodata_compiler
___str_106:
	DEFM "<<32"
	DEFB 0x00
	SECTION rodata_compiler
___str_107:
	DEFM "<<33"
	DEFB 0x00
	SECTION code_compiler
;	---------------------------------
; Function suite_lshift
; ---------------------------------
_suite_lshift:
	ld	hl,___str_108
	push	hl
	call	_suite_setup
	pop	af
	ld	hl,_test_lshift32_const
	push	hl
	ld	hl,___str_109
	push	hl
	call	_suite_add_test_real
	pop	af
	pop	af
	ld	hl,_test_lshift32_var
	push	hl
	ld	hl,___str_110
	push	hl
	call	_suite_add_test_real
	pop	af
	pop	af
	ld	hl,_test_lshift16_const
	push	hl
	ld	hl,___str_111
	push	hl
	call	_suite_add_test_real
	pop	af
	pop	af
	ld	hl,_test_lshift16_var
	push	hl
	ld	hl,___str_112
	push	hl
	call	_suite_add_test_real
	pop	af
	pop	af
	call	_suite_run
l_suite_lshift_00101:
	ret
	SECTION rodata_compiler
___str_108:
	DEFM "Left shift Tests"
	DEFB 0x00
	SECTION rodata_compiler
___str_109:
	DEFM "test_lshift32_const"
	DEFB 0x00
	SECTION rodata_compiler
___str_110:
	DEFM "test_lshift32_var"
	DEFB 0x00
	SECTION rodata_compiler
___str_111:
	DEFM "test_lshift16_const"
	DEFB 0x00
	SECTION rodata_compiler
___str_112:
	DEFM "test_lshift16_var"
	DEFB 0x00
	SECTION code_compiler
;	---------------------------------
; Function main
; ---------------------------------
_main:
	call	_suite_lshift
	call	_exit
l_main_00101:
	ret
	SECTION IGNORE
