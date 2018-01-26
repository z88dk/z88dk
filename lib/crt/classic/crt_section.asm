; Memory map and section setup
;
; Contains the generic variables + features

;
; crt_model = 0		; everything in RAM
; crt_model = 1		; ROM model, data section copied
; crt_model = 2		; ROM model, data section compressed

		SECTION CODE
		SECTION code_crt_init
crt0_init_bss:
        EXTERN  __BSS_head
        EXTERN  __BSS_END_tail
IF CRT_INITIALIZE_BSS	
        ld      hl,__BSS_head
        ld      de,__BSS_head + 1
        ld      bc,__BSS_END_tail - __BSS_head - 1
        xor     a 
	ld	(hl),a
        ldir
ENDIF

	; a = 0 - reset exitcount
        ld      (exitcount),a
IF !DEFINED_nostreams
	; Setup std* streams
        ld      hl,__sgoioblk+2
        ld      (hl),19 ;stdin
        ld      hl,__sgoioblk+8
        ld      (hl),21 ;stdout
        ld      hl,__sgoioblk+14
        ld      (hl),21 ;stderr
ENDIF
IF DEFINED_USING_amalloc
	ld	hl,__BSS_END_tail
	ld	(_heap),hl
ENDIF
IF ( __crt_model & 1 )
	; Just copy the DATA section
	EXTERN	__ROMABLE_END_tail
	EXTERN	__DATA_head
	EXTERN	__DATA_END_tail
	ld	hl,__ROMABLE_END_tail
	ld	de,__DATA_head
	ld	bc,__DATA_END_tail - __DATA_head
	ldir
ENDIF
IF ( __crt_model & 2 )
	; Decompress the DATA section
	EXTERN	__ROMABLE_END_tail
	EXTERN	__DATA_head
	EXTERN	asm_dzx7_standard
	ld	hl,__ROMABLE_END_tail
	ld	de,__DATA_head
	call    asm_dzx7_standard
ENDIF
	
	; SDCC initialiation code gets placed here
		SECTION code_crt_exit

	ret
		SECTION code_compiler
		SECTION code_clib
		SECTION code_crt0_sccz80
		SECTION code_l
		SECTION code_l_sdcc
		SECTION code_l_sccz80
		SECTION code_compress_zx7
		SECTION code_ctype
		SECTION code_esxdos
		SECTION code_fp
		SECTION code_fp_math48
		SECTION code_math
		SECTION code_error
		SECTION code_stdlib
		SECTION code_string
		SECTION	code_adt_b_array
		SECTION	code_adt_b_vector
		SECTION	code_adt_ba_priority_queue
		SECTION	code_adt_ba_stack
		SECTION	code_adt_bv_priority_queue
		SECTION	code_adt_bv_stack
		SECTION	code_adt_p_forward_list
		SECTION	code_adt_p_forward_list_alt
		SECTION	code_adt_p_list
		SECTION	code_adt_p_queue
		SECTION	code_adt_p_stack
		SECTION	code_adt_w_array
		SECTION	code_adt_w_vector
		SECTION	code_adt_wa_priority_queue
		SECTION	code_adt_wa_stack
		SECTION	code_adt_wv_priority_queue
		SECTION	code_adt_wv_stack
		SECTION code_alloc_balloc
		SECTION code_alloc_obstack

		SECTION code_user
		SECTION rodata_fp
		SECTION rodata_compiler
		SECTION rodata_clib
		SECTION rodata_user
		SECTION rodata_font
		SECTION rodata_font_4x8
		SECTION rodata_font_8x8
		SECTION ROMABLE_END
IF !__crt_model
		SECTION DATA
		SECTION smc_clib
		SECTION smc_user
		SECTION data_clib
		SECTION data_crt
		SECTION data_compiler
		SECTION data_user
		SECTION data_alloc_balloc
		SECTION DATA_END
ENDIF

		SECTION BSS
IF __crt_org_bss
		org	__crt_org_bss
		defb 0   ; control name of bss binary
ENDIF
		SECTION bss_fp
		SECTION bss_error
		SECTION bss_crt
IF !DEFINED_nostreams
        IF !DEFINED_CLIB_FOPEN_MAX
                DEFC    CLIB_FOPEN_MAX = 10
        ENDIF
		PUBLIC	__sgoioblk
		PUBLIC	__sgoioblk_end
		PUBLIC  __FOPEN_MAX
                defc    __FOPEN_MAX = CLIB_FOPEN_MAX
__sgoioblk:     defs    CLIB_FOPEN_MAX * 6      ;stdio control block
__sgoioblk_end:   		 ;end of stdio control block
ENDIF
		PUBLIC	base_graphics
		PUBLIC	exitsp
		PUBLIC	exitcount
IF !DEFINED_basegraphics
base_graphics:   defw    0       ;Address of graphics map
ENDIF
exitsp:          defw    0       ;atexit() stack
exitcount:       defb    0       ;Number of atexit() routines
IF DEFINED_USING_amalloc
		PUBLIC _heap
; The heap pointer will be wiped at startup,
; but first its value (based on __tail)
; will be kept for sbrk() to setup the malloc area
_heap:
                defw 0          ; Initialised by code_crt_init - location of the last program byte
                defw 0
ENDIF
		SECTION bss_fardata
IF __crt_org_bss_fardata_start
		org	__crt_org_bss_fardata_start
ENDIF
		SECTION bss_compiler
IF __crt_org_bss_compiler_start
		org	__crt_org_bss_compiler_start
ENDIF
		SECTION bss_clib
		SECTION bss_string
		SECTION bss_alloc_balloc
		SECTION bss_user
IF __crt_model > 0
        SECTION DATA
		org	-1
		defb	0		; control name of data binary
		SECTION smc_clib
		SECTION smc_user
		SECTION data_clib
		SECTION data_crt
		SECTION data_compiler
		SECTION data_user
		SECTION data_alloc_balloc
		SECTION DATA_END
ENDIF
		SECTION BSS_END


IF CLIB_BALLOC_TABLE_SIZE > 0

   ; create balloc table

   SECTION data_clib
   SECTION data_alloc_balloc

   PUBLIC __balloc_array

   __balloc_array:             defw __balloc_table

   SECTION bss_clib
   SECTION bss_alloc_balloc

   __balloc_table:             defs CLIB_BALLOC_TABLE_SIZE * 2

ENDIF

IF CRT_APPEND_MMAP

INCLUDE "./mmap.inc"

ENDIF
