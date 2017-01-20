/*
 * Headerfile for Enterprise 64/128 specific stuff
 *
 * $Id: enterprise.h,v 1.9 2016-06-23 21:11:24 dom Exp $
 */

#ifndef __ENTERPRISE_H__
#define __ENTERPRISE_H__

#include <sys/compiler.h>


// EXOS VARIABLES
#define EV_IRQ_ENABLE_STATE  0   // Flags set to enable interrupts: b0 - sound IRQ, b2 - 1hz IRQ, b4 - video IRQ, b6 external IRQ.
#define EV_FLAG_SOFT_IRQ     1   // This is the byte set non­zero by a device to cause a software interrupt.  When it happens...
#define EV_CODE_SOFT_IRQ     2   // ..this code should be inspected by a software ISR to determine the reason for interrupt.
#define EV_DEF_TYPE          3   // Type of default device: 0 => non file handling (eg. TAPE), 1 => file handling device (eg. DISK).
#define EV_DEF_CHAN          4   // Default channel number. It will be used whenever a call is made with channel number 255.
#define EV_TIMER             5   // 1Hz down counter. Will cause a software interrupt when it reaches zero and will then stop.
#define EV_LOCK_KEY          6   // Current keyboard lock status.
#define EV_CLICK_KEY         7   // =0 : Key click enabled.
#define EV_STOP_IRQ          8   // =0 : STOP key causes soft IRQ. <>0 : STOP key returns code.
#define EV_KEY_IRQ           9   // =0 : Any key press causes soft IRQ, as well as returning a code.
#define EV_RATE_KEY         10   // Keyboard auto­repeat rate in 1/50 seconds.
#define EV_DELAY_KEY        11   // Delay until auto­repeat starts (=0 : no auto­repeat).
#define EV_TAPE_SND         12   // =0 : Tape sound feedthrough enabled.
#define EV_WAIT_SND         13   // =0 : Sound driver waits when queue full. <>0 : Returns .SQFUL error when queue full.
#define EV_MUTE_SND         14   // =0 : Internal speaker active. <>0 : Internal speaker disabled.
#define EV_BUF_SND          15   // Sound envelope storage size in phases.
#define EV_BAUD_SER         16   // Defines serial baud rate.
#define EV_FORM_SER         17   // Defines serial word format.
#define EV_ADDR_NET         18   // Network address of this machine.
#define EV_NET_IRQ          19   // =0 : Data received on network will cause a software interrupt.
#define EV_CHAN_NET         20   // Channel number of network block received.
#define EV_MACH_NET         21   // Source machine number of network block.

// These variables select the characteristics of a video page page when it is opened. 
#define EV_MODE_VID         22   // Video Mode
#define EV_COLR_VID         23   // Colour Mode
#define EV_X_SIZ_VID        24   // X page size
#define EV_Y_SIZ_VID        25   // Y page size

#define EV_ST_FLAG          26   // =0 : Status line is displayed.
#define EV_BORD_VID         27   // Border colour of screen.
#define EV_BIAS_VID         28   // Colour bias for palette colours 8 ··· 16.
#define EV_VID_EDIT         29   // Channel number of video page for editor.
#define EV_KEY_EDIT         30   // Channel number of keyboard for editor.
#define EV_BUF_EDIT         31   // Size of edit buffer (in 256 byte pages).
#define EV_FLG_EDIT         32   // Flags to control reading from editor.
#define EV_SP_TAPE          33   // Non­zero to force slow tape saving.
#define EV_PROTECT          34   // Non­zero to make cassette write out protected file.
#define EV_LV_TAPE          35   // Controls tape output level
#define EV_REM1             36   // Cassette tape 1, zero for motor off, non­zero is on.
#define EV_REM2             37   // Cassette tape 2, zero for motor off, non­zero is on.
#define EV_SPRITE           38   // Controls external sprite colour priority.
#define EV_RANDOM_IRQ       39   // Incremented on every interrupt. Possibly a source of random numbers if accessed infrequently.


// Warnings
#define ERR_SHARE     0x7F  // Warn for a shared segment allocation

// Kernel error codes
#define ERR_IFUNC     0xFF  // Invalid EXOS function code
#define ERR_ILLFN     0xFE  // EXOS function call not allowed
#define ERR_INAME     0xFD  // Invalid EXOS string
#define ERR_STACK     0xFC  // Stack overflow
#define ERR_ICHAN     0xFB  // Channel does not exist
#define ERR_NODEV     0xFA  // Device does not exist
#define ERR_CHANX     0xF9  // Channel exists
#define ERR_NOBUF     0xF8  // No channel RAM allocated
#define ERR_NORAM     0xF7  // Insufficient Memory
#define ERR_NOVID     0xF6  // Insufficient Video Memory
#define ERR_NOSEG     0xF5  // No segment available when an allocate segment call is made
#define ERR_ISEG      0xF4  // Attempt to free a segment which is not allocated to the user or device.
#define ERR_IBOUND    0xF3  // Attempt to set the user boundary above the EXOS boundary in the shared segment.
#define ERR_IVAR      0xF2  // Unknown EXOS variable number
#define ERR_IDESC     0xF1  // Invalid device descriptor
#define ERR_NOSTR     0xF0  // Unrecognised command string
#define ERR_ASCII     0xEF  // Invalid file header
#define ERR_ITYPE     0xEE  // Unknown module type
#define ERR_IREL      0xED  // Invalid relocatable module
#define ERR_NOMOD     0xEC  // Indicates that the "load module" has finished in a controlled manner.
#define ERR_ITIME     0xEB  // Invalid date or time value

// General Device Errors
#define ERR_ISPEC     0xEA  // Invalid special function call
#define ERR_2NDCH     0xE9  // Attempt to open a further channel to a device which only allows one channel.
#define ERR_IUNIT     0xE8  // Invalid unit number
#define ERR_NOFN      0xE7  // Call not supported by this device
#define ERR_ESC       0xE6  // Invalid escape sequence
#define ERR_STOP      0xE5  // STOP key pressed
#define ERR_EOF       0xE4  // End Of File
#define ERR_PROT      0xE3  // Protection violation

// Device Specific Errors
#define ERR_KFSPC     0xE2  // KEYBOARD - Function key string too long
#define ERR_SENV      0xE1  // SOUND    - Envelope too big
#define ERR_SENBF     0xE0  // SOUND    - Envelope storage full
#define ERR_SQFUK     0xDF  // SOUND    - Sound queue full
#define ERR_VSIZE     0xDE  // VIDEO    - Invalid video page size
#define ERR_VMODE     0xDD  // VIDEO    - Invalid video mode
#define ERR_VDISP     0xDC  // VIDEO    - Invalid display parameters
#define ERR_VROW      0xDA  // VIDEO    - Invalid row number to scroll 
#define ERR_VCURS     0xD9  // VIDEO    - (+ EDITOR) Invalid cursor coordinates
#define ERR_VBEAM     0xD8  // VIDEO    - Invalid beam position
#define ERR_SEROP     0xD7  // NET      - (+ SERIAL) Cannot use both serial and network
#define ERR_NOADR     0xD6  // NET      - Network address not set
#define ERR_NETOP     0xD5  // NET      - Network link exists

#define ERR_EVID      0xD4  // EDITOR   - Editor video channel error
#define ERR_EKEY      0xD3  // EDITOR   - Editor keyboard channel error
#define ERR_EDINV     0xD2  // EDITOR   - Editor load file error
#define ERR_EDBUF     0xD1  // EDITOR   - Editor load file too big
#define ERR_CCRC      0xD0  // CASSETTE - Cassette CRC error

// Globally declared device names
extern char DEV_VIDEO[];
extern char DEV_KEYBOARD[];
extern char DEV_NET[];
extern char DEV_EDITOR[];
extern char DEV_SERIAL[];
extern char DEV_TAPE[];
extern char DEV_PRINTER[];
extern char DEV_SOUND[];

// Default EXOS channel numbers
#define DEFAULT_VIDEO    0x66
#define DEFAULT_SOUND    0x67
#define DEFAULT_PRINTER  0x68
#define DEFAULT_KEYBOARD 0x69


// Structure to support the ESC sequences with exos_write_block

// Video related / generic sequences
extern char          esccmd[];
extern unsigned char esccmd_cmd;
extern int           esccmd_x;
extern int           esccmd_y;
extern unsigned char esccmd_p1;
extern unsigned char esccmd_p2;
extern unsigned char esccmd_p3;
extern unsigned char esccmd_p4;
extern unsigned char esccmd_p5;
extern unsigned char esccmd_p6;
extern unsigned char esccmd_p7;
extern unsigned char esccmd_p8;
extern unsigned char esccmd_p9;
// Sound production (esc S)
extern unsigned char esccmd_env;
extern unsigned int  esccmd_p;
extern unsigned char esccmd_vl;
extern unsigned char esccmd_vr;
extern unsigned char esccmd_sty;
extern unsigned char esccmd_ch;
extern unsigned int  esccmd_d;
extern unsigned char esccmd_f;
// Envelope definition (esc E)
extern unsigned char esccmd_en;
extern unsigned char esccmd_ep;
extern unsigned char esccmd_er;
// Single phase sequence (6 bytes)
extern char          esccmd_phase[];
extern int           esccmd_cp;
extern char          esccmd_cl;
extern char          esccmd_cr;
extern unsigned int  esccmd_pd;



// Kernel Functions

extern int __LIB__              set_exos_variable(int variable, int value) __smallc;
extern int __LIB__    set_exos_variable_callee(int variable, int value) __smallc __z88dk_callee;
#define set_exos_variable(a,b)      set_exos_variable_callee(a,b)

extern int __LIB__  get_exos_variable(int variable) __z88dk_fastcall;
extern int __LIB__  toggle_exos_variable(int variable) __z88dk_fastcall;
extern int __LIB__  set_exos_multi_variables(char *vlist) __z88dk_fastcall;

extern int __LIB__              exos_capture_channel(int main_channel, int secondary_channel) __smallc;
extern int __LIB__    exos_capture_channel_callee(int main_channel, int secondary_channel) __smallc __z88dk_callee;
#define exos_capture_channel(a,b)   exos_capture_channel_callee(a,b)

extern int __LIB__  exos_channel_read_status(int channel) __z88dk_fastcall;

extern int __LIB__              exos_create_channel(int channel, char *device) __smallc;
extern int __LIB__    exos_create_channel_callee(int channel, char *device) __smallc __z88dk_callee;
#define exos_create_channel(a,b)    exos_create_channel_callee(a,b)

extern int __LIB__              exos_open_channel(int channel, char *device) __smallc;
extern int __LIB__    exos_open_channel_callee(int channel, char *device) __smallc __z88dk_callee;
#define exos_open_channel(a,b)      exos_open_channel_callee(a,b)

extern int __LIB__  exos_close_channel(int channel) __z88dk_fastcall;
extern int __LIB__  exos_destroy_channel(int channel) __z88dk_fastcall;

extern int __LIB__              exos_redirect_channel(int main_channel, int secondary_channel) __smallc;
extern int __LIB__    exos_redirect_channel_callee(int main_channel, int secondary_channel) __smallc __z88dk_callee;
#define exos_redirect_channel(a,b)  exos_redirect_channel_callee(a,b)


extern int __LIB__  exos_read_character(int channel) __z88dk_fastcall;

extern int __LIB__              exos_write_character(int channel, int character) __smallc;
extern int __LIB__    exos_write_character_callee(int channel,int character) __smallc __z88dk_callee;
#define exos_write_character(a,b)   exos_write_character_callee(a,b)

extern int __LIB__              exos_read_block(int channel, unsigned int byte_count, unsigned char *address) __smallc;
extern int __LIB__              exos_write_block(int channel, unsigned int byte_count, unsigned char *address) __smallc;

// Check if the line printer is ready (1=ready, 0 if not)
extern int __LIB__ lpt_ready();


// EXOS System Reset flags
#define WARM_RESET_KEEPUSR   16 // Forcibly de­allocate all channel RAM, and re-initialise all devices. User device will be retained. 
#define WARM_RESET_KEEPDEV   32	// User devices will be lost. Device segments are not de-allocated. 
#define WARM_RESET           64 // De­allocate all user RAM segments
#define COLD_RESET          128

extern void __LIB__   exos_system_reset(int flags) __z88dk_fastcall;

// EXOS System Information

struct EXOS_INFO {
	unsigned char	shared_segments;		// Shared segment number (0 if no shared segment) 
	unsigned char	free_segments;			// Number of free segments 
	unsigned char	user_segments;			// ...excluding the page­zero segment and the shared segment (if any)
	unsigned char	devices_segments;		// Segments allocated to devices.
	unsigned char	system_segments;		// ..including the shared segment (if any)
	unsigned char	working_segments;		// Total number of working RAM segments 
	unsigned char	nonworking_segments;	// Total number of non working RAM segments 
	unsigned char	unused;					// Total number of non working RAM segments 
};

// Updates status struct and returns the EXOS version number
extern int __LIB__   exos_system_status(struct EXOS_INFO info) __z88dk_fastcall;


// Sound functions

#define speaker_on()                  set_exos_variable_callee(EV_MUTE_SND,0)
#define speaker_off()                 set_exos_variable_callee(EV_MUTE_SND,255)
#define speaker_toggle()              toggle_exos_variable(EV_MUTE_SND)


// Tape functions

#define tape_sound_on()               set_exos_variable_callee(EV_TAPE_SND,0)
#define tape_sound_off()              set_exos_variable_callee(EV_TAPE_SND,255)
#define tape_sound_toggle()           toggle_exos_variable(EV_TAPE_SND)
#define tape1_motor_on()              set_exos_variable_callee(EV_REM1,255)
#define tape1_motor_off()             set_exos_variable_callee(EV_REM1,0)
#define tape1_motor_toggle()          toggle_exos_variable(EV_REM1)
#define tape2_motor_on()              set_exos_variable_callee(EV_REM2,255)
#define tape2_motor_off()             set_exos_variable_callee(EV_REM2,0)
#define tape2_motor_toggle()          toggle_exos_variable(EV_REM2)


// Keyboard functions

#define keyboard_click_on()           set_exos_variable_callee(EV_CLICK_KEY,0)
#define keyboard_click_off()          set_exos_variable_callee(EV_CLICK_KEY,255)
#define keyboard_click_toggle()       toggle_exos_variable(EV_CLICK_KEY)

#define KL_UNLOCKED    0
#define KL_CAPSLOCK    1
#define KL_SHIFTLOCK   2
#define KL_ALTLOCK     3

#define get_keylock_status()          get_exos_variable(EV_LOCK_KEY)


// Video constants
// video modes
#define VM_HW_TXT       0	// Hardware text mode (up to 42 columns)
#define VM_SW_TXT       2	// Software text mode (up to 84 columns)
#define VM_LRG          5	// Low Resolution Graphics
#define VM_HRG          1	// High Resolution Graphics
#define VM_ATTR        15	// Colour attribute mode
// color modes
#define CM_2            0	// Two colour mode 
#define CM_4            1	// Four colour mode 
#define CM_16           2	// Sixteen colour mode 
#define CM_256          3	// colour mode 


// Video functions

#define status_line_on()              set_exos_variable_callee(EV_ST_FLAG,0)
#define status_line_off()             set_exos_variable_callee(EV_ST_FLAG,255)
#define status_line_toggle()          toggle_exos_variable(EV_ST_FLAG)

// Set video mode (see the video constants above) 
// Size is char units y_size = 1..255 (max 27 visible at once),  x_size = 1..42
extern void __LIB__             exos_set_vmode(int video_mode, int color_mode, int x_size, int y_size) __smallc;
// Set the visible boundaries for video page 
extern int __LIB__              exos_display_page(int channel, int first_row, int rows, int first_row_position) __smallc;
extern int __LIB__  exos_reset_font(int channel) __z88dk_fastcall;



#endif
