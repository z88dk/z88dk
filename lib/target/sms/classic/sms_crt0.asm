;       Startup Code for Sega Master System
;
;    Haroldo O. Pinheiro February 2006
;
;    $Id: sms_crt0.asm,v 1.20 2016-07-13 22:12:25 dom Exp $
;

    DEFC    ROM_Start  = $0000
    DEFC    INT_Start  = $0038
    DEFC    NMI_Start  = $0066
    DEFC    CODE_Start = $0100
    DEFC    RAM_Start  = $C000
    DEFC    RAM_Length = $2000
    DEFC    Stack_Top  = $dff0


    MODULE  sms_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

    EXTERN    _main           ;main() is always external to crt0 code
    PUBLIC    cleanup         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)

        
    PUBLIC    raster_procs    ;Raster interrupt handlers
    PUBLIC    pause_procs    ;Pause interrupt handlers
    
    PUBLIC    _timer         ;This is incremented every time a VBL/HBL interrupt happens
    PUBLIC    _pause_flag    ;This alternates between 0 and 1 every time pause is pressed
    

    PUBLIC  __GAMEGEAR_ENABLED

    PUBLIC __IO_VDP_DATA
    PUBLIC __IO_VDP_COMMAND
    PUBLIC __IO_VDP_STATUS
    defc __IO_VDP_DATA              = 0xbe
    defc __IO_VDP_COMMAND           = 0xbf
    defc __IO_VDP_STATUS            = 0xbf

    if __GAMEGEAR__
        defc CONSOLE_XOFFSET = 6
        defc CONSOLE_YOFFSET = 3
        defc CONSOLE_COLUMNS = 20
        defc CONSOLE_ROWS = 18
        defc __GAMEGEAR_ENABLED = 1
    else
        defc __GAMEGEAR_ENABLED = 0
        defc CONSOLE_COLUMNS = 32
IF !DEFINED_CONSOLE_ROWS
        defc CONSOLE_ROWS = 24
ENDIF
    endif

    EXTERN  __tms9918_status_register


    defc    TAR__register_sp = Stack_Top
    defc    TAR__clib_exit_stack_size = 32
    defc    __CPU_CLOCK = 3580000

    INCLUDE "crt/classic/crt_rules.inc"


    org    ROM_Start

    jp    start
    
    defm    "Sega Master System - Small C+"
    
;-------        
; Interrupt handlers
;-------
filler1:
    defs    (INT_Start - filler1)

int_RASTER: 
    push    af 

    in      a, ($BF)
    ld      (__tms9918_status_register),a
    or      a 
    jp      p, int_not_VBL  ; Bit 7 not set 

;int_VBL: 
    push    hl 
    ld      hl, (_timer)
    inc     hl
    ld      (_timer), hl
    ld      hl, raster_procs 
    call    int_handler 
    pop     hl 

int_not_VBL: 
    pop     af 
    ei 
    ret 

filler2: 
    defs    (NMI_Start - filler2) 
int_PAUSE: 
    push    af 
    push    hl 
    ld      hl, _pause_flag 
    ld      a, (hl) 
    xor     a, 1 
    ld      (hl), a 
    ld      hl, pause_procs 
    call    int_handler 
    pop     hl 
    pop     af 
    retn 

int_handler: 
    push    bc 
    push    de 
int_loop: 
    ld      a, (hl) 
    inc     hl 
    or      (hl) 
    jr      z, int_done 
    push    hl 
    ld      a, (hl) 
    dec     hl 
    ld      l, (hl) 
    ld      h, a 
    call    call_int_handler 
    pop     hl 
    inc     hl 
    jr      int_loop 
int_done: 
    pop     de 
    pop     bc 
    ret 

call_int_handler: 
    jp      (hl) 

;-------        
; Beginning of the actual code
;-------
filler3:
    defs    (CODE_Start - filler3)

start:
;    Make room for the atexit() stack
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
; Clear static memory
    ld      hl,RAM_Start
    ld      de,RAM_Start+1
    ld      bc,RAM_Length-1
    ld      (hl),0
    ldir
    call    crt0_init_bss
    ld      (exitsp),sp

    
    call    DefaultInitialiseVDP
    
    im      1
    ei
    call    _main

cleanup:
    push    hl
    call    crt0_exit
endloop:
    jr      endloop
l_dcal:
    jp      (hl)
    
;---------------------------------
; VDP Initialization
;---------------------------------
DefaultInitialiseVDP:
    ld      hl,_Data
    ld      b,_End-_Data
    ld      c,$bf
    otir
IF __GAMEGEAR__
    ; Load default palette for gamegear
    EXTERN asm_load_palette_gamegear
    ld      hl,gg_palette
    ld      b,16
    ld      c,0
    call    asm_load_palette_gamegear
ENDIF
    ret

IF __GAMEGEAR__
gg_palette:
    defw 0x0000             ;transparent
    defw 0x0000             ;00 00 00
    defw 0x00a0             ;00 aa 00
    defw 0x00f0             ;00 ff 00
    defw 0x0500             ;00 00 55
    defw 0x0f00             ;00 00 ff
    defw 0x0005             ;55 00 00
    defw 0x0ff0             ;00 ff ff
    defw 0x000a             ;aa 00 00
    defw 0x000f             ;ff 00 00
    defw 0x0055             ;00 55 55
    defw 0x00ff             ;ff ff 00
    defw 0x0050             ;00 55 00
    defw 0x0f0f             ;ff 00 ff
    defw 0x0555             ;55 55 55
    defw 0x0fff             ;ff ff ff
ENDIF

    DEFC SpriteSet          = 0       ; 0 for sprites to use tiles 0-255, 1 for 256+
    DEFC NameTableAddress   = $3800   ; must be a multiple of $800; usually $3800; fills $700 bytes (unstretched)
    DEFC SpriteTableAddress = $3f00   ; must be a multiple of $100; usually $3f00; fills $100 bytes

_Data: 
    defb @00000110,$80
    ;     |||||||`- Disable synch 
    ;     ||||||`-- Enable extra height modes 
    ;     |||||`--- SMS mode instead of SG 
    ;     ||||`---- Shift sprites left 8 pixels 
    ;     |||`----- Enable line interrupts 
    ;     ||`------ Blank leftmost column for scrolling 
    ;     |`------- Fix top 2 rows during horizontal scrolling 
    ;     `-------- Fix right 8 columns during vertical scrolling 
    defb @10000000,$81 
    ;      |||| |`- Zoomed sprites -> 16x16 pixels 
    ;      |||| `-- Doubled sprites -> 2 tiles per sprite, 8x16 
    ;      |||`---- 30 row/240 line mode 
    ;      ||`----- 28 row/224 line mode 
    ;      |`------ Enable VBlank interrupts 
    ;      `------- Enable display 
    defb (NameTableAddress/1024) |@11110001,$82 
    defb $FF,$83 
    defb $FF,$84 
    defb (SpriteTableAddress/128)|@10000001,$85 
    defb (SpriteSet/2^2)         |@11111011,$86
    defb $f|$f0,$87 
    ;     `-------- Border palette colour (sprite palette) 
    defb $00,$88 
    ;     ``------- Horizontal scroll 
    defb $00,$89 
    ;     ``------- Vertical scroll 
    defb $ff,$8a 
    ;     ``------- Line interrupt spacing ($ff to disable) 
_End:

IF CRT_ENABLE_BANKED_CALLS = 1
    GLOBAL  banked_call
    defc    MAPPER_ADDRESS_8000 = 0xffff

banked_call:
    pop     hl              ; Get the return address
    ld      (mainsp),sp
    ld      sp,(tempsp)
    ld      a,(__current_bank)
    push    af              ; Push the current bank onto the stack
    ld      e,(hl)          ; Fetch the call address
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      a,(hl)          ; ...and page
    inc     hl
    inc     hl              ; Yes this should be here
    push    hl              ; Push the real return address
    ld      (tempsp),sp
    ld      sp,(mainsp)
    ld      (__current_bank),a
    ld      (MAPPER_ADDRESS_8000),a
    ld      l,e
    ld      h,d
    call    l_dcal          ; jp(hl)
    ld      (mainsp),sp
    ld      sp,(tempsp)
    pop     bc              ; Get the return address
    pop     af              ; Pop the old bank
    ld      (tempsp),sp
    ld      sp,(mainsp)
    ld      (__current_bank),a
    ld      (MAPPER_ADDRESS_8000),a
    push    bc
    ret
ENDIF

    INCLUDE "crt/classic/crt_runtime_selection.asm"

    ; And include handling disabling screenmodes
    INCLUDE "crt/classic/tms9918/mode_disable.asm"

    IF DEFINED_CRT_ORG_BSS
        defc __crt_org_bss = CRT_ORG_BSS
    ELSE
        defc __crt_org_bss = RAM_Start
    ENDIF


    ; If we were given a model then use it
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF
    INCLUDE    "crt/classic/crt_section.asm"


IF CRT_ENABLE_BANKED_CALLS = 1
        SECTION bss_driver
mainsp: defw    0
tempstack:      defs    CLIB_BANKING_STACK_SIZE
__current_bank: defb    2

        SECTION data_driver
tempsp: defw    tempstack + CLIB_BANKING_STACK_SIZE
ENDIF

        SECTION bss_crt
raster_procs:       defs    16    ;Raster interrupt handlers
pause_procs:        defs    16    ;Pause interrupt handlers
_timer:             defw    0    ;This is incremented every time a VBL interrupt happens
_pause_flag:        defb    0    ;This alternates between 0 and 1 every time pause is pressed
__gamegear_flag:    defb    0    ;Non zero if running on a gamegear


    ; DEFINE SECTIONS FOR BANKSWITCHING
    ; consistent with appmake and new c library

   IFNDEF CRT_ORG_BANK_02
      defc CRT_ORG_BANK_02 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_03
      defc CRT_ORG_BANK_03 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_04
      defc CRT_ORG_BANK_04 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_05
      defc CRT_ORG_BANK_05 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_06
      defc CRT_ORG_BANK_06 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_07
      defc CRT_ORG_BANK_07 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_08
      defc CRT_ORG_BANK_08 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_09
      defc CRT_ORG_BANK_09 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0A
      defc CRT_ORG_BANK_0A = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0B
      defc CRT_ORG_BANK_0B = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0C
      defc CRT_ORG_BANK_0C = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0D
      defc CRT_ORG_BANK_0D = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0E
      defc CRT_ORG_BANK_0E = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0F
      defc CRT_ORG_BANK_0F = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_10
      defc CRT_ORG_BANK_10 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_11
      defc CRT_ORG_BANK_11 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_12
      defc CRT_ORG_BANK_12 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_13
      defc CRT_ORG_BANK_13 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_14
      defc CRT_ORG_BANK_14 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_15
      defc CRT_ORG_BANK_15 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_16
      defc CRT_ORG_BANK_16 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_17
      defc CRT_ORG_BANK_17 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_18
      defc CRT_ORG_BANK_18 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_19
      defc CRT_ORG_BANK_19 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1A
      defc CRT_ORG_BANK_1A = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1B
      defc CRT_ORG_BANK_1B = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1C
      defc CRT_ORG_BANK_1C = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1D
      defc CRT_ORG_BANK_1D = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1E
      defc CRT_ORG_BANK_1E = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1F
      defc CRT_ORG_BANK_1F = 0x8000
   ENDIF


    SECTION BANK_02
    org $020000 + CRT_ORG_BANK_02
    SECTION CODE_2
    SECTION RODATA_2

    SECTION BANK_03
    org $030000 + CRT_ORG_BANK_03
    SECTION CODE_3
    SECTION RODATA_3

    SECTION BANK_04
    org $040000 + CRT_ORG_BANK_04
    SECTION CODE_4
    SECTION RODATA_4

    SECTION BANK_05
    org $050000 + CRT_ORG_BANK_05
    SECTION CODE_5
    SECTION RODATA_5

    SECTION BANK_06
    org $060000 + CRT_ORG_BANK_06
    SECTION CODE_6
    SECTION RODATA_6

    SECTION BANK_07
    org $070000 + CRT_ORG_BANK_07
    SECTION CODE_7
    SECTION RODATA_7

    SECTION BANK_08
    org $080000 + CRT_ORG_BANK_08
    SECTION CODE_8
    SECTION RODATA_8

    SECTION BANK_09
    org $090000 + CRT_ORG_BANK_09
    SECTION CODE_9
    SECTION RODATA_9

    SECTION BANK_0A
    org $0a0000 + CRT_ORG_BANK_0A
    SECTION CODE_10
    SECTION RODATA_10

    SECTION BANK_0B
    org $0b0000 + CRT_ORG_BANK_0B
    SECTION CODE_11
    SECTION RODATA_11

    SECTION BANK_0C
    org $0c0000 + CRT_ORG_BANK_0C
    SECTION CODE_12
    SECTION RODATA_12

    SECTION BANK_0D
    org $0d0000 + CRT_ORG_BANK_0D
    SECTION CODE_13
    SECTION RODATA_13

    SECTION BANK_0E
    org $0e0000 + CRT_ORG_BANK_0E
    SECTION CODE_14
    SECTION RODATA_14

    SECTION BANK_0F
    org $0f0000 + CRT_ORG_BANK_0F
    SECTION CODE_15
    SECTION RODATA_15

    SECTION BANK_10
    org $100000 + CRT_ORG_BANK_10
    SECTION CODE_16
    SECTION RODATA_16

    SECTION BANK_11
    org $110000 + CRT_ORG_BANK_11
    SECTION CODE_17
    SECTION RODATA_17

    SECTION BANK_18
    org $180000 + CRT_ORG_BANK_18
    SECTION CODE_24
    SECTION RODATA_24

    SECTION BANK_19
    org $190000 + CRT_ORG_BANK_19
    SECTION CODE_25
    SECTION RODATA_25

    SECTION BANK_1A
    org $1a0000 + CRT_ORG_BANK_1A
    SECTION CODE_26
    SECTION RODATA_26

    SECTION BANK_1B
    org $1b0000 + CRT_ORG_BANK_1B
    SECTION CODE_27
    SECTION RODATA_27

    SECTION BANK_1C
    org $1c0000 + CRT_ORG_BANK_1C
    SECTION CODE_28
    SECTION RODATA_28

    SECTION BANK_1D
    org $1d0000 + CRT_ORG_BANK_1D
    SECTION CODE_29
    SECTION RODATA_29

    SECTION BANK_1E
    org $1e0000 + CRT_ORG_BANK_1E
    SECTION CODE_30
    SECTION RODATA_30

    SECTION BANK_1F
    org $1f0000 + CRT_ORG_BANK_1F
    SECTION CODE_31
    SECTION RODATA_31
