/*
 * Headerfile for NEC PC-8801 specific stuff
 *
 * $Id: pc88.h $
 */

#ifndef __PC88_H__
#define __PC88_H__

#include <sys/types.h>

// Hardware definition

// PC88 Registers and other defs
//
#define SCREEN_TXT_BASE 0xf3c8
#define SCREEN_ATTR_BASE SCREEN_TXT_BASE + 80


// Keyboard
__sfr __at 0x00 KB_MATRIX_REG_0;
__sfr __at 0x01 KB_MATRIX_REG_1;
__sfr __at 0x02 KB_MATRIX_REG_2;
__sfr __at 0x03 KB_MATRIX_REG_3;
__sfr __at 0x04 KB_MATRIX_REG_4;
__sfr __at 0x05 KB_MATRIX_REG_5;
__sfr __at 0x06 KB_MATRIX_REG_6;
__sfr __at 0x07 KB_MATRIX_REG_7;
__sfr __at 0x08 KB_MATRIX_REG_8;
__sfr __at 0x09 KB_MATRIX_REG_9;
__sfr __at 0x0a KB_MATRIX_REG_A;
__sfr __at 0x0b KB_MATRIX_REG_B;
__sfr __at 0x0c KB_MATRIX_REG_C;
__sfr __at 0x0d KB_MATRIX_REG_D;
__sfr __at 0x0e KB_MATRIX_REG_E;


// W: Print Out or Calendar lock (uPD1990AC)
__sfr __at 0x10 PD_CTL_REG;

// If PD1990AC - bit0 - bit2 : Command output
//               bit3 : Data output
__sfr __at 0x20 USART_DATA_REG;		// R/W (pd8251C)
__sfr __at 0x21 USART_CTL_REG;		// R/W


/* System control register A
**READ: Dipswitch status
Bit     7       6       5           4       3       2       1       0
           SW1-S5       SW1-S4  SW1-S3  SW1-S2  SW1-S1  SW4-S1

SW1-S5  DEL code response: 0-OK 1-Ignore
SW1-S4  S parameter: 0-ON 1-OFF
SW1-S3  Text lines: 0-25L 1-20L
SW1-S2  Text columns: 0-80C 1-40C
SW1-S1  Boot mode: 0-Terminal 1-BASIC
SW4-S1  BASIC mode: 0-NBASIC 1-N88-BASIC
**WRITE: System Control Port
Bit     7       6       54      3           2   1           0
            BS  MTON    CDS     COLOR   40

BS      USART Channel control:
    00: CMT 600baud     10: RS-232C
    01: CMT 1200baud    11: RS-232C
MTON Motor Control: 0-OFF 1-Motor ON
CDS     Carrier control: 0-Space(1200hz) 1-Mark(2400hz)
COLOR Text screen color mode: 0-Color 1-B&W
40 40 Col mode: 0-40c 1-80c
*/
__sfr __at 0x30 SYS_CTL_REGA;


/* SYSTEM CONTROL REGISTER B //
** WRITE: System Control Port
Bit         7   6       5           4       3       2       1       0
                25LINE  HCOLOR  GRAPH   RMODE   MMODE   200LINE
25LINE Hi-res 25 row mode: 0-All other modes 1-ON
HCOLOR Graphic color mode: 0-B&W 1-Color
GRAPH Graphic control: 0-Graphic screens off 1-ON
RMODE ROM mode: 0-N88-BASIC 1-N-BASIC
MMODE RAM mode: 0-ROM/RAM 1-64K RAM
200LINE Hi-res CRT mode: 0-640×400 1-640x200
  Recommended values: 0b000110x1
** READ: Dipswitch status
Bit     7           6       5       4       3       2       1       0
    SW4-S2      SW3-S0  SW2-S6  SW2-S5  SW2-S4  SW2-S3  SW2-S2  SW2-S1

SW4-S2 V1/V2 Mode: 0-V2 1-V1
SW3-S0 Hispeed mode: 0-Off (V1S) 1-On (V1H, V2)
SW2-S6 Transfer direction: 0-Half-duplex 1-Full-duplex
SW2-S5 X parameter: 0-ON 1-OFF
SW2-S4 Stop bit length: 0-2 bits 1-1 bit
SW2-S3 Data bit length: 0-8 bits 1-7 bits
SW2-S2 Parity bit: 0-Even 1-Odd
SW2-S1 Parity check: 0-Party 1-No parity
*/
__sfr __at 0x31 SYS_CTL_REGB;

/* MODE SET REGISTER
[R/W] These registers are not decoded on systems
    before the PC-8801mkII. On models after SR,
    double-check this register on boot.
Bit     7           6       5       4       32  10
    SINTM       GVAM    PMODE   TMODE   AVC     EROMSL

SINTM Sound IRQ: 0-Enable 1-Disable
GVAM Graphics VRAM access mode: 0-Independant 1-Expanded
PMODE Palette mode: 0-Digital 8 color 1-Analog 512 color
TMODE FastRAM access mode (V1H/V2 only):
  0: F000h～FFFFh FastRAM
  1: F000h～FFFFh Main RAM
AVC     Screen output mode:
  00-TV/Video out   10-Computer out
  01-(off)          11-Option mode
EROMSL Select expaned ROM bank (0-3)
INDEPENDANT mode is the same as V1 mode. GVRAM is written separately.
EXPANDED mode (SR+ only) lets you access all planes simultaneously.
*NOTE: When VRAM is selected, overall processing speed is decreased.
  Remember to page in Main RAM!
Default values: xxxx1001
*/
__sfr __at 0x32 ALU_MODE_CTRL;

/* EXPANDED ALU CTRL
Write only
Bit     7       6           5       4       3   2           1       0
        ALU21   ALU11   ALU01       ALU20       ALU10   ALU00
        GV2H    GV1H    GV0H        GV2L    GV1L    GV0L
GV0 - ALU mode for GVRAM bank 0
GV1 - ALU mode for GVRAM bank 1
GV2 - ALU mode for GVRAM bank 2
 Bits arranged as H:L
00: Bit reset
01: Bit set
10: Bit invert
11: No op 
*/
__sfr __at 0x34 EXPANDED_ALU_CTRL;

/* Expanded Access Mode GVRAM Control   W only
bit  7      6   5 4     3   2   1   0
     GAM    -   GDM     -   GC  RC  BC

GAM - GVRAM Access Mode
 0 = Main RAM, 1 = GVRAM
GDM - Graphic data multiplexer control
 00 = Write all planes (check port $34)
 01 = Write last VRAM read data to all 3 planes
 10 = Transfer R plane to B
 11 = Transfer B plane to R

* If GDM = 00, you can perform logical operations as explained
using register $34. It appears this mode does not use a buffer.
(There are ways to utilize this to advantage combined with GDM=01
but I am unclear)

* If GDM = 01, when a single byte is read from VRAM, all 3 planar
data parts are read into a buffer. When writing, the stored buffer
data is written to all 3 planes simultaneously. You can use this to
copy within VRAM without extraneous calculations (ie port $34),
which can be used to create scrolling.

* GC/RC/BC = Bit comp data. Bits written to these fields act as a
color plane filter to VRAM reads. E.g. if bits2-0 are 011 (purple),
the pixel data read from VRAM will be 1 if purple, or 0 if not.

* When ALU EXPANDED access mode is on, reading data from VRAM is
not stored in a register. What is loaded in the register is
'comparison data'; VRAM itself is stored in a hidden buffer.

ld a,%10010000  ; gvram access on, 3 plane buffer r/w mode
out ($35),a
ld a,($c000)    ; this is bit comp data, but the
ld ($c002),a   ; operation commands a vram 'copy'.
*/
__sfr __at 0x35 EXPANDED_GVRAM_CTRL;

__sfr __at 0x40 SYS_MODE_SENSE;

// OPN sound
__sfr __at 0x44 FM_REG_0;	// <FR/MR - OPN, FH/MH> - OPNA SSG/FM1-3
__sfr __at 0x45 FM_REG_1;	// <FR/MR - OPN, FH/MH> - OPNA SSG/FM1-3
__sfr __at 0x46 FM_REG_2;	// FH/MH - OPNA ADPCM/FM4-6
__sfr __at 0x47 FM_REG_3;	// FH/MH - OPNA ADPCM/FM4-6


__sfr __at 0x50 CRTC_CTLREG_A;	// pd3301AC control ports
__sfr __at 0x51 CRTC_CTLREG_B;	// pd3301AC control ports

// W - bits 4-6 only.
// bit  7   6 5 4   3   2   1
//          G R B
__sfr __at 0x52 BG_COLOR_REG;	


/* Screen Display Control - Write only
Bit     7       6       5       4       3           2       1       0
                    G2DS        G1DS    G0DS    TEXTDS

G2DS GVRAM2 display: 0-ON 1-OFF
G1DS GVRAM1 display: 0-ON 1-OFF
G0DS GVRAM0 display: 0-ON 1-OFF
TEXTDS Text screen display: 0-ON 1-OFF
* Set bit 3 to 1 when using 640x400 mode.
In color graphics mode, G*DS bits are ignored.
*/
__sfr __at 0x53 SCREEN_DISP_CTL;

__sfr __at 0x54 PAL_REG0;	// bits 0-2 contain  palette value 0-7
__sfr __at 0x55 PAL_REG1;	// bits 0-2 contain  palette value 0-7
__sfr __at 0x56 PAL_REG2;	// bits 0-2 contain  palette value 0-7
__sfr __at 0x57 PAL_REG3;	// bits 0-2 contain  palette value 0-7
__sfr __at 0x58 PAL_REG4;	// bits 0-2 contain  palette value 0-7
__sfr __at 0x59 PAL_REG5;	// bits 0-2 contain  palette value 0-7
__sfr __at 0x5a PAL_REG6;	// bits 0-2 contain  palette value 0-7
__sfr __at 0x5b PAL_REG7;	// bits 0-2 contain  palette value 0-7

/* Read: GVRAM bank display status
   bit 0 - GVRAM0
   bit 1 - GVRAM1
   bit 2 - GVRAM3
1 = Selected
0 = Not selected 
*/
__sfr __at 0x5c GVRAM_BANK_REG;

__sfr __at 0x5c GVRAM_SEL_0;	// Write any value to select vram0 (blue)
__sfr __at 0x5d GVRAM_SEL_1;	// Write any value to select vram1 (red)
__sfr __at 0x5e GVRAM_SEL_2;	// Write any value to select vram2 (green)
__sfr __at 0x5f MAINRAM_SEL;	// Write any value to select main ram

__sfr __at 0x60 DMAC_REG0;	// PD8257C DMA controler register (R/W)
__sfr __at 0x61 DMAC_REG1;	// PD8257C DMA controler register (R/W)
__sfr __at 0x62 DMAC_REG2;	// PD8257C DMA controler register (R/W)
__sfr __at 0x63 DMAC_REG3;	// PD8257C DMA controler register (R/W)
__sfr __at 0x64 DMAC_REG4;	// PD8257C DMA controler register (R/W)
__sfr __at 0x65 DMAC_REG5;	// PD8257C DMA controler register (R/W)
__sfr __at 0x66 DMAC_REG6;	// PD8257C DMA controler register (R/W)
__sfr __at 0x67 DMAC_REG7;	// PD8257C DMA controler register (R/W)
__sfr __at 0x68 DMAC_REG8;	// PD8257C DMA controler register (R/W)


__sfr __at 0x6e CPU_CLOCK_CTL;	// Bit 7 only. 1=4MHz, 0=8MHz

/* (R/W) Baud rate set register, FH+ only
Bits 0-3 only:
0000    75
0001    150
0010    300
0011    600
0100    1200
0101    2400
0110    4800
0111    9600
1000    19200
1001～1111      OFF 
*/
__sfr __at 0x6f BAUDRATE_REG;


/* R/W Upper 8 bits of text window address */
__sfr __at 0x70 TEXTWIN_OFS_REG;  

/* Expansion ROM select
Only one bit can be set at once:
Bit7 Expansion ROM 7 select
Bit6 Expansion ROM 6 select
Bit5 Expansion ROM 5 select
Bit4 Expansion ROM 4 select
Bit3 Expansion ROM 3 select
Bit2 Expansion ROM 2 select
Bit1 Expansion ROM 1 select
Bit0 Expansion ROM 0/4th rom select
Writing 0xff selects Main ROM.
*/
__sfr __at 0x71 ROM_EXPANSION_SEL;

/* W: Increment TEXTWIN_OFS */
__sfr __at 0x78 TEXTWIN_INC_REG;


extern void __LIB__ pc88_wait_vblank();


// Misc functions that use the firmware

// Check if Ctrl-STOP is being pressed (1=if pressed, 0 if not)
extern bool_t __LIB__ pc88_break();

// Disable the CTRL-STOP effect (when a BASIC routine is being called)
extern void __LIB__ pc88_breakoff();

// Restore the CTRL-STOP break command
extern void __LIB__ pc88_breakon();

// Clear the keyboard buffer
extern void __LIB__ pc88_clearkey();

// TRUE if the current DIP switch settings are in V2 mode
extern bool_t __LIB__ pc88_v2mode();

// TRUE if the CPU speed is 8mhz
extern bool_t __LIB__ pc88_8mhz();

// Test the PC88 mode:  0=V1(S), 1=V1(H), 2=V2
extern int __LIB__ pc88_mode();

// Look for an FM chip. Address for FM if found, otherwise 0
extern int __LIB__ pc88_fm_addr();


// Display related functions

// Show/Hide the text cursor
extern void __LIB__ pc88_cursoron();
extern void __LIB__ pc88_cursoroff();

// Move the screen cursor to a given position
extern void __LIB__ pc88_locate(unsigned int x, unsigned int y) __smallc;

// Set text windows (40 or 80 columns, 20 or 25 rows)
extern void __LIB__ pc88_crtset(int width, int height) __smallc;

#endif
