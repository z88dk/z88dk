
#ifndef __ARCH_PX8_H__
#define __ARCH_PX8_H__

#include <sys/types.h>

/* Useful only for subcpu_call(), which normally is called internally
   it is rather advisable to use subcpu_command() or subcpu_function() */

struct SUBCPU_MASTERPACKET {
	u16_t	sndpkt;	/* Pointer to packet data being sent     */
	u16_t	size;	/* Size of packet data being sent        */
	u16_t	rcvpkt;	/* Pointer to packet data being received */
	u16_t	bytes;	/* Size of packet data being received (+1 status byte) */
};


/* Slave CPU return codes */
#define SYS_OK		0		// SYS:  OK, normal termination
#define SYS_BREAK	1		// SYS:  Break acknowledged
#define SYS_ERROR	2		// SYS:  Command error
#define SYS_COMMS	3		// SYS:  Communication error
#define LCD_SIZE	11		// LCD:  Invalid size specification
#define LCD_UDG		12		// LCD:  Undefined graphics on UDG
#define LCD_CHAR	13		// LCD:  Invalid User Defined Graphics character
#define MCT_HEAD	41		// MCT:  Head error
#define MCT_STOP	42		// MCT:  Tape stopped during processing
#define MCT_WR_P	43		// MCT:  Write protection error
#define MCT_DATA	44		// MCT:  Data error
#define MCT_ERROR	45		// MCT:  CRC error
#define MCT_BLKMODE	46		// MCT:  Block mode error (invalid block identifier)
#define ESPS_OK			61		// ESPS: Linking unsuccessful
#define ESPS_ERROR		62		// ESPS: Communication error
#define ESPS_TIMEOUT	63		// ESPS: Time over
#define BEEP_ERROR		71		// BEEP: New BEEP or MELODY command while still playing


/* Macros for LCD*/
#define LCD_ON subcpu_command("\001\021\001")
#define LCD_OFF subcpu_command("\001\021\000")
#define LCD_TEXT subcpu_command("\001\022\001")
#define LCD_GRAPHICS subcpu_command("\001\022\000")

/* Functions for LCD*/

// Define 8x8 User Defined Graphics character (6x8 visible by default), valid codes:  E0h..FFh
extern int __LIB__ lcd_set_udg(int code, void *pattern) __smallc;


/* Macros for TEXT mode options*/
#define LCD_7LINES subcpu_command("\001\025\001")
#define LCD_8LINES subcpu_command("\001\025\000")
#define LCD_CURSOR_OFF subcpu_command("\001\026\000")
#define LCD_CURSOR_UNDERLINE subcpu_command("\001\026\001")
#define LCD_CURSOR_UNDERLINE_BLINK subcpu_command("\001\026\003")
#define LCD_CURSOR_BLOCK subcpu_command("\001\026\005")
#define LCD_CURSOR_BLOCK_BLINK subcpu_command("\001\026\007")
// 'codepage' related
#define CHARSET_USASCII esc_sequence("\001CU")
#define CHARSET_FRANCE  esc_sequence("\001CF")
#define CHARSET_GERMANY esc_sequence("\001CG")
#define CHARSET_ENGLAND esc_sequence("\001CE")
#define CHARSET_DENMARK esc_sequence("\001CD")
#define CHARSET_SWEDEN  esc_sequence("\001CW")
#define CHARSET_ITALY   esc_sequence("\001CI")
#define CHARSET_SPAIN   esc_sequence("\001CS")
#define CHARSET_NORWAY  esc_sequence("\001CN")

/* Cassette Player Macros */
#define CMT_HEAD_ON subcpu_command("\000\101")
#define CMT_HEAD_OFF subcpu_command("\000\102")
#define CMT_REW subcpu_command("\000\105")
#define CMT_FF subcpu_command("\000\106")
#define CMT_SLOW_REW subcpu_command("\000\107")
#define CMT_PLAY subcpu_command("\000\110")
#define CMT_RECORD subcpu_command("\000\111")
#define CMT_STOP subcpu_command("\000\112")
#define CMT_UNPROTECT_WR_AREA subcpu_command("\000\126")

/* Keyboard Macros */
#define KBD_REPEAT_OFF   esc_sequence("\000\173")

/* Keyboard Functions */
// Test STOP key and CTL-STOP
extern bool_t __LIB__ px8_break();
// Test STOP key only
extern bool_t __LIB__ px8_stop();

/* Misc Macros */
#define PROM_ON   subcpu_command("\001\160\001")
#define PROM_OFF  subcpu_command("\001\160\000")
//#define SPK_ON  subcpu_command("\001\162\001")		<- documentation suggest this option but MXO-PX8.ASM uses 0x80 (200 in octal)
#define SPK_ON    subcpu_command("\001\162\200")
#define SPK_OFF   subcpu_command("\001\162\000")
#define HARDCOPY     esc_sequence("\000P")
// In 'secret mode' every character being printed is converted to SPACE
#define CONSOLE_SECRET_ON    esc_sequence("\000\173")
#define CONSOLE_SECRET_OFF   esc_sequence("\000\175")
// Deals with the computer LEDs
#define LED_INS_ON   esc_sequence("\000\240")
#define LED_INS_OFF  esc_sequence("\000\241")
#define LED_CAPS_ON  esc_sequence("\000\242")
#define LED_CAPS_OFF esc_sequence("\000\243")
#define LED_NUM_ON   esc_sequence("\000\244")
#define LED_NUM_OFF  esc_sequence("\000\245")
// Hide the banner showing the FN key associations
#define CONSOLE_KEY_OFF  esc_sequence("\001\323\001")
#define CONSOLE_KEY_ON   esc_sequence("\001\323\000")

// Key code map
#define KEY_PF1  0xe0
#define KEY_PF2  0xe1
#define KEY_PF3  0xe2
#define KEY_PF4  0xe3
#define KEY_PF5  0xe4
#define KEY_PF6  0xe5	// (SHIFT-F1)
#define KEY_PF7  0xe6	// (SHIFT-F2)
#define KEY_PF8  0xe7	// (SHIFT-F3)
#define KEY_PF9  0xe8	// (SHIFT-F4)
#define KEY_PF10 0xe9	// (SHIFT-F5)

// Default values for cursor keys (can be remapped)
#define KEY_RIGHT       0x1c
#define KEY_LEFT        0x1d
#define KEY_UP          0x1e
#define KEY_DOWN        0x1f
#define KEY_CTRL_RIGHT  0xff
#define KEY_CTRL_LEFT   0xfe
#define KEY_CTRL_UP     0xfa
#define KEY_CTRL_DOWN   0xfb

// Choose the virtual screen (1 or 2)
#define CONSOLE_VIRTUAL_1  esc_sequence("\001\321\000")
#define CONSOLE_VIRTUAL_2  esc_sequence("\001\321\001")

/* Talk to SUB-CPU via self-built packets. */
extern int __LIB__ subcpu_call(void *masterpacket) __z88dk_fastcall;

/* Send a command/parameters sequence to SUB-CPU where no data has to be sent back.
   The command sequence is: <parameters number>,<command code>,<parameter list>
   e.g. subcpu_command("\001\026\005"), or create char mycommand[]={1,0x12,5};*/
extern int __LIB__ subcpu_command(void *cmdsequence) __z88dk_fastcall;

/* Full communication with SUB-CPU, use structures to pass the whole parameter blocks and sizeof() for the *_sz parameters
 * (uses the parameters on stack, can't be converted to "CALLEE") */
extern int __LIB__ subcpu_function(int rcvpkt_sz, void *rcvpkt, int sndpkt_sz, void *sndpkt) __smallc;

/* Send a command/parameters ESC sequence to the console.
   The command sequence is: <parameters number>, <command code (without leading ESC)>, <parameter list>
*/
extern int __LIB__ esc_sequence(void *cmdsequence) __z88dk_fastcall;


// ADCVRT and 7508 sub-cpu functions

// 60h = 50 C; C0h = 20 C, everything in between is more or less linear
#define READ_TEMPERATURE(temp) (subcpu_7508(0x1C, 0, NULL, 1, &temp))

typedef enum {
    CH_ANALOG=0,
    CH_BARCODE,
    CH_DIP_SW,
    CH_BATTERY,
    CH_BUTTONS
} adcvrt_channel_t;

extern int __LIB__ adcvrt(adcvrt_channel_t channel) __z88dk_fastcall;

extern void __LIB__ subcpu_7508(char cmd, char out_sz, void* out_buf, char in_sz, void* in_buf) __z88dk_sdccdecl;

#endif
