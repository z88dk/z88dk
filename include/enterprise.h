/*
 * Headerfile for Enterprise 64/128 specific stuff
 *
 * $Id: enterprise.h,v 1.1 2011-03-14 11:36:48 stefano Exp $
 */

#ifndef __ENTERPRISE_H__
#define __ENTERPRISE_H__


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



// Kernel Functions
extern int __LIB__              set_exos_variable(unsigned char variable, unsigned char value);
extern int __LIB__ __CALLEE__   set_exos_variable_callee(unsigned char variable, unsigned char value);
extern int __LIB__ __FASTCALL__ get_exos_variable(unsigned char variable);
extern int __LIB__ __FASTCALL__ toggle_exos_variable(unsigned char variable);
extern int __LIB__ __FASTCALL__ set_exos_multi_variables(char *vlist);

extern int __LIB__              exos_create_channel(unsigned char channel, char *device);
extern int __LIB__ __CALLEE__   exos_create_channel_callee(unsigned char channel, char *device);
extern int __LIB__              exos_open_channel(unsigned char channel, char *device);
extern int __LIB__ __CALLEE__   exos_open_channel_callee(unsigned char channel, char *device);
extern int __LIB__ __FASTCALL__ exos_close_channel(unsigned char channel);
extern int __LIB__ __FASTCALL__ exos_destroy_channel(unsigned char channel);
extern int __LIB__ __FASTCALL__ exos_read_character(unsigned char channel);
extern int __LIB__              exos_write_character(unsigned char channel, unsigned char character);
extern int __LIB__ __CALLEE__   exos_write_character_callee(unsigned char channel, unsigned char character);

extern void __LIB__ __CALLEE__  exos_system_reset();


#define set_exos_variable(a,b)      set_exos_variable_callee(a,b)
#define exos_create_channel(a,b)    exos_create_channel_callee(a,b)
#define exos_open_channel(a,b)      exos_open_channel_callee(a,b)
#define exos_write_character(a,b)   exos_read_character_callee(a,b)


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

// Video functions

#define status_line_on()              set_exos_variable_callee(EV_ST_FLAG,0)
#define status_line_off()             set_exos_variable_callee(EV_ST_FLAG,255)
#define status_line_toggle()          toggle_exos_variable(EV_ST_FLAG)

extern int __LIB__              exos_display_page(unsigned char channel, unsigned char first_row, unsigned char rows, unsigned char first_row_position);
extern int __LIB__ __FASTCALL__ exos_reset_font(unsigned char channel);
extern void __LIB__             exos_set_vmode(unsigned char mode, unsigned char color, unsigned char x_size, unsigned char y_size);



#endif
