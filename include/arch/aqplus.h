
#ifndef __AQPLUS_H
#define __AQPLUS_H

#include <sys/compiler.h>
#include <stdint.h>
#include <arch/aquarius.h>

// -----------------------------------------------------------------------------
// regs.inc
// Aquarius+ I/O Registers and Memory Banks
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Bank and Page Definitions
// -----------------------------------------------------------------------------
#define BANK0_BASE 0x0000  //
#define BANK1_BASE 0x4000  //
#define BANK2_BASE 0x8000  //
#define BANK3_BASE 0xc000  //
#define PAGE_SIZE 0x4000   //
#define BANK_READONLY 0x80 // Bank readonly
#define BANK_OVERLAY 0x40  // RAM overlay
// RAM Page Usage
#define ROM_SYS_PG 60      // Main System ROM, mapped into Bank 0 with overlay from 0x3000-0x3FFF
#define ROM_EXT_PG 61      // plusBASIC extended ROM, mapped into Bank 3
#define ROM_AUX_PG 62      // plusBASIC auxillary ROM, mapped into Bank 3 as needed
#define ROM_CRT_PG 63      // If a cartrige is present, it is copied here unencrypted, then executed
#define ROM_SYS_OV 60      //
#define ROM_EXT_RO 61      //
#define ROM_AUX_RO 62      //
#define ROM_CRT_RO 63      //
#define ROM_CART 19        //
#define VIDEO_RAM 20       //
#define CHAR_RAM 21        //
#define RAM_BAS_0 56       // RAM for Bank 0 (character ROM cache)
#define RAM_BAS_1 57       // RAM for BASIC mapped into Bank 1
#define RAM_BAS_2 58       // RAM for BASIC mapped into Bank 2
#define RAM_BAS_3 59       // RAM for Bank 3 (unused by BASIC)
#define TMP_BUFFR 50       // Transient data buffer
#define BOOT_BUFR 51       // Boot ROM work area
#define SCR_BUFFR 52       // Screen Buffers
#define VID_BUFFR 53       // Video RAM Shadow Buffer
#define BAS_BUFFR 54       // plusBASIC extended system variables and buffers, mapped in bank 3 as needed
#define PT3_BUFFR 55       // PT3 Player Buffer
#define USER_RAM 32        // First page of User RAM
#define USER_END 49        // Last page of User RAM
#define RAM_END_PG 63      // Last page of RAM
#define ROM_EXT_BANK 3     // Bank Extended ROM is mapped into
#define ROM_AUX_BANK 3     // Bank Auxillary ROM is mapped into
#define CHAR_ROM_AQ 0x3000 // Standard Aquarius Character ROM Address in System ROM
#define CHAR_ROM_L1 0x3800 // Latin-1 Aquarius Character ROM Address in System ROM
// -----------------------------------------------------------------------------
// Video RAM Offsets
// Page 20
// -----------------------------------------------------------------------------
#define BMP_BASE 0x0000          //
#define BMP_COLORRAM 0x2000      //
#define BMP_PAL_OFS 8000         // Offset of palette data in file
#define BMP_FILELEN 9192         // Length of 320x200 bitmap file
#define TILE_DATA 0x0000         //
#define TILE_MAP_BASE 0x0000     //
#define TILE_MAP_LEN 64 * 32 * 2 //
// -----------------------------------------------------------------------------
// plusBASIC System variables
// -----------------------------------------------------------------------------
// Screen RAM Hole 0x33E8-0x33FF exists only in 40 column mode
#define BORDERCHR 0x33ff // Border character alternate memory location (40 column mode)
// Color RAM Hole
#define BORDERCLR 0x37ff // Border color alternate memory location
// plusBASIC temporary sysvars
// FILNAM (0x3851-0x3856) - CLOAD/CSAVE File Name
// FILNAF (0x3857-0x385C) - File Name on Tape
#define BUFADR 0x3857 // Unpack buffer address
#define BUFPTR 0x3859 // Pointer into unpacking buffer
#define BUFRET 0x385b // unpack_line return address
#define BUFLEN 0x385b // Buffer length
// RNDTAB (0x3821-0x3840) - Deprecated RND Permutation Table
#define BASINTPG 0x3821  // BASIC Interrupt Routine Page, 0=None (swapped into BANK 3)
#define BASINTJP 0x3822  // BASIC Interrupt Routine JP instruction
#define BASINTADR 0x3823 // BASIC Interrupt Routine JP Address (0x3823-0x3824)
#define BASYSCTL 0x3825  // System Control Bits
#define IRQACTIVE 0x3826 // Active IRQ Routines Bits
#define TIMERCNT 0x3827  // TIMER counter LSB = 0x3827, MSB = 0x3829
// Used by ON ERROR. Must be in in consecutive order: ERRLIN,ERRFLG,ONEFLG,ONELIN
#define ERRLIN 0x382a    // LINE NUMBER WHERE LAST ERROR OCCURED.
#define ERRFLG 0x382c    // USED TO SAVE THE ERROR NUMBER SO EDIT CAN BE
#define ONEFLG 0x382d    // ONEFLG=1 IF WERE ARE EXECUTING AN ERROR TRAP ROUTINE
#define ONELIN 0x382e    // THE pointer to the LINE TO GOTO WHEN AN ERROR OCCURS
#define EXT_FLAGS 0x3830 // Extended BASIC flags
#define MOUSEWDLT 0x3831 // Accumulated change in mouse delta
#define BAS_FDESC 0x3832 // ESP file descriptor to close on Error or Ctrl-C
#define IEND_KEY 0x3833  // Key pressed to end input
// 0x3834-0x3835   ; unused (2 bytes)
// Temporary variables used within statement code.
// FILESTAT statement
#define FILESIZE 0x3838 // File Size (32-bits 0x3838-0x383B)
#define FILEATTR 0x383c // File Attribute
#define FILEDATE 0x383d // File Datestamp (0x383D-0x383E)
#define FILETIME 0x383f // File Timestamp (0x383F-0x3840)
// SPLIT statement
#define SPLITDSC 0x3838 // String descriptor
#define SPLITTRM 0x3838 // Segment terminator  (overwrites LSB of SPLITDSC)
#define SPLITSEG 0x3839 // Segment counter (overwrites MSB of SPLITDSC)
#define ARRAYADR 0x383a // Array data start address
#define SPLITDEL 0x383c // Delimiter character
#define ARRAYTYP 0x383c // Array Type
#define ARRAYPTR 0x383d // Pointer into array data
#define ARRAYLEN 0x383f // Array data length
// bitmap_get and bitmap_set
#define BMPMODE 0x3837  // Bitmap Mode 0=1bpp, 2=4bpp
#define STARTCOL 0x3838 //
#define ENDCOL 0x383a   //
#define STARTROW 0x383c //
#define ENDROW 0x383e   //
// DEF SPRITE
#define XTEMP0 0x3836   // Used by DEF SPRITE
#define XTEMP1 0x3837   // Used by DEF SPRITE
#define SPRTLNUM 0x3838 // Spritle number
#define SPRTCOLS 0x383a // Width in spritles
#define SPRTROWS 0x383c // Height in spritles
// enhance editor
#define RIGHTCOL 0x3838  // Right bound (LINELEN-1)
#define LEFTCOL 0x3839   // Left bound (1)
#define BOTLINE 0x383a   //
#define TOPLINE 0x283b   //
#define LINEDELTA 0x283c // LINELEN - RIGHTCOL + LEFTCOL
// -----------------------------------------------------------------------------
// Variables
// -----------------------------------------------------------------------------
#define BASIC_RAM_END 0xbfff // End of BASIC RAM, 0xBF00-0xBFFF is reserved for our extensions

#define VCTRL_TEXT_OFF 0x00           // xxxxxxx0  Disable Text Screen
#define VCTRL_TEXT_EN 0x01            // xxxxxxx1  Enable Text Screen
#define VCTRL_MODE_TILE 0x02          // xxxxx01x  Select Tilemap Mode
#define VCTRL_MODE_BM 0x04            // xxxxx10x  Select 1bpp Bitmap Mode
#define VCTRL_MODE_MC 0x06            // xxxxx11x  Select 4bpp Bitmap Mode
#define VCTRL_SPR_EN 0x08             // xxxx1xxx  Enable Sprites
#define VCTRL_TEXT_PRIO 0x10          // xxx1xxxx  Text Screen Priority
#define VCTRL_REMAP_BC 0x20           // xx1xxxxx  Remap Text Border Characters
#define VCRTL_80COL_EN 0x40           // x1xxxxxx  Enable 80-column mode
#define VCTRL_TEXT_PAGE 0x80          // 1xxxxxxx  Select Text Page
#define VCTRL_TEXT_BITS vctrl_text_en //
#define VCTRL_TEXT_MASK 0xff          //
#define VCTRL_TEXT_DIS 0xff           //
#define SYSCTRL_XRG_DIS 0x01          // xxxxxxx1  Disable registers 0xE0-0xF5, 0xF8-0xF9
#define SYSCTRL_PSG_DIS 0x02          // xxxxxx1x  Disable PSGs
#define SYSCTRL_TURBO 0x04            // xxxxx1xx  Turbo mode (7.16MHz)
#define IRQ_VBLANK 0x01               // VBLANK interrupt
#define IRQ_VLINE 0x02                // Video LINE interrupt
// -----------------------------------------------------------------------------
// BASIC Extended character ROM buffers
// Page 56 (RAM_BAS_0)
// See screen_swap.asm
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// BASIC Extended System Constants, Variables and Buffers
// Page 54 (BAS_BUFFR), swapped into Bank 3
// -----------------------------------------------------------------------------
// Page 54 (BAS_BUFFR), swapped into Bank 3
#define BASBUF_BASE 0xc000   // Base Address of BASIC Buffers
#define SCRNVBASE 0x0000     // Screen variable buffers (see screen.inc)
#define GFXVBASE 0x0100      // GFX SysVar Base, 256 byte aligned (see gfxvars.asm)
#define FKEYDEFS 0x0200      // Function Key Definitions (32 bytes each)
#define FKEYBASE basbuf_base //
// 0x0500-0x07FF   ; Unused
#define RUNARGS 0x0800   // RUN arguments (see run_args in args.asm)
#define RUNARGEND 0x09ff // End of RUN arguments
// 0x1000-0x2FFF   ; Unused
#define DEFCHRSET 0x3000 // Page Offset: Default Character Set Buffer
#define ALTCHRSET 0x3800 // Page Offset: Custom Character Set Buffer
#define CHRSETLEN 2048   // Size of character set ROM
#define ASCSETLEN 768    // Size of ASCII character set (' ' - DEL)
// BASIC interpreter control flags
#define BASOUTBUF 0x01 // BASYSCTL: redirect OUTput to BUFfer
#define BASSAVASC 0x02 // BASYSCTL: Default SAVe to ASC
#define BASKEYRPT 0x04 // BASYSCTL: KEY RePeaT on
#define BASCHRSET 0x08 // BASYSCTL: Character set in use (0 or 1)
#define BASCHRMOD 0x10 // BASYSCTL: Character set in use has been modified
#define BASBRKOFF 0x20 // BASYSCTL: BReak OFF (Disable Ctrl-C)
#define BASLPRNTR 0x40 // BASYSCTL: LPRINT device: (0 = Serial, 1 = ESP)
#define BASCRNCLR 0x80 // BASYSCTL: PRINT updates Color RAM
// Screen Control Bitmask
#define BASCRNCTL baschrset //
#define BASCRNMSK 0xff      //
// Bitmap graphics mode: see gfx.asm for details
#define GFXM_TEXT 0x00 // EXT_FLAGS: 40 colum mode (bloxels)
#define GFXM_WIDE 0x01 // EXT_FLAGS: 80 colum mode (bloxels)
#define GFXM_1BPP 0x02 // EXT_FLAGS: Bitmap mode (1bpp)
#define GFXM_4BPP 0x03 // EXT_FLAGS: Bitmap mode (4bpp)
#define GFXM_MASK 0x03 // Graphics mode bit mask
#define GFXBUFLAG 0x04 // EXT_FLAGS: Bitmap operations are buffered
#define GFXSETMSK 0xf8 // Mask for writing EXT_FLAGS
// BASIC extended control flags
#define BASOUTOVR 0x10 // EXT_FLAGS: Allow OUT to all ports
#define PT3_LOOPS 0x20 // EXT_FLAGS: PT3 songs repeat
#define FERR_FLAG 0x40 // EXT_FLAGS: File operations generate BASIC errors
#define TRON_FLAG 0x80 // EXT_FLAGS: Trace on/off
#define DFLTATTRS 0x06 // Default screen colors - Black on Cyan
// -----------------------------------------------------------------------------
// IRQACTIVE Bits
// -----------------------------------------------------------------------------
#define IRQ_TIMER 0x01   // Bit 0 - Timer active
#define IRQ_PT3PLAY 0x02 // Bit 1 - PT3 Player running
// -----------------------------------------------------------------------------
// PT3 Player
// -----------------------------------------------------------------------------
#define PT3_BASE 0xc000         //
#define PT3INIT pt3_base + 0x00 // StartPlayer
#define PT3TICK pt3_base + 0x03 // PlayQuark
#define PT3STAT pt3_base + 0x06 // CHECKLP
#define PT3MUTE pt3_base + 0x09 // MUTE
#define PT3FAST pt3_base + 0x0c // SetMode
#define PT3MODE pt3_base + 0x0f // GetMode
#define PT3SONG 0x0a00          // PT3 file load address
// -----------------------------------------------------------------------------
// Macros
// -----------------------------------------------------------------------------
#define SYNCHK macro //
#define RST synchr   //
#define DB value     //
// -----------------------------------------------------------------------------
// ESP32 commands
// -----------------------------------------------------------------------------
#define ESPCMD_RESET 0x01       // Reset ESP
#define ESPCMD_VERSION 0x02     // Get version string
#define ESPCMD_DATETIME 0x03    // Get current date and time
#define ESPCMD_KEYMODE 0x08     // Set keyboard buffer mode
#define ESPCMD_GETMOUSE 0x0c    // Get mouse position and button state
#define ESPCMD_GETGAMECTRL 0x0e // Get wireless game controller status
#define ESPCMD_OPEN 0x10        // Open / create file
#define ESPCMD_CLOSE 0x11       // Close open file
#define ESPCMD_READ 0x12        // Read from file
#define ESPCMD_WRITE 0x13       // Write to file
#define ESPCMD_SEEK 0x14        // Move read/write pointer
#define ESPCMD_TELL 0x15        // Get current read/write
#define ESPCMD_OPENDIR 0x16     // Open directory
#define ESPCMD_CLOSEDIR 0x17    // Close open directory
#define ESPCMD_READDIR 0x18     // Read from directory
#define ESPCMD_DELETE 0x19      // Remove file or directory
#define ESPCMD_RENAME 0x1a      // Rename / move file or directory
#define ESPCMD_MKDIR 0x1b       // Create directory
#define ESPCMD_CHDIR 0x1c       // Change directory
#define ESPCMD_STAT 0x1d        // Get file status
#define ESPCMD_GETCWD 0x1e      // Get current working directory
#define ESPCMD_CLOSEALL 0x1f    // Close any open file/directory descriptor
#define ESPCMD_OPENDIR83 0x20   // Open directory in 8.3 filename mode
#define ESPCMD_READLINE 0x21    // Read line from file
#define ESPCMD_OPENDIREXT 0x22  // Open directory in extended mode
#define ESPCMD_LOADFPGA 0x40    // Load FPGA core
// Not yet implemented
#define ESPCMD_WIFI_STATUS 0x50       // Get WiFi status
#define ESPCMD_WIFI_SCAN 0x51         // Scan for WiFi APs
#define ESPCMD_WIFI_CONFIG 0x52       // Configure WiFi
#define ESPCMD_WIFI_SET_HOSTNAME 0x53 // Set hostname
// -----------------------------------------------------------------------------
// ESP32 error codes
// -----------------------------------------------------------------------------
#define ERR_NOT_FOUND -1     // File / directory not found
#define ERR_TOO_MANY_OPEN -2 // Too many open files / directories
#define ERR_PARAM -3         // Invalid parameter
#define ERR_EOF -4           // End of file / directory
#define ERR_EXISTS -5        // File already exists
#define ERR_OTHER -6         // Other error
#define ERR_NO_DISK -7       // No disk
#define ERR_NOT_EMPTY -8     // Not empty
#define ERR_WRITE_PROTECT -9 // Write protected
// -----------------------------------------------------------------------------
// ESP32 file open modes
// -----------------------------------------------------------------------------
#define FO_RDONLY 0x00  // Open for reading only
#define FO_WRONLY 0x01  // Open for writing only
#define FO_RDWR 0x02    // Open for reading and writing
#define FO_ACCMODE 0x03 // Mask for above modes
#define FO_APPEND 0x04  // Append mode
#define FO_CREATE 0x08  // Create if non-existant
#define FO_TRUNC 0x10   // Truncate to zero length
#define FO_EXCL 0x20    // Error if already exists
// -----------------------------------------------------------------------------
// ESP32 keyboard buffer modes
// -----------------------------------------------------------------------------
#define KB_ENABLE 0x01 // Enable keyboard buffer
#define KB_ASCII 0x02  // ASCII mode
#define KB_REPEAT 0x04 // Enable auto-repeat

// Stat buffer returned by ESP32
struct aqplus_stat
{
    uint16_t date;
    uint16_t time;
    uint8_t attr;
    uint32_t size;
};

static __sfr __at 0xE0 IO_VCTRL;
static __sfr __at 0xE1 IO_VSCRX_L;
static __sfr __at 0xE2 IO_VSCRX_H;
static __sfr __at 0xE3 IO_VSCRY;
static __sfr __at 0xE4 IO_VSPRSEL;
static __sfr __at 0xE5 IO_VSPRX_L;
static __sfr __at 0xE6 IO_VSPRX_H;
static __sfr __at 0xE7 IO_VSPRY;
static __sfr __at 0xE8 IO_VSPRIDX;
static __sfr __at 0xE9 IO_VSPRATTR;
static __sfr __at 0xEA IO_VPALSEL;
static __sfr __at 0xEB IO_VPALDATA;
static __sfr __at 0xEC IO_VLINE;
static __sfr __at 0xED IO_VIRQLINE;
static __sfr __at 0xEE IO_IRQMASK;
static __sfr __at 0xEF IO_IRQSTAT;
static __sfr __at 0xF0 IO_BANK0;
static __sfr __at 0xF1 IO_BANK1;
static __sfr __at 0xF2 IO_BANK2;
static __sfr __at 0xF3 IO_BANK3;
static __sfr __at 0xF4 IO_ESPCTRL;
static __sfr __at 0xF5 IO_ESPDATA;
static __sfr __at 0xF8 IO_PSG2DATA;
static __sfr __at 0xF9 IO_PSG2ADDR;
static __sfr __at 0xFB IO_SYSCTRL;

#endif
