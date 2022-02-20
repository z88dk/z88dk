; Memory map and section setup
;
; Contains the generic variables + features

;
; crt_model = 0		; everything in RAM
; crt_model = 1		; ROM model, data section copied
; crt_model = 2		; ROM model, data section compressed with zx7
; crt_model = 3		; ROM model, data section compressed with zx0

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
    xor     a
    ld      hl,__BSS_head
    ld      bc,__BSS_END_tail - __BSS_head - 1
  IF !__CPU_INTEL__ && !__CPU_GBZ80__
    ld      de,__BSS_head + 1
    ld      (hl),a
    ldir
  ELSE
    inc     b
    inc     c
init_8080:
    ld      (hl+),a
    dec     c
    jr      NZ,init_8080
    dec     b
    jr      NZ,init_8080
  ENDIF
ELSE
    xor     a
ENDIF

    ; a = 0 - reset exitcount
    ld      (exitcount),a
IF CRT_ENABLE_STDIO = 1 && CLIB_FOPEN_MAX > 0
	; Setup std* streams
    ld      hl,__sgoioblk+2
    ld      (hl),19 ;stdin
    ld      hl,__sgoioblk+12
    ld      (hl),21 ;stdout
    ld      hl,__sgoioblk+22
    ld      (hl),21 ;stderr
ENDIF
IF DEFINED_USING_amalloc
  IF __CPU_GBZ80__
    ld      hl,__BSS_END_tail
    ld      a,l
    ld      (_heap),a
    ld      a,h
    ld      (_heap+1),a
  ELSE
    ld      hl,__BSS_END_tail
    ld      (_heap),hl
  ENDIF
ENDIF
IF ( __crt_model = 1 )
    ; Just copy the DATA section
    EXTERN	__ROMABLE_END_tail
    EXTERN	__DATA_head
    EXTERN	__DATA_END_tail
    ld	hl,__ROMABLE_END_tail
    ld	de,__DATA_head
    ld	bc,__DATA_END_tail - __DATA_head
    EXTERN  asm_memcpy
    call    asm_memcpy
ELIF ( __crt_model >= 2 )
    EXTERN	__ROMABLE_END_tail
    EXTERN	__DATA_head
    ld      hl,__ROMABLE_END_tail
    ld      de,__DATA_head
  IF ( __crt_model = 2)
    EXTERN  asm_dzx7_standard
    call    asm_dzx7_standard
  ELIF ( __crt_model = 3)
    EXTERN  asm_dzx0_standard
    call    asm_dzx0_standard
  ENDIF
ENDIF

    SECTION code_crt_init_exit
    ret
    SECTION code_crt_exit
crt0_exit:
    ; Teardown code can go here
    SECTION code_crt_exit_exit
    ret

    SECTION bss_crt
IF CRT_ENABLE_STDIO = 1 && CLIB_FOPEN_MAX > 0
    PUBLIC	__sgoioblk
    PUBLIC	__sgoioblk_end
__sgoioblk:     defs    CLIB_FOPEN_MAX * 10      ;stdio control block
__sgoioblk_end:   		 ;end of stdio control block
ENDIF




IF !DEFINED_basegraphics
    PUBLIC	base_graphics
base_graphics:   defw    0       ;Address of graphics map
ENDIF
    PUBLIC	exitsp
    PUBLIC	exitcount
exitsp:          defw    0       ;atexit() stack
exitcount:       defb    0       ;Number of atexit() routines
IF DEFINED_USING_amalloc
    PUBLIC _heap
    ; The heap pointer will be wiped at bss initialisation.
    ; Its value (based on __tail) will be set later if set
    ; by sbrk() during AMALLOC initialisation.
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
