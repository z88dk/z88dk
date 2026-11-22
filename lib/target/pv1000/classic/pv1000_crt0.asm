;
;	Startup for Casio PV-1000
;
;	The font is located from address 00000H - 01BFFH
;	- 32 bytes per character - 224 characters max
;	We need some space for startup etc, so initial characters
;	aren't available


    module  pv1000_crt0 


;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN  _main           ;main() is always external to crt0 code


    PUBLIC  __Exit         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)

    ; 2 columns on left and 2 column on right are lost
    defc    CONSOLE_COLUMNS = 28
    defc    CONSOLE_ROWS = 24

    ; 256 bytes at bb00
    ; 1024 bytes at bc00 - shared with RAM character generator
    defc    CRT_ORG_BSS = 0xbb00	
    defc    CRT_ORG_CODE = 0x0000

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0xc000
    defc    CRT_KEY_DEL = 127
    defc    __CPU_CLOCK = 3579000

    IF !DEFINED_CLIB_FOPEN_MAX
        DEFC    DEFINED_CLIB_FOPEN_MAX = 1
        DEFC    CLIB_FOPEN_MAX = 3
    ENDIF


    defc    TAR__crt_enable_rst = $8080
    defc    _z80_rst_38h = pv1000_im1_handler

    ; The machine doesn't have NMI
    defc    TAR__crt_enable_nmi = 0

    defc    TAR__crt_on_exit = 0x10001      ;Loop forever
    defc    TAR__crt_enable_eidi = $02      ;Enable ei on startup 

    INCLUDE "crt/classic/crt_rules.inc"

    ; Default values for registers
    defc    REGFF_VALUE = $10

    org	    CRT_ORG_CODE

if (ASMPC<>$0000)
    defs    CODE_ALIGNMENT_ERROR
endif
    di
    jp      program

    INCLUDE "crt/classic/crt_z80_rsts.inc"

program:
    im      1
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    call    init_hardware

    ld      hl, $b800
    ld      de, $b800+1
    ld      bc, +(32*24)-1
    ld      (hl), 32
    ldir


    INCLUDE "crt/classic/crt_init_atexit.inc"
    INCLUDE "crt/classic/crt_init_heap.inc"

    ;; Setup the keyscan variables/routines
    ld      hl,__keyscan_vals
    ld      (current_key),hl
    ld      b,4
init_keytable:
    ld      (hl),0xff
    inc     hl
    djnz    init_keytable
    ld      a,1
    ld      (scanrow),a
    out     ($fd),a
    INCLUDE "crt/classic/crt_init_eidi.inc"
    call    _main
__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"


l_dcal: jp      (hl)            ;Used for function pointer calls

init_hardware:
    ld      b,8
    ld      hl,hardware_initvals
    ld      c,$f7
initloop:
    inc     c
    outi
    jr      nz,initloop
    ret

; Data for initialising the hardware
hardware_initvals:
    defb    $ff     ;->f8   square 1
                    ;7  bit  0
                    ;..PP PPPP
                    ;  || ||||
                    ;  ++-++++--- Period for first square wave.
    defb    $ff     ;->f9 square 2
                    ;Same as Square 1, but approximately 3dB louder.
    defb    $ff     ;->fa square 3
                    ;Same as Square 1, but approximately 6dB louder.
    defb    $02     ;->fb sound control
                    ;7  bit  0
                    ;.... ..ES
                    ;       ||
                    ;       |+--- 0: Normal
                    ;       |     1: XOR/ring modulation
                    ;       +---- 0: Mute
                    ;             1: Sound audible

    defb    $02     ;->fc   Interrupt (once per vblank)
                    ;Write:
                    ;7  bit  0
                    ;.... ..MP
                    ;       ||
                    ;       |+--- 1: enable prerender IRQ (1/vblank) 
                    ;       +---- 1: enable matrix scan IRQ (16/vblank)
                    ;Read:
                    ;7  bit  0
                    ;ZAAA BBMP
                    ;|||| ||||
                    ;|||| |||+-- 1: prerender IRQ is cause of interrupt, cleared by write to port $FD
                    ;|||| ||+--- 1: matrix scan IRQ is cause of interrupt, cleared by read from port $FD
                    ;|||| ++---- Player 2 joystick inputs, same as reading from $FD
                    ;|+++------- Always 0
                    ;+---------- Always 1 (Probably pulled up by resistor next to Z80)

    defb    $00     ;->fd  
                    ;Write:
                    ;7  bit  0
                    ;.AAA BBBB
                    ; ||| ||||
                    ; ||| ++++-- 4 general purpose outputs, accessible via both controller ports
                    ; +++------- Strongly implied to exist on the gate array, but not accessible externally
                    ;Read:
                    ;7  bit  0
                    ;ZAAA BBCC
                    ;|||| ||||
                    ;|||| ||++-- 2 general purpose inputs for reading the player 1 joystick
                    ;|||| ++---- 2 general purpose inputs for reading the player 2 joystick
                    ;|+++------- Always 0. (Strongly implied to exist on the gate array, but grounded there)
                    ;+---------- Always 1. (Probably pulled up by resistor next to Z80)
    defb    $b8     ;->fe   ;VDP    (VRAM address = 0xb800)
                    ;Write:
                    ;7  bit  0
                    ;BBBB AA..
                    ;|||| ||
                    ;++++-++---- Address A15-A10 from where to fetch the tilemap. 
                    ;||||        Almost all software write $B8, meaning the gate array fetches tilemap from $B802 through $BAFD.
                    ;++++------- Address A15-A12 from where to fetch pattern RAM tiles (A11-A10 always 1)
                    ;            The common value of $B8 means that gate array fetches data for tiles $E0-$FF from $BC08-$BFFF
    defb    REGFF_VALUE 
                    ;->ff   ;VDP (force ROM patterns), patterns start at 0x0000
                    ;7  bit  0
                    ;AAAD FBGR
                    ;|||| ||||
                    ;|||| |+++-- Border color. (0=black, 1=red, 2=green, 3=yellow, 4=blue, &c).
                    ;|||| +----- 1: Display disable. (Screen solid border color, faster Z80)
                    ;|||+------- Pattern RAM disable 
                    ;|||          (0: Tiles $E0-$FF are fetched from address specified by port $FE
                    ;|||           1: Tiles $E0-$FF are fetched from address specified by port $FF)
                    ;+++-------- Address A15-A13 from where to fetch patterns
                    ;             (0: Patterns are fetched from $0008-$1BFF or -$1FFF
                    ;              1: starting at $2008
                    ;              2: starting at $4008 &c

    EXTERN   tick_count_isr
pv1000_im1_handler:
    push    af
    push    hl
    in      a,($fc) 
    bit     1,a
    jr      z,intreturn
    ld      a,(divide)
    inc     a
    and     15
    ld      (divide),a
    call    z,tick_count_isr
    call    read_keypad
intreturn:    
    pop     hl
    pop     af
    ei
    reti


read_keypad:
    in      a,($fd)
    ld      hl,(current_key)
    ld      (hl),a
    inc     hl
    ld      a,(scanrow)
    add     a
    and     15
    jr      nz,read_not_reset
    ld      a,1
    ld      hl,__keyscan_vals
read_not_reset:
    ld      (current_key),hl
    ld      (scanrow),a
    out     ($fd),a
    ret



; Font location - this is far too generous - we should add in extra
; symbols
    defs    10 * 32-ASMPC
if (ASMPC<>(10 * 32))
    defs    CODE_ALIGNMENT_ERROR
endif

    ; Lores graphics
    SECTION pv1000_lores
IF PV1000_CUSTOM_LORES = 2
    ; Do nothing
ELIF PV1000_CUSTOM_LORES
    INCLUDE	"pv1000_lores.asm"
ELSE
    INCLUDE	"target/pv1000/classic/lores.asm"
ENDIF

    SECTION pv1000_tileset
    ; Character map - TODO, redefining it
IF PV1000_CUSTOM_TILESET = 2
    ; Do nothing
ELIF PV1000_CUSTOM_TILESET
    INCLUDE	"tileset.asm"
ELSE
    INCLUDE	"target/pv1000/classic/font.asm"
ENDIF




    INCLUDE "crt/classic/crt_runtime_selection.inc" 

    defc	__crt_org_bss = CRT_ORG_BSS
IF DEFINED_CRT_MODEL
    defc __crt_model = CRT_MODEL
ELSE
    defc __crt_model = 1
ENDIF
    INCLUDE	"crt/classic/crt_section.inc"

    SECTION bss_crt

    PUBLIC  __keyscan_vals

divide:         defb    0       ;To cut the interrupt down
current_key:    defw    0       ;Point to slot we're reading
scanrow:        defb    0       ;Which scan row
__keyscan_vals: defs    4       ;And the read values

    SECTION data_crt

    PUBLIC pv1000_regff
pv1000_regff:    defb     REGFF_VALUE
