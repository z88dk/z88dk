;       Options:
;          startup=1  --> RAM mode
;          startup=2  --> ROM mode (position code at location 0 and provide minimal interrupt services)
;
;          CRT_ORG_CODE = start address
;          CRT_ORG_BSS = address for bss variables
;          CRT_MODEL   = 0 (RAM), 1 = (ROM, code copied), 2 = (ROM, code compressed)
;
;       djm 18/5/99
;
;       $Id: spec_crt0.asm,v 1.53 2016-07-16 07:06:27 dom Exp $
;


    MODULE  zx82_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN    _main           ; main() is always external to crt0 code
    PUBLIC    __Exit         ; jp'd to by exit()
    PUBLIC    l_dcal          ; jp(hl)
    PUBLIC    call_rom3       ; Interposer


    PUBLIC  __SYSVAR_BORDCR
    defc    __SYSVAR_BORDCR = 23624


    IF DEFINED_ZXVGS
        IF !DEFINED_CRT_ORG_CODE
            defc    CRT_ORG_CODE = $5CCB     ; repleaces BASIC program
            defc	DEFINED_CRT_ORG_CODE = 1
        ENDIF
        defc REG__register_sp = 0xff57	; below UDG, keep eye when using banks
    ENDIF

    IF !DEFINED_CRT_MAX_HEAP_ADDRESS
        defc    CRT_MAX_HEAP_ADDRESS = 65535 - 169
    ENDIF


    PUBLIC    _FRAMES
    IF startup != 2
            defc  _FRAMES = 23672 ; Timer	
    ENDIF
        
    IF      !DEFINED_CRT_ORG_CODE
        IF (startup=2)                 ; ROM ?
            defc    CRT_ORG_CODE  = 0
            defc    TAR__register_sp = 32767
        ELSE
            IF DEFINED_CRT_TS2068_HRG
                defc    CRT_ORG_CODE  = 40000
            ELSE
                defc    CRT_ORG_CODE  = 32768
            ENDIF
        ENDIF
    ENDIF

    ; We default to the 64 column terminal driver
    ; Check whether to default to 32 column display
    defc    CONSOLE_ROWS = 24
    IF DEFINED_CLIB_DEFAULT_SCREEN_MODE && __TS2068__
        IF DEFINED_CLIB_ZX_CONIO32
           defc BASE_COLS = 32
        ELSE
           defc CLIB_ZX_CONIO32 = 0
           defc BASE_COLS = 64
        ENDIF
        IF CLIB_DEFAULT_SCREEN_MODE < 6
           defc CONSOLE_COLUMNS = BASE_COLS
        ELSE
           ; Hires mode
           defc CONSOLE_COLUMNS = BASE_COLS * 2
        ENDIF
    ELIF !DEFINED_CLIB_ZX_CONIO32
        defc CLIB_ZX_CONIO32 = 0
        defc CONSOLE_COLUMNS = 64
    ELSE
        defc CONSOLE_COLUMNS = 32
    ENDIF
    PUBLIC __CLIB_ZX_CONIO32
    defc __CLIB_ZX_CONIO32 = CLIB_ZX_CONIO32

    IFNDEF CLIB_FGETC_CONS_DELAY
        defc CLIB_FGETC_CONS_DELAY = 100
    ENDIF

    ; We use the generic driver by default
    defc    TAR__fputc_cons_generic = 1

IFNDEF TAR__register_sp
    defc    TAR__register_sp = -1
ENDIF
    defc    TAR__clib_exit_stack_size = 32
    defc    CRT_KEY_DEL = 12
    defc    __CPU_CLOCK = 3500000
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE


start:

        ; --- startup=2 ---> build a ROM

IF (startup=2)

    IFNDEF CLIB_FGETC_CONS_DELAY
        defc CLIB_FGETC_CONS_DELAY = 100
    ENDIF

    di          ; put hardware in a stable state
    ld      a,$3F
    ld      i,a
    jr      init            ; go over rst 8, bypass shadow ROM

    defs    $0008-ASMPC
if (ASMPC<>$0008)
    defs    CODE_ALIGNMENT_ERROR
endif

    ; --- rst 8 ---
    ld      hl,($5c5d)      ; It was the address reached by CH-ADD.
    nop                     ; one byte still, to jump over the
                            ; Opus Discovery and similar shadowing traps
    ; --- nothing more ?

init:

    INCLUDE	"crt/classic/crt_init_sp.inc"

    ld      a,@111000       ; White PAPER, black INK
    call    zx_internal_cls
    ld      (hl),0
    ld      bc,42239
    ldir

    INCLUDE	"crt/classic/crt_init_atexit.inc"
    call    crt0_init

    im      1
    ei
ELSE

        ; --- startup=[default] ---
  IF DEFINED_CLIB_DEFAULT_SCREEN_MODE && __TS2068__
    EXTERN ts_vmod
    ld      l,CLIB_DEFAULT_SCREEN_MODE
    call    ts_vmod 
  ENDIF
  IF !DEFINED_CRT_DISABLELOADER
        call   loadbanks
  ENDIF

        ld      iy,23610        ; restore the right iy value, 
                                ; fixing the self-relocating trick, if any
  IF !DEFINED_ZXVGS
        ld      (__restore_sp_onexit+1),sp   ; Save entry stack
  ENDIF
    INCLUDE	"crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE	"crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"

  IF CLIB_FARHEAP_BANKS > 0
    IF CLIB_FARHEAP_BANKS > 4
        defs    CANT_ALLOCATE_MORE_THAN_64K_TO_FARHEAP
    ENDIF
    EXTERN  sbrk_far
    ld      de,$0001
    ld      hl,0
    push    de
    push    hl
    ld      bc,+(CLIB_FARHEAP_BANKS * 16384) - 1
    push    bc
    call    sbrk_far
    pop     af
    pop     af
    pop     af
  ENDIF

  IF DEFINED_ZXVGS
;setting variables needed for proper keyboard reading
        LD      (IY+1),$CD      ; FLAGS #5C3B
        LD      (IY+48),1       ; FLAGS2 #5C6A
        EI                      ; ZXVGS starts with disabled interrupts
  ENDIF
;        ld      a,2             ; open the upper display (uneeded?)
;        call    5633

ENDIF


IF DEFINED_NEEDresidos
    call    residos_detect
    jp      c,crt0_exit_exit
ENDIF
    call    _main           ; Call user program
__Exit:
    push    hl
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"


IF (startup=2)      ; ROM ?

crt0_exit_exit:
    rst     0

    defs    56-crt0_exit_exit-1

if (ASMPC<>$0038)
    defs    CODE_ALIGNMENT_ERROR
endif

; ######## IM 1 MODE INTERRUPT ENTRY ########

    INCLUDE "target/zx/classic/spec_crt0_rom_isr.asm"

; ########  END OF ROM INTERRUPT HANDLER ######## 

PUBLIC zx_internal_cls
zx_internal_cls:
    ld      hl,$4000        ; cls
    ld      d,h
    ld      e,l
    inc     de
    ld      (hl),0
    ld      bc,$1800
    ldir
    ld      (hl),a
    ld      bc,768
    ldir
    rrca
    rrca
    rrca
    out     (254),a
    ret


ELSE
  IF DEFINED_ZXVGS
        POP     BC              ;let's say exit code goes to BC
        RST     8
        DEFB    $FD             ;Program finished
  ELSE
crt0_exit_exit:
        ld      hl,10072        ;Restore hl' to what basic wants
        exx
        pop     bc
__restore_sp_onexit:ld      sp,0            ;Restore stack to entry value
        ret
  ENDIF
ENDIF



l_dcal: jp      (hl)            ;Used for function pointer calls

; Runtime selection

IF NEED_fzxterminal
    PUBLIC  fputc_cons
    PUBLIC  _fputc_cons
    PUBLIC  _fgets_cons_erase_character
    PUBLIC  fgets_cons_erase_character
    EXTERN  fputc_cons_fzx
    EXTERN  fgets_cons_erase_character_fzx
    defc    DEFINED_fputc_cons = 1
    defc    fputc_cons = fputc_cons_fzx
    defc    _fputc_cons = fputc_cons_fzx
    defc    fgets_cons_erase_character = fgets_cons_erase_character_fzx
    defc    _fgets_cons_erase_character = fgets_cons_erase_character_fzx
ENDIF

    INCLUDE	"crt/classic/crt_runtime_selection.inc"

;---------------------------------------------
; Some +3 stuff - this needs to be below 49152
;---------------------------------------------
IF DEFINED_NEEDresidos
    INCLUDE "target/zx/def/idedos.def"

    defc    ERR_NR=$5c3a            ; BASIC system variables
    defc    ERR_SP=$5c3d

    PUBLIC    dodos
    EXTERN  dodos_residos
    defc    dodos = dodos_residos

; Detect an installed version of ResiDOS.
;
; This should be done before you attempt to call any other ResiDOS/+3DOS/IDEDOS
; routines, and ensures that the Spectrum is running with ResiDOS installed.
; Since +3DOS and IDEDOS are present only from v1.40, this version must
; be checked for before making any further calls.
;
; If you need to use calls that were only provided from a certain version of
; ResiDOS, you can check that here as well.
;
; The ResiDOS version call is made with a special hook-code after a RST 8,
; which will cause an error on Speccies without ResiDOS v1.20+ installed,
; or error 0 (OK) if ResiDOS v1.20+ is present. Therefore, we need
; to trap any errors here.
residos_detect:
    ld      hl,(ERR_SP)
    push    hl                      ; save the existing ERR_SP
    ld      hl,detect_error
    push    hl                      ; stack error-handler return address
    ld      hl,0
    add     hl,sp
    ld      (ERR_SP),hl             ; set the error-handler SP
    rst     RST_HOOK                ; invoke the version info hook code
    defb    HOOK_VERSION
    pop     hl                      ; ResiDOS doesn't return, so if we get
    jr      noresidos               ; here, some other hardware is present
detect_error:
    pop     hl
    ld      (ERR_SP),hl             ; restore the old ERR_SP
    ld      a,(ERR_NR)
    inc     a                       ; is the error code now "OK"?
    jr      nz,noresidos            ; if not, ResiDOS was not detected
    ex      de,hl                   ; get HL=ResiDOS version
    push    hl                      ; save the version
    ld      de,$0140                ; DE=minimum version to run with
    and     a
    sbc     hl,de
    pop     bc                      ; restore the version to BC
    ret     nc                      ; and return with it if at least v1.40
noresidos:
    ld      bc,0                    ; no ResiDOS
    ld      a,$ff
    ld      (ERR_NR),a              ; clear error
    ret


ENDIF



; Call a routine in the spectrum ROM
; The routine to call is stored in the two bytes following
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

        


IF (startup=2) 			;ROM

	IF !DEFINED_CRT_ORG_BSS
	    defc CRT_ORG_BSS = 24576
	    defc DEFINED_CRT_ORG_BSS = 1
	ENDIF

        ; If we were given a model then use it
        IF DEFINED_CRT_MODEL
            defc __crt_model = CRT_MODEL
        ELSE
            defc __crt_model = 1
        ENDIF
ELSE
  IF !DEFINED_CRT_DISABLELOADER
loadbanks:
    IF DEFINED_CRT_PLUS3LOADER
        INCLUDE "target/zx/classic/zx_p3loader.asm"
    ELSE
        INCLUDE "target/zx/classic/zx_tapeloader.asm"
    ENDIF
  ENDIF
ENDIF

; If we were given an address for the BSS then use it
IF DEFINED_CRT_ORG_BSS
    defc    __crt_org_bss = CRT_ORG_BSS
ENDIF

; Create a dedicated contended section
IF CRT_ORG_CODE < 32768
    SECTION CONTENDED
ENDIF

    INCLUDE	"crt/classic/crt_section.inc"

    SECTION	code_crt_init
    ld      a,@111000       ; White PAPER, black INK
    ld      ($5c48),a       ; BORDCR
    ld      ($5c8d),a       ; ATTR_P
    ld      ($5c8f),a       ; ATTR_T

    SECTION bss_crt
IF startup=2
    PUBLIC  romsvc
_FRAMES:        defs    3
romsvc:         defs    10  ; Pointer to the end of the sysdefvars
                            ; used by the ROM version of some library
ENDIF


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Define Memory Banks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    IFNDEF CRT_ORG_BANK_0
        defc CRT_ORG_BANK_0 = 0xc000
    ENDIF

    IFNDEF CRT_ORG_BANK_1
        defc CRT_ORG_BANK_1 = 0xc000
    ENDIF

    IFNDEF CRT_ORG_BANK_2
        defc CRT_ORG_BANK_2 = 0xc000
    ENDIF

    IFNDEF CRT_ORG_BANK_3
        defc CRT_ORG_BANK_3 = 0xc000
    ENDIF

    IFNDEF CRT_ORG_BANK_4
        defc CRT_ORG_BANK_4 = 0xc000
    ENDIF

    IFNDEF CRT_ORG_BANK_5
        defc CRT_ORG_BANK_5 = 0xc000
    ENDIF

    IFNDEF CRT_ORG_BANK_6
        defc CRT_ORG_BANK_6 = 0xc000
    ENDIF

    IFNDEF CRT_ORG_BANK_7
        defc CRT_ORG_BANK_7 = 0xc000
    ENDIF


    SECTION BANK_0
    org 0x000000 + CRT_ORG_BANK_0
    SECTION CODE_0
    SECTION RODATA_0
    SECTION DATA_0
    SECTION BSS_0
    SECTION BANK_0_END

    SECTION BANK_1
    org 0x010000 + CRT_ORG_BANK_1
    SECTION CODE_1
    SECTION RODATA_1
    SECTION DATA_1
    SECTION BSS_1
    SECTION BANK_1_END

    SECTION BANK_2
    org 0x020000 + CRT_ORG_BANK_2
    SECTION CODE_2
    SECTION RODATA_2
    SECTION DATA_2
    SECTION BSS_2
    SECTION BANK_2_END

    SECTION BANK_3
    org 0x030000+ CRT_ORG_BANK_3
    SECTION CODE_3
    SECTION RODATA_3
    SECTION DATA_3
    SECTION BSS_3
    SECTION BANK_3_END

    SECTION BANK_4
    org 0x040000 + CRT_ORG_BANK_4
    SECTION CODE_4
    SECTION RODATA_4
    SECTION DATA_4
    SECTION BSS_4
    SECTION BANK_4_END

    SECTION BANK_5
    org 0x050000 + CRT_ORG_BANK_5
    SECTION CODE_5
    SECTION RODATA_5
    SECTION DATA_5
    SECTION BSS_5
    SECTION BANK_5_END

    SECTION BANK_6
    org 0x060000 + CRT_ORG_BANK_6
    SECTION CODE_6
    SECTION RODATA_6
    SECTION DATA_6
    SECTION BSS_6
    SECTION BANK_6_END

    SECTION BANK_7
    org 0x070000 + CRT_ORG_BANK_7
    SECTION CODE_7
    SECTION RODATA_7
    SECTION DATA_7
    SECTION BSS_7
    SECTION BANK_7_END
