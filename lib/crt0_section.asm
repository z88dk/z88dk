; Memory map and section setup
;
; Contains the generic variables + features


		SECTION code_crt_init
crt0_init_bss:
	; TODO: Clear bss area
        xor     a               ;Reset atexit() count
        ld      (exitcount),a
IF !DEFINED_nostreams
	; Setup std* streams
        ld      hl,__sgoioblk
        ld      de,__sgoioblk+1
        ld      bc,39
        ld      (hl),0
        ldir
        ld      hl,__sgoioblk+2
        ld      (hl),19 ;stdin
        ld      hl,__sgoioblk+6
        ld      (hl),21 ;stdout
        ld      hl,__sgoioblk+10
        ld      (hl),21 ;stderr
ENDIF
IF DEFINED_USING_amalloc
                EXTERN ASMTAIL
	ld	hl,ASMTAIL
	ld	(_heap),hl
ENDIF
	; SDCC initialiation code gets placed here
		SECTION code_crt_exit

	ret
		SECTION code_compiler
		SECTION code_clib
		SECTION code_crt0_sccz80
		SECTION code_l_sdcc
		SECTION code_math
		SECTION code_error
		SECTION smc_clib
		SECTION data_bss
		SECTION data_compiler
		SECTION rodata_compiler
		SECTION rodata_clib

		SECTION bss_crt
IF bss_start
	org	bss_start
ENDIF
IF !DEFINED_nostreams
		PUBLIC	__sgoioblk
__sgoioblk:      defs    40      ;stdio control block
ENDIF
		PUBLIC	coords
		PUBLIC	base_graphics
		PUBLIC	exitsp
		PUBLIC	exitcount
IF !coords_space
	defc coords_space = 2
ENDIF
coords:          defs    coords_space       ;Graphics xy coordinates
base_graphics:   defw    0       ;Address of graphics map
exitsp:          defw    0       ;atexit() stack
exitcount:       defb    0       ;Number of atexit() routines
IF DEFINED_USING_amalloc
		PUBLIC _heap
; The heap pointer will be wiped at startup,
; but first its value (based on ASMTAIL)
; will be kept for sbrk() to setup the malloc area
_heap:
                defw 0          ; Initialised by code_crt_init - location of the last program byte
                defw 0
ENDIF

		SECTION bss_fardata
IF bss_fardata_start
		org	bss_fardata_start
ENDIF
		SECTION bss_compiler
IF bss_compiler_start
		org	bss_compiler_start
ENDIF
		SECTION bss_clib
		SECTION bss_error
