;       Startup Code for Sega Master System
;
;    Haroldo O. Pinheiro February 2006
;
;    $Id: sms_crt0.asm,v 1.20 2016-07-13 22:12:25 dom Exp $
;

    DEFC    CODE_Start = $0100
    DEFC    RAM_Start  = $C000
    DEFC    RAM_Length = $2000


    MODULE  sms_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    INCLUDE     "target/sms/def/sms.def"

;-------
; Some general scope declarations
;-------

    EXTERN    _main           ;main() is always external to crt0 code
    PUBLIC    __Exit         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)

        
    PUBLIC    raster_procs    ;Raster interrupt handlers
    PUBLIC    pause_procs    ;Pause interrupt handlers
    
    PUBLIC    _timer         ;This is incremented every time a VBL/HBL interrupt happens
    PUBLIC    _pause_flag    ;This alternates between 0 and 1 every time pause is pressed
    

    PUBLIC  __GAMEGEAR_ENABLED

    PUBLIC __IO_VDP_DATA
    PUBLIC __IO_VDP_COMMAND
    PUBLIC __IO_VDP_STATUS
    PUBLIC  __IO_SN76489_PORT

    EXTERN  clear_vram

IF __GAMEGEAR__
    defc CONSOLE_XOFFSET = 6
    defc CONSOLE_YOFFSET = 3
    defc CONSOLE_COLUMNS = 20
    defc CONSOLE_ROWS = 18
    defc __GAMEGEAR_ENABLED = 1
ELSE
    defc __GAMEGEAR_ENABLED = 0
    defc CONSOLE_COLUMNS = 32
  IF !DEFINED_CONSOLE_ROWS
    defc CONSOLE_ROWS = 24
  ENDIF
ENDIF

    EXTERN  __tms9918_status_register
    PUBLIC  __SMSlib_VDPFlags
    defc    __SMSlib_VDPFlags = __tms9918_status_register
    

    defc    CRT_ORG_CODE        = 0
    defc    TAR__register_sp    = $dff0
    defc    TAR__clib_exit_stack_size = 32
    defc    __CPU_CLOCK = 3580000
    defc    TAR__crt_enable_nmi = 1

    INCLUDE "crt/classic/crt_rules.inc"


    org     CRT_ORG_CODE

    jp      start

    defs 0x0008 - ASMPC
if (ASMPC<>$0008)
    defs    CODE_ALIGNMENT_ERROR
endif

   PUBLIC _SMS_crt0_RST08
   PUBLIC __RST08_SMS_crt0_RST08

_SMS_crt0_RST08:               ; Restart 08h - write HL to VDP Control Port
__RST08_SMS_crt0_RST08:
    ld      c,__IO_VDP_COMMAND
    di                          ; make it interrupt SAFE
    out     (c),l
    out     (c),h
    ei
    ret

    defm "Z88DK"
   
    defs 0x0018 - ASMPC
if (ASMPC<>$0018)
    defs    CODE_ALIGNMENT_ERROR
endif
    PUBLIC _SMS_crt0_RST18
    PUBLIC __RST18_SMS_crt0_RST18

_SMS_crt0_RST18:               ; Restart 18h - write HL to VDP Data Port
__RST18_SMS_crt0_RST18:
    ld      a,l                      ; (respecting VRAM time constraints)
    out     (__IO_VDP_DATA),a        ; 11
    ld      a,h                      ; 4
    sub     0                        ; 7
    nop                              ; 4 = 26 (VRAM SAFE)
    out     (__IO_VDP_DATA),a
    ret

IF ((__crt_enable_rst & $20) = $20)
    IF ((__crt_enable_rst & $2020) = $0020)
        EXTERN  _z80_rst_28h
    ENDIF
        jp      _z80_rst_28h
ELSE
        ret
ENDIF

    defs    $0030-ASMPC
if (ASMPC<>$0030)
    defs    CODE_ALIGNMENT_ERROR
endif

IF ((__crt_enable_rst & $40) = $40)
    IF ((__crt_enable_rst & $4040) = $0040)
        EXTERN  _z80_rst_30h
    ENDIF
        jp      _z80_rst_30h
ELSE
        ret
ENDIF

    defs    $0038-ASMPC
if (ASMPC<>$0038)
    defs    CODE_ALIGNMENT_ERROR
endif

    
;-------        
; Interrupt handlers
;-------

int_RASTER: 
    push    af 
    push    hl
    in      a, ($BF)
    ld      (__tms9918_status_register),a
    or      a 
    jp      p, int_not_VBL  ; Bit 7 not set 

IFDEF CLIB_SMSLIB
    call    int_SMSLIB
ENDIF

    ; __SMSLIB_ENABLE_MDPAD and other readings
;int_VBL: 
    ld      hl, (_timer)
    inc     hl
    ld      (_timer), hl
    ld      hl, raster_procs 
    call    int_handler 
interrupt_exit:
    pop     hl
    pop     af
    ei
    ret

int_not_VBL: 
   ld       hl,(__SMSlib_theLineInterruptHandler)
   call     call_int_handler
   jr       interrupt_exit



    defs    $0066-ASMPC
IF (ASMPC<>$0066)
    defs    CODE_ALIGNMENT_ERROR
ENDIF

IF (__crt_enable_nmi = 1)
    EXTERN _z80_nmi
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
ELSE 
  IF (__crt_enable_nmi > 1)
    jp     __z80_nmi
  ELSE
    retn
  ENDIF
ENDIF



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
l_dcal:
    jp      (hl) 

;-------        
; Beginning of the actual code
;-------
    defs    (CODE_Start - ASMPC)
IF (ASMPC<>CODE_Start)
    defs    CODE_ALIGNMENT_ERROR
ENDIF

start:
    INCLUDE "crt/classic/crt_init_sp.inc"
    ld      hl,RAM_Start
    ld      de,RAM_Start+1
    ld      bc,RAM_Length-1
    ld      (hl),0
    ldir
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

    call    DefaultInitialiseVDP
    call    clear_vram
    
    im      1
    ei
    call    _main

__Exit:
    push    hl
    call    crt0_exit
endloop:
    jr      endloop


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
    PUBLIC  l_ret
l_ret:
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
    defb (__SMS_VRAM_SCREEN_MAP_ADDRESS/1024) |@11110001,$82 
    defb $FF,$83 
    defb $FF,$84 
    defb (__SMS_VRAM_SPRITE_ATTRIBUTE_TABLE_ADDRESS/128)|@10000001,$85 
IF CLIB_SMSLIB
    defb ((__SMS_VRAM_SPRITE_PATTERN_BASE_ADDRESS & 0x2000) >> 11) + 0xfb, 0x86
ELSE
    defb ((__SMS_VRAM_SPRITE_PATTERN_BASE_ADDRESS_CLASSIC & 0x2000) >> 11) + 0xfb, 0x86
ENDIF
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


IFDEF CLIB_SMSLIB

    EXTERN  __SMSlib_VDPBlank
    EXTERN  __SMSlib_KeysStatus
    EXTERN  __SMSlib_PreviousKeysStatus

int_SMSLIB:
IFNDEF CLIB_SMSLIB_MDPAD
   ld hl,__SMSlib_VDPBlank
   ld (hl),1
   
   ld hl,(__SMSlib_KeysStatus)
   ld (__SMSlib_PreviousKeysStatus),hl
   
   in a,(__IO_JOYSTICK_READ_L)
   cpl
   ld (__SMSlib_KeysStatus),a
   
   in a,(__IO_JOYSTICK_READ_H)
   cpl
   ld (__SMSlib_KeysStatus + 1),a
ELSE
    defc TH_HI = 0xf5
    defc TH_LO = 0xd5

   ld hl,__SMSlib_VDPBlank
   ld (hl),1
   
   ld hl,(__SMSlib_KeysStatus)
   ld (__SMSlib_PreviousKeysStatus),hl
   
   ld hl,(__SMSlib_MDKeysStatus)
   ld (__SMSlib_PreviousMDKeysStatus),hl
   
   ld a,TH_HI
   out (__IO_JOYSTICK_PORT_CONTROL),a

   in a,(__IO_JOYSTICK_READ_L)
   cpl
   ld l,a
   
   in a,(__IO_JOYSTICK_READ_H)
   cpl
   ld h,a
   
   ld (__SMSlib_KeysStatus),hl
   
   ld a,TH_LO
   out (__IO_JOYSTICK_PORT_CONTROL),a
   
   in a,(__IO_JOYSTICK_READ_L)
   
   ld h,0
   ld l,a

   ; hl = MDKeysStatus
   
   and 0x0c
   jr z, read

   ld l,h
   jr set_MDKeysStatus

read:
   
   ld a,l
   cpl
   and 0x30
   ld l,a
   
   ld a,TH_HI
   out (__IO_JOYSTICK_PORT_CONTROL),a
   
   ld a,TH_LO
   out (__IO_JOYSTICK_PORT_CONTROL),a
   
   in a,(__IO_JOYSTICK_READ_L)
   and 0x0f
   jr nz, set_MDKeysStatus
   
   ld a,TH_HI
   out (__IO_JOYSTICK_PORT_CONTROL),a
   
   in a,(__IO_JOYSTICK_READ_L)
   cpl
   and 0x0f
   or l
   ld l,a
   
   ld a,TH_LO
   out (__IO_JOYSTICK_PORT_CONTROL),a

set_MDKeysStatus:

   ld (__SMSlib_MDKeysStatus),h
ENDIF
   ret
ENDIF



    INCLUDE "crt/classic/crt_runtime_selection.inc"

    ; And include handling disabling screenmodes
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_disable.inc"

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
    INCLUDE    "crt/classic/crt_section.inc"


IF CRT_ENABLE_BANKED_CALLS = 1
        SECTION bss_driver
mainsp:         defw    0
tempstack:      defs    CLIB_BANKING_STACK_SIZE
__current_bank: defb    2

        SECTION data_driver
tempsp: defw    tempstack + CLIB_BANKING_STACK_SIZE
ENDIF

        SECTION bss_crt

        PUBLIC  __SMSlib_PauseRequested
        PUBLIC  __SMSlib_theLineInterruptHandler

raster_procs:       defs    16    ;Raster interrupt handlers
pause_procs:        defs    16    ;Pause interrupt handlers
_timer:             defw    0    ;This is incremented every time a VBL interrupt happens
__SMSlib_PauseRequested:
_pause_flag:        defb    0    ;This alternates between 0 and 1 every time pause is pressed
__gamegear_flag:    defb    0    ;Non zero if running on a gamegear

__SMSlib_theLineInterruptHandler:
                    defw    l_ret


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

    SECTION UNASSIGNED
    org 0
