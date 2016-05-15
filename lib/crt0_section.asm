; Memory map and section setup
;
; Contains the generic variables + features


		SECTION code_crt_init
crt0_init_bss:
	; TODO: Clear bss area
IF NEED_floatpack
        ld      hl,$8080	;Initialise floating point seed
        ld      (fp_seed),hl
ENDIF
IF DEFINED_ANSIstdio
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
	; SDCC initialiation code gets placed here
		SECTION code_crt_exit

	ret
		SECTION code_compiler
		SECTION code_clib
		SECTION code_crt0_sccz80
		SECTION code_l_sdcc
		SECTION code_math
		SECTION code_error
		SECTION data_compiler
		SECTION rodata_compiler
		SECTION rodata_clib

		SECTION bss_crt
IF bss_start
	org	bss_start
ENDIF
IF DEFINED_ANSIstdio
		PUBLIC	__sgoioblk
__sgoioblk:      defs    40      ;stdio control block
ENDIF
		PUBLIC	coords
		PUBLIC	base_graphics
		PUBLIC	exitsp
		PUBLIC	exitcount
coords:          defw    0       ;Graphics xy coordinates
base_graphics:   defw    0       ;Address of graphics map
exitsp:          defw    0       ;atexit() stack
exitcount:       defb    0       ;Number of atexit() routines
IF NEED_floatpack
		PUBLIC	fp_seed
		PUBLIC  extra
		PUBLIC  fa
		PUBLIC  fasign
fp_seed:         defs    6       ;Floating point seed (not used ATM)
extra:           defs    6       ;Floating point spare register
fa:              defs    6       ;Floating point accumulator
fasign:          defb    0       ;Floating point variable
ENDIF
IF DEFINED_NEED1bitsound
		PUBLIC	snd_tick
		PUBLIC  bit_irqstatus
snd_tick:        defb    0       ;Sound
bit_irqstatus:   defw    0       ;current irq status when DI is necessary
ENDIF
IF DEFINED_USING_amalloc
                EXTERN ASMTAIL
		PUBLIC _heap
; The heap pointer will be wiped at startup,
; but first its value (based on ASMTAIL)
; will be kept for sbrk() to setup the malloc area
_heap:
                defw 0          ; Initialised by code_crt_init - location of the last program byte
                defw 0
ENDIF

		SECTION bss_fardata
		SECTION bss_compiler
		SECTION bss_clib
		SECTION bss_error
