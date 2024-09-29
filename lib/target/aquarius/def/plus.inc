;-----------------------------------------------------------------------------
; regs.inc
;
; Aquarius+ I/O Registers and Memory Banks
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; Bank and Page Definitions
;-----------------------------------------------------------------------------
BANK0_BASE:     equ $0000
BANK1_BASE:     equ $4000
BANK2_BASE:     equ $8000
BANK3_BASE:     equ $C000

PAGE_SIZE       equ $4000

BANK_READONLY:  equ $80     ; Bank readonly
BANK_OVERLAY:   equ $40     ; RAM overlay

; RAM Page Usage
ROM_SYS_PG      equ 60      ; Main System ROM, mapped into Bank 0 with overlay from $3000-$3FFF
ROM_EXT_PG      equ 61      ; plusBASIC extended ROM, mapped into Bank 3 
ROM_AUX_PG      equ 62      ; plusBASIC auxillary ROM, mapped into Bank 3 as needed
ROM_CRT_PG      equ 63      ; If a cartrige is present, it is copied here unencrypted, then executed

ROM_SYS_OV      equ 60 | BANK_READONLY | BANK_OVERLAY
ROM_EXT_RO      equ 61 | BANK_READONLY 
ROM_AUX_RO      equ 62 | BANK_READONLY 
ROM_CRT_RO      equ 63 | BANK_READONLY 

ROM_CART        equ 19

VIDEO_RAM       equ 20
CHAR_RAM        equ 21
    
RAM_BAS_0       equ 56      ; RAM for Bank 0 (character ROM cache)
RAM_BAS_1       equ 57      ; RAM for BASIC mapped into Bank 1
RAM_BAS_2       equ 58      ; RAM for BASIC mapped into Bank 2
RAM_BAS_3       equ 59      ; RAM for Bank 3 (unused by BASIC)

TMP_BUFFR       equ 50      ; Transient data buffer 
BOOT_BUFR       equ 51      ; Boot ROM work area
SCR_BUFFR       equ 52      ; Screen Buffers
VID_BUFFR       equ 53      ; Video RAM Shadow Buffer
BAS_BUFFR       equ 54      ; plusBASIC extended system variables and buffers, mapped in bank 3 as needed
PT3_BUFFR       equ 55      ; PT3 Player Buffer
    
USER_RAM        equ 32      ; First page of User RAM
USER_END        equ 49      ; Last page of User RAM

RAM_END_PG      equ 63      ; Last page of RAM

ROM_EXT_BANK    equ 3       ; Bank Extended ROM is mapped into
ROM_AUX_BANK    equ 3       ; Bank Auxillary ROM is mapped into

CHAR_ROM_AQ     equ $3000   ; Standard Aquarius Character ROM Address in System ROM
CHAR_ROM_L1     equ $3800   ; Latin-1 Aquarius Character ROM Address in System ROM

;-----------------------------------------------------------------------------
; Video RAM Offsets 
; Page 20
;-----------------------------------------------------------------------------
BMP_BASE        equ $0000
BMP_COLORRAM    equ $2000
BMP_PAL_OFS     equ 8000    ; Offset of palette data in file
BMP_FILELEN     equ 9192    ; Length of 320x200 bitmap file
TILE_DATA       equ $0000
TILE_MAP_BASE   equ $0000
TILE_MAP_LEN    equ 64*32*2


;-----------------------------------------------------------------------------
; plusBASIC System variables
;-----------------------------------------------------------------------------
; Screen RAM Hole $33E8-$33FF exists only in 40 column mode
BORDERCHR   equ $33FF   ; Border character alternate memory location (40 column mode)
; Color RAM Hole
BORDERCLR   equ $37FF   ; Border color alternate memory location

; plusBASIC temporary sysvars
; FILNAM ($3851-$3856) - CLOAD/CSAVE File Name
; FILNAF ($3857-$385C) - File Name on Tape
BUFADR      equ $3857   ; Unpack buffer address
BUFPTR      equ $3859   ; Pointer into unpacking buffer
BUFRET      equ $385B   ; unpack_line return address
BUFLEN      equ $385B   ; Buffer length

; RNDTAB ($3821-$3840) - Deprecated RND Permutation Table
BASINTPG    equ $3821   ; BASIC Interrupt Routine Page, 0=None (swapped into BANK 3)
BASINTJP    equ $3822   ; BASIC Interrupt Routine JP instruction
BASINTADR   equ $3823   ; BASIC Interrupt Routine JP Address ($3823-$3824)
BASYSCTL    equ $3825   ; System Control Bits 
IRQACTIVE   equ $3826   ; Active IRQ Routines Bits
                        ; 0: Timer
TIMERCNT    equ $3827   ; TIMER counter LSB = $3827, MSB = $3829
;Used by ON ERROR. Must be in in consecutive order: ERRLIN,ERRFLG,ONEFLG,ONELIN
ERRLIN      equ $382A   ; LINE NUMBER WHERE LAST ERROR OCCURED.
ERRFLG      equ $382C   ; USED TO SAVE THE ERROR NUMBER SO EDIT CAN BE
ONEFLG      equ $382D   ; ONEFLG=1 IF WERE ARE EXECUTING AN ERROR TRAP ROUTINE
ONELIN      equ $382E   ; THE pointer to the LINE TO GOTO WHEN AN ERROR OCCURS
EXT_FLAGS   equ $3830   ; Extended BASIC flags
MOUSEWDLT   equ $3831   ; Accumulated change in mouse delta
BAS_FDESC   equ $3832   ; ESP file descriptor to close on Error or Ctrl-C
IEND_KEY    equ $3833   ; Key pressed to end input
;         $3834-$3835   ; unused (2 bytes)
; Temporary variables used within statement code.
; FILESTAT statement
FILESIZE    equ $3838   ; File Size (32-bits $3838-$383B)
FILEATTR    equ $383C   ; File Attribute
FILEDATE    equ $383D   ; File Datestamp ($383D-$383E)
FILETIME    equ $383F   ; File Timestamp ($383F-$3840)
; SPLIT statement
SPLITDSC    equ $3838   ; String descriptor 
SPLITTRM    equ $3838   ; Segment terminator  (overwrites LSB of SPLITDSC)
SPLITSEG    equ $3839   ; Segment counter (overwrites MSB of SPLITDSC)
ARRAYADR    equ $383A   ; Array data start address 
SPLITDEL    equ $383C   ; Delimiter character
ARRAYTYP    equ $383C   ; Array Type
ARRAYPTR    equ $383D   ; Pointer into array data
ARRAYLEN    equ $383F   ; Array data length
; bitmap_get and bitmap_set
BMPMODE     equ $3837   ; Bitmap Mode 0=1bpp, 2=4bpp
STARTCOL    equ $3838
ENDCOL      equ $383A
STARTROW    equ $383C
ENDROW      equ $383E
; DEF SPRITE
XTEMP0      equ $3836   ; Used by DEF SPRITE
XTEMP1      equ $3837   ; Used by DEF SPRITE
SPRTLNUM    equ $3838   ; Spritle number
SPRTCOLS    equ $383A   ; Width in spritles
SPRTROWS    equ $383C   ; Height in spritles

; enhance editor
RIGHTCOL    equ $3838   ; Right bound (LINELEN-1)
LEFTCOL     equ $3839   ; Left bound (1)
BOTLINE     equ $383A
TOPLINE     equ $283B
LINEDELTA   equ $283C   ; LINELEN - RIGHTCOL + LEFTCOL

;-----------------------------------------------------------------------------
; Variables
;-----------------------------------------------------------------------------
BASIC_RAM_END: equ $BFFF    ; End of BASIC RAM, $BF00-$BFFF is reserved for our extensions

;-----------------------------------------------------------------------------
; Extended Tokens
;-----------------------------------------------------------------------------
XTOKEN = $FE
XPSVAR = $FF

;-----------------------------------------------------------------------------
; IO registers
;-----------------------------------------------------------------------------
IO_VCTRL:       equ $E0
IO_VSCRX_L:     equ $E1
IO_VSCRX_H:     equ $E2
IO_VSCRY:       equ $E3
IO_VSPRSEL:     equ $E4
IO_VSPRX_L:     equ $E5
IO_VSPRX_H:     equ $E6
IO_VSPRY:       equ $E7
IO_VSPRIDX:     equ $E8
IO_VSPRATTR:    equ $E9
IO_VPALSEL:     equ $EA
IO_VPALDATA:    equ $EB
IO_PCMDAC       equ $EC
IO_VLINE:       equ $EC
IO_VIRQLINE:    equ $ED
IO_IRQMASK:     equ $EE
IO_IRQSTAT:     equ $EF
IO_BANK0:       equ $F0
IO_BANK1:       equ $F1
IO_BANK2:       equ $F2
IO_BANK3:       equ $F3
IO_ESPCTRL:     equ $F4
IO_ESPDATA:     equ $F5
IO_PSG1DATA:    equ $F6
IO_PSG1ADDR:    equ $F7
IO_PSG2DATA:    equ $F8
IO_PSG2ADDR:    equ $F9
IO_KEYBUFF      equ $FA
IO_SYSCTRL:     equ $FB
IO_CASSETTE:    equ $FC
IO_CPM:         equ $FD     ; Write-only
IO_VSYNC:       equ $FD     ; Read-only
IO_PRINTER:     equ $FE
IO_SCRAMBLE:    equ $FF     ; Write-only
IO_KEYBOARD:    equ $FF     ; Read-only

VCTRL_TEXT_OFF  equ $00     ; xxxxxxx0  Disable Text Screen
VCTRL_TEXT_EN   equ $01     ; xxxxxxx1  Enable Text Screen
VCTRL_MODE_TILE equ $02     ; xxxxx01x  Select Tilemap Mode
VCTRL_MODE_BM   equ $04     ; xxxxx10x  Select 1bpp Bitmap Mode
VCTRL_MODE_MC   equ $06     ; xxxxx11x  Select 4bpp Bitmap Mode
VCTRL_SPR_EN    equ $08     ; xxxx1xxx  Enable Sprites
VCTRL_TEXT_PRIO equ $10     ; xxx1xxxx  Text Screen Priority 
VCTRL_REMAP_BC  equ $20     ; xx1xxxxx  Remap Text Border Characters
VCRTL_80COL_EN  equ $40     ; x1xxxxxx  Enable 80-column mode
VCTRL_TEXT_PAGE equ $80     ; 1xxxxxxx  Select Text Page

VCTRL_TEXT_BITS equ VCTRL_TEXT_EN + VCRTL_80COL_EN + VCTRL_TEXT_PAGE
VCTRL_TEXT_MASK equ $FF - VCTRL_TEXT_BITS
VCTRL_TEXT_DIS  equ $FF - VCTRL_TEXT_EN

SYSCTRL_XRG_DIS equ $01     ; xxxxxxx1  Disable registers $E0-$F5, $F8-$F9
SYSCTRL_PSG_DIS equ $02     ; xxxxxx1x  Disable PSGs
SYSCTRL_TURBO   equ $04     ; xxxxx1xx  Turbo mode (7.16MHz)

IRQ_VBLANK      equ $01     ; VBLANK interrupt
IRQ_VLINE       equ $02     ; Video LINE interrupt

;-----------------------------------------------------------------------------
; BASIC Extended character ROM buffers
; Page 56 (RAM_BAS_0) 
; See screen_swap.asm
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; BASIC Extended System Constants, Variables and Buffers
; Page 54 (BAS_BUFFR), swapped into Bank 3
;-----------------------------------------------------------------------------
; Page 54 (BAS_BUFFR), swapped into Bank 3
BASBUF_BASE equ $C000   ; Base Address of BASIC Buffers
SCRNVBASE   equ $0000   ; Screen variable buffers (see screen.inc)
GFXVBASE    equ $0100   ; GFX SysVar Base, 256 byte aligned (see gfxvars.asm)
FKEYDEFS    equ $0200   ; Function Key Definitions (32 bytes each)
FKEYBASE    equ BASBUF_BASE + FKEYDEFS
;         $0500-$07FF   ; Unused
RUNARGS     equ $0800   ; RUN arguments (see run_args in args.asm)
RUNARGEND   equ $09FF   ; End of RUN arguments
;         $1000-$2FFF   ; Unused
DEFCHRSET   equ $3000   ; Page Offset: Default Character Set Buffer
ALTCHRSET   equ $3800   ; Page Offset: Custom Character Set Buffer
CHRSETLEN   equ 2048    ; Size of character set ROM
ASCSETLEN   equ 768     ; Size of ASCII character set (' ' - DEL)
; BASIC interpreter control flags
BASOUTBUF   equ $01     ; BASYSCTL: redirect OUTput to BUFfer
BASSAVASC   equ $02     ; BASYSCTL: Default SAVe to ASC
BASKEYRPT   equ $04     ; BASYSCTL: KEY RePeaT on
BASCHRSET   equ $08     ; BASYSCTL: Character set in use (0 or 1)
BASCHRMOD   equ $10     ; BASYSCTL: Character set in use has been modified
BASBRKOFF   equ $20     ; BASYSCTL: BReak OFF (Disable Ctrl-C)
BASLPRNTR   equ $40     ; BASYSCTL: LPRINT device: (0 = Serial, 1 = ESP)
BASCRNCLR   equ $80     ; BASYSCTL: PRINT updates Color RAM
; Screen Control Bitmask
BASCRNCTL   equ BASCHRSET + BASCRNCLR
BASCRNMSK   equ $FF - BASCRNCTL
; Bitmap graphics mode: see gfx.asm for details
GFXM_TEXT   equ $00     ; EXT_FLAGS: 40 colum mode (bloxels) 
GFXM_WIDE   equ $01     ; EXT_FLAGS: 80 colum mode (bloxels) 
GFXM_1BPP   equ $02     ; EXT_FLAGS: Bitmap mode (1bpp)
GFXM_4BPP   equ $03     ; EXT_FLAGS: Bitmap mode (4bpp)
GFXM_MASK   equ $03     ; Graphics mode bit mask
GFXBUFLAG   equ $04     ; EXT_FLAGS: Bitmap operations are buffered
GFXSETMSK   equ $F8     ; Mask for writing EXT_FLAGS
; BASIC extended control flags
BASOUTOVR   equ $10     ; EXT_FLAGS: Allow OUT to all ports
PT3_LOOPS   equ $20     ; EXT_FLAGS: PT3 songs repeat
FERR_FLAG   equ $40     ; EXT_FLAGS: File operations generate BASIC errors
TRON_FLAG   equ $80     ; EXT_FLAGS: Trace on/off

DFLTATTRS   equ $06     ; Default screen colors - Black on Cyan

;-----------------------------------------------------------------------------
; IRQACTIVE Bits
;-----------------------------------------------------------------------------
IRQ_TIMER   equ $01     ; Bit 0 - Timer active
IRQ_PT3PLAY equ $02     ; Bit 1 - PT3 Player running

;-----------------------------------------------------------------------------
; PT3 Player
;-----------------------------------------------------------------------------
PT3_BASE    equ $C000
pt3init     equ PT3_BASE+$00    ; StartPlayer
pt3tick     equ PT3_BASE+$03    ; PlayQuark  
pt3stat     equ PT3_BASE+$06    ; CHECKLP
pt3mute     equ PT3_BASE+$09    ; MUTE
pt3fast     equ PT3_BASE+$0C    ; SetMode
pt3mode     equ PT3_BASE+$0F    ; GetMode
pt3song     equ $0A00           ; PT3 file load address

;-----------------------------------------------------------------------------
; Macros
;-----------------------------------------------------------------------------
SYNCHK macro value
    rst     SYNCHR
    db      value
endm

;-----------------------------------------------------------------------------
; ESP32 commands
;-----------------------------------------------------------------------------
ESPCMD_RESET:      equ $01     ; Reset ESP
ESPCMD_VERSION:    equ $02     ; Get version string
ESPCMD_DATETIME    equ $03     ; Get current date and time
ESPCMD_KEYMODE     equ $08     ; Set keyboard buffer mode
ESPCMD_GETMOUSE    equ $0C     ; Get mouse position and button state
ESPCMD_GETGAMECTRL equ $0E     ; Get wireless game controller status
ESPCMD_OPEN:       equ $10     ; Open / create file
ESPCMD_CLOSE:      equ $11     ; Close open file
ESPCMD_READ:       equ $12     ; Read from file
ESPCMD_WRITE:      equ $13     ; Write to file
ESPCMD_SEEK:       equ $14     ; Move read/write pointer
ESPCMD_TELL:       equ $15     ; Get current read/write
ESPCMD_OPENDIR:    equ $16     ; Open directory
ESPCMD_CLOSEDIR:   equ $17     ; Close open directory
ESPCMD_READDIR:    equ $18     ; Read from directory
ESPCMD_DELETE:     equ $19     ; Remove file or directory
ESPCMD_RENAME:     equ $1A     ; Rename / move file or directory
ESPCMD_MKDIR:      equ $1B     ; Create directory
ESPCMD_CHDIR:      equ $1C     ; Change directory
ESPCMD_STAT:       equ $1D     ; Get file status
ESPCMD_GETCWD:     equ $1E     ; Get current working directory
ESPCMD_CLOSEALL:   equ $1F     ; Close any open file/directory descriptor
ESPCMD_OPENDIR83   equ $20     ; Open directory in 8.3 filename mode
ESPCMD_READLINE    equ $21     ; Read line from file
ESPCMD_OPENDIREXT  equ $22     ; Open directory in extended mode
ESPCMD_LOADFPGA    equ $40     ; Load FPGA core
; Not yet implemented
ESPCMD_WIFI_STATUS       equ $50  ; Get WiFi status
ESPCMD_WIFI_SCAN         equ $51  ; Scan for WiFi APs
ESPCMD_WIFI_CONFIG       equ $52  ; Configure WiFi
ESPCMD_WIFI_SET_HOSTNAME equ $53  ; Set hostname	

;-----------------------------------------------------------------------------
; ESP32 error codes
;-----------------------------------------------------------------------------
ERR_NOT_FOUND:     equ -1   ; File / directory not found
ERR_TOO_MANY_OPEN: equ -2   ; Too many open files / directories
ERR_PARAM:         equ -3   ; Invalid parameter
ERR_EOF:           equ -4   ; End of file / directory
ERR_EXISTS:        equ -5   ; File already exists
ERR_OTHER:         equ -6   ; Other error
ERR_NO_DISK:       equ -7   ; No disk
ERR_NOT_EMPTY:     equ -8   ; Not empty
ERR_WRITE_PROTECT  equ -9   ; Write protected

;-----------------------------------------------------------------------------
; ESP32 file open modes
;-----------------------------------------------------------------------------
FO_RDONLY:      equ 0x00    ; Open for reading only
FO_WRONLY:      equ 0x01    ; Open for writing only
FO_RDWR:        equ 0x02    ; Open for reading and writing
FO_ACCMODE:     equ 0x03    ; Mask for above modes
FO_APPEND:      equ 0x04    ; Append mode
FO_CREATE:      equ 0x08    ; Create if non-existant
FO_TRUNC:       equ 0x10    ; Truncate to zero length
FO_EXCL:        equ 0x20    ; Error if already exists

;-----------------------------------------------------------------------------
; ESP32 keyboard buffer modes
;-----------------------------------------------------------------------------
KB_ENABLE       equ 0x01    ; Enable keyboard buffer
KB_ASCII        equ 0x02    ; ASCII mode
KB_REPEAT       equ 0x04    ; Enable auto-repeat
