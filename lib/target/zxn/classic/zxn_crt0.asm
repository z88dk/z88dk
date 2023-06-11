;       Options:
;
;      CRT_ORG_CODE = start address
;      CRT_ORG_BSS = address for bss variables
;      CRT_MODEL   = 0 (RAM), 1 = (ROM, code copied), 2 = (ROM, code compressed)


    MODULE  zxn_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN  _main           ; main() is always external to crt0 code

    PUBLIC  cleanup         ; jp'd to by exit()
    PUBLIC  l_dcal          ; jp(hl)

    PUBLIC  call_rom3       ; Interposer


    PUBLIC  __SYSVAR_BORDCR
    defc    __SYSVAR_BORDCR = 23624


    PUBLIC    _FRAMES
    IF startup != 2
        defc  _FRAMES = 23672 ; Timer	
    ENDIF
    
    ; We default to the 64 column terminal driver
    ; Check whether to default to 32 column display
    defc    CONSOLE_ROWS = 24
    IF !DEFINED_CLIB_ZX_CONIO32
        defc    CLIB_ZX_CONIO32 = 0
        defc    CONSOLE_COLUMNS = 64
    ELSE
        defc    CONSOLE_COLUMNS = 32
    ENDIF
    PUBLIC  __CLIB_ZX_CONIO32
    defc    __CLIB_ZX_CONIO32 = CLIB_ZX_CONIO32

    IFNDEF CLIB_FGETC_CONS_DELAY
        defc CLIB_FGETC_CONS_DELAY = 100
    ENDIF

    defc    CRT_KEY_DEL = 12
    defc    __CPU_CLOCK = 3500000


IF __ESXDOS_DOT_COMMAND
    INCLUDE	"target/zxn/classic/dot_crt0.asm"
ELSE
    INCLUDE	"target/zxn/classic/ram_crt0.asm"
ENDIF


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

    INCLUDE	"crt/classic/crt_runtime_selection.asm"

    PUBLIC __CLIB_TILES_PALETTE_SET_INDEX
IFDEF CLIB_TILES_PALETTE_SET_INDEX
    defc __CLIB_TILES_PALETTE_SET_INDEX = CLIB_TILES_PALETTE_SET_INDEX
ELSE
    defc __CLIB_TILES_PALETTE_SET_INDEX = 1
ENDIF



