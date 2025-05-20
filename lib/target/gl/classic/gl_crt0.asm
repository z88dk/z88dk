;
;	Startup for Genius Leader 2000/4000/6000sl
;

    MODULE  gl_crt0 


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN    _main           ;main() is always external to crt0 code

    PUBLIC    __Exit         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)

IF GL_TARGET_GL2000
    defc    __CPU_CLOCK = 4000000
    defc    CONSOLE_COLUMNS = 20
    defc    CONSOLE_ROWS = 2
    defc    LCD_DATA_PORT = 0x0b
    defc    LCD_CONTROL_PORT = 0x0a
    defc    LCD_VRAM = 0xdca0
    defc    VGL_KEY_STATUS_ADDRESS = 0xdce0
    defc    VGL_KEY_CURRENT_ADDRESS = 0xdce4
    defc    CRT_ORG_BSS = 0xc000	
    defc    CRT_ORG_CODE = 0x8000
    defc    TAR__register_sp = 0xdf00
    EXTERN  asm_lcd_get_ddram_addr_2x20
    PUBLIC  asm_lcd_get_ddram_addr
    defc    asm_lcd_get_ddram_addr = asm_lcd_get_ddram_addr_2x20
    PUBLIC  LCD_DATA_PORT
    PUBLIC  LCD_CONTROL_PORT
    PUBLIC  LCD_VRAM
    PUBLIC  VGL_KEY_STATUS_ADDRESS
    PUBLIC  VGL_KEY_CURRENT_ADDRESS
ENDIF


IF GL_TARGET_GL4000
    defc	__CPU_CLOCK = 4000000
    defc	CONSOLE_COLUMNS = 20
    defc	CONSOLE_ROWS = 4
    defc    LCD_DATA_PORT = 0x0b
    defc    LCD_CONTROL_PORT = 0x0a
    defc    LCD_VRAM = 0xdca0
    defc    VGL_KEY_STATUS_ADDRESS = 0xdb00
    defc    VGL_KEY_CURRENT_ADDRESS = 0xdb01
    defc	CRT_ORG_BSS = 0xc000	
    defc	CRT_ORG_CODE = 0x8000
    defc    TAR__register_sp = 0xdf00
    EXTERN  asm_lcd_get_ddram_addr_gl4000
    PUBLIC  asm_lcd_get_ddram_addr
    defc    asm_lcd_get_ddram_addr = asm_lcd_get_ddram_addr_gl4000
    PUBLIC  LCD_DATA_PORT
    PUBLIC  LCD_CONTROL_PORT
    PUBLIC  LCD_VRAM
    PUBLIC  VGL_KEY_STATUS_ADDRESS
    PUBLIC  VGL_KEY_CURRENT_ADDRESS
ENDIF

IF GL_TARGET_GL6000
    defc    __CPU_CLOCK = 8000000
    ; The display seems to be reconfigurable, default is 240x100
    defc    CONSOLE_COLUMNS = 30
    defc    CONSOLE_ROWS = 12

    defc    TAR__register_sp = 0xdf00
    defc    CRT_ORG_BSS = 0xc000	
    defc    CRT_ORG_CODE = 0x8000
ENDIF



    EXTERN  asm_lcd_init



    defc    CRT_KEY_DEL = 127
    defc    TAR__fputc_cons_generic = 1
    defc    TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__crt_on_exit = 0            ;Jump to 0 when finished
    defc    TAR__crt_enable_eidi = $02      ;Enable ei on startup 

    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

    ; Cartridge header
    defb    0x55, 0xaa      ;Cartridge

    ;defb	0x47, 0x41		;Normal cartridge
    ;defb	0x33, 0x00		;Autojump to 0x8010

    defb    'Y', 'E'        ;GL2000/4000 auto-start signature

    jp      start



start:
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"
    call    asm_lcd_init

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main
__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"


l_dcal:
    jp      (hl)            ;Used for function pointer calls

    INCLUDE "crt/classic/crt_runtime_selection.inc" 

    defc	__crt_org_bss = CRT_ORG_BSS
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF
    INCLUDE	"crt/classic/crt_section.inc"

