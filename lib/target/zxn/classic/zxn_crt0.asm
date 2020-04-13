;       Options:
;
;          CRT_ORG_CODE = start address
;	   CRT_ORG_BSS = address for bss variables
;          CRT_MODEL   = 0 (RAM), 1 = (ROM, code copied), 2 = (ROM, code compressed)
;
;       djm 18/5/99
;


        MODULE  zxn_crt0

        
;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ; main() is always external to crt0 code

        PUBLIC    cleanup         ; jp'd to by exit()
        PUBLIC    l_dcal          ; jp(hl)

        PUBLIC    call_rom3       ; Interposer
       
        

	PUBLIC	  __SYSVAR_BORDCR
	defc	  __SYSVAR_BORDCR = 23624


        PUBLIC    _FRAMES
        IF startup != 2
                defc  _FRAMES = 23672 ; Timer	
        ENDIF
        
        IF      !DEFINED_CRT_ORG_CODE
                defc  CRT_ORG_CODE  = 32768
        ENDIF
        defc __crt_org_code = CRT_ORG_CODE
	PUBLIC __crt_org_code

	; We default to the 64 column terminal driver
        defc    CONSOLE_COLUMNS = 64
        defc    CONSOLE_ROWS = 24

	IF !CLIB_FGETC_CONS_DELAY
		defc CLIB_FGETC_CONS_DELAY = 100
	ENDIF

	; We use the generic driver by default
        defc    TAR__fputc_cons_generic = 1

	defc	DEF__register_sp = 
        defc    TAR__clib_exit_stack_size = 32
	defc	CRT_KEY_DEL = 12
	defc __CPU_CLOCK = 3500000
	INCLUDE	"crt/classic/crt_rules.inc"

        org     CRT_ORG_CODE


start:
        ; --- startup=[default] ---

        ld      iy,23610        ; restore the right iy value, 
                                ; fixing the self-relocating trick, if any
	INCLUDE	"crt/classic/crt_init_sp.asm"
	INCLUDE	"crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss
        ld      (exitsp),sp
; Optional definition for auto MALLOC init; it takes
; all the space between the end of the program and UDG
IF DEFINED_USING_amalloc
	defc	CRT_MAX_HEAP_ADDRESS = 65535 - 169
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

        call    _main           ; Call user program
cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push    hl
      call    crt0_exit

cleanup_exit:
        ld      hl,10072        ;Restore hl' to what basic wants
        exx
        pop     bc
start1: ld      sp,0            ;Restore stack to entry value
        ret



l_dcal: jp      (hl)            ;Used for function pointer calls

call_rom3:
        exx                      ; Use alternate registers
IF DEFINED_NEED_ZXMMC
        push    af
        xor     a                ; standard ROM
        out     ($7F),a          ; ZXMMC FASTPAGE
        pop     af
ENDIF
        ex      (sp),hl          ; get return address
        ld      c,(hl)
        inc     hl
        ld      b,(hl)           ; BC=BASIC address
        inc     hl
        ex      (sp),hl          ; restore return address
        push    bc
        exx                      ; Back to the regular set
        ret


; Runtime selection

IF NEED_fzxterminal
        PUBLIC          fputc_cons
        PUBLIC          _fputc_cons
	PUBLIC		_fgets_cons_erase_character
	PUBLIC		fgets_cons_erase_character
        EXTERN          fputc_cons_fzx
        EXTERN          fgets_cons_erase_character_fzx
        defc DEFINED_fputc_cons = 1
        defc fputc_cons = fputc_cons_fzx
        defc _fputc_cons = fputc_cons_fzx
        defc fgets_cons_erase_character = fgets_cons_erase_character_fzx
        defc _fgets_cons_erase_character = fgets_cons_erase_character_fzx
ENDIF

	INCLUDE	"crt/classic/crt_runtime_selection.asm"

	PUBLIC __CLIB_TILES_PALETTE_SET_INDEX
IFDEF CLIB_TILES_PALETTE_SET_INDEX
	defc __CLIB_TILES_PALETTE_SET_INDEX = CLIB_TILES_PALETTE_SET_INDEX
ELSE
	defc __CLIB_TILES_PALETTE_SET_INDEX = 1
ENDIF

; If we were given an address for the BSS then use it
IF DEFINED_CRT_ORG_BSS
	defc	__crt_org_bss = CRT_ORG_BSS
ENDIF

	INCLUDE "target/zxn/classic/memory_map.asm"

	SECTION	code_crt_init
        ld      a,@111000       ; White PAPER, black INK
        ld      ($5c48),a       ; BORDCR
        ld      ($5c8d),a       ; ATTR_P
        ld      ($5c8f),a       ; ATTR_T



