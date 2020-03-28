; Memory map and section setup
;
; Contains the generic variables + features

;
; crt_model = 0		; everything in RAM
; crt_model = 1		; ROM model, data section copied
; crt_model = 2		; ROM model, data section compressed

; Include the default memory map. You can override this

IF __MMAP == -1
	; The user has supplied a memory map.
	INCLUDE	"./mmap.inc"
ELSE
	; Include the standard memory map
	INCLUDE	"crt/classic/crt_section_standard.asm"
ENDIF


; The classic CRTs need some things setup, so do it

		SECTION code_crt_init
crt0_init_bss:
        EXTERN  __BSS_head
        EXTERN  __BSS_END_tail
IF CRT_INITIALIZE_BSS = 1
        ld      hl,__BSS_head
        ld      bc,__BSS_END_tail - __BSS_head - 1
  IF !__CPU_8080__ && !__CPU_GBZ80__
        ld      de,__BSS_head + 1
        xor     a 
	ld	(hl),a
        ldir
  ELSE
init_8080_1:
	ld	(hl),0
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jp	nz,init_8080_1
  ENDIF
ELSE
        xor     a 
ENDIF

	; a = 0 - reset exitcount
        ld      (exitcount),a
IF CRT_ENABLE_STDIO = 1
	; Setup std* streams
        ld      hl,__sgoioblk+2
        ld      (hl),19 ;stdin
        ld      hl,__sgoioblk+12
        ld      (hl),21 ;stdout
        ld      hl,__sgoioblk+22
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
	
		SECTION code_crt_init_exit
			ret
		SECTION code_crt_exit
crt0_exit:
			; Teardown code can go here
		SECTION code_crt_exit_exit
			ret

		SECTION bss_crt
IF CRT_ENABLE_STDIO = 1
        IF !DEFINED_CLIB_FOPEN_MAX
                DEFC    CLIB_FOPEN_MAX = 10
        ENDIF
		PUBLIC	__sgoioblk
		PUBLIC	__sgoioblk_end
		PUBLIC  __FOPEN_MAX
                defc    __FOPEN_MAX = CLIB_FOPEN_MAX
__sgoioblk:     defs    CLIB_FOPEN_MAX * 10      ;stdio control block
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

IF CLIB_BALLOC_TABLE_SIZE > 0

   ; create balloc table
   SECTION data_alloc_balloc
   PUBLIC __balloc_array
   __balloc_array:             defw __balloc_table

   SECTION bss_alloc_balloc
   PUBLIC __balloc_table
   __balloc_table:             defs CLIB_BALLOC_TABLE_SIZE * 2

ENDIF
