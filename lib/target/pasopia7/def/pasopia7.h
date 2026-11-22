// Toshiba Pasopia 7: the ports and registers the console, the keyboard and
// the disk driver use


// The I/O map
//
//   0x08-0x0b  8255 #0: screen mode and configuration
//   0x0c-0x0f  8255 #1: video (plane register, attribute, palette)
//   0x10, 0x11 HD46505 (6845): register select, data
//   0x18-0x1b  expansion (pac2) slots
//   0x20-0x23  8255 #2: sound mute, data recorder
//   0x28-0x2b  Z80 CTC
//   0x30-0x33  Z80 PIO: the keyboard
//   0x3a, 0x3b SN76489 PSG 1 and 2
//   0x3c       memory control
//   0xe0-0xe6  floppy disk controller (below)


// Memory control (write)
//   bits 0-1 = 0, 3 BASIC ROM, 1 BASIC ROM and BIOS ROM, 2 all RAM
//   bit 2    = the video RAM window over 0x8000-0xbfff
//   bit 3    = the next I/O access is to the RAM at the port's address
#define MEM_MODE            0x3c

// The 8255 #2 port the memory control also writes to
#define MEM_CTRL            0x22

// V-RAM plane selection (8255 #1 port A)
#define VRAM_PLANE          0x0c

// Display control 1 (8255 #1 port B): xPPPxxxx, PPP = the text page, and
// the low four bits the attribute written with the green plane
#define DISP_CTRL           0x0d

// 8255 control port
#define CTL_PORT            0x0f

// Keyboard row scan (Z80 PIO port A): write the row to read
#define KEY_SCAN            0x30

// ... and the keys of it are read from here (port B), a pressed key a 0 bit
#define KEY_DATA            0x31

// Screen mode (8255 #0 port A): G.W.Cccc
//   G = graphics mode
//   W = 80/40 column mode
//   C = take the colour from ccc instead of the attribute
#define SCR_MODE            0x08

// 8255 #0 port B: vsync, raster/lcd, display bit
#define CRTC_CTRL           0x0b

// 8255 #1 port C: blinking, attribute wrap, palette select
#define VIDEO_MISC          0x0e


// The floppy disk controller (a uPD765A) and what the disk driver
// (libsrc/target/pasopia7/disk/pasopia7_disk.asm) uses of it


// Ports

// Main status register (read)
#define FDC_MSR             0xe4

// Data register
#define FDC_DATA            0xe5

// Terminal count: a write to FDC_TC_ON raises it, a write to FDC_TC_OFF
// drops it again (the value written is not used)
#define FDC_TC_ON           0xe2
#define FDC_TC_OFF          0xe0

// Control port (write)
//   bit 6 = the drive's motor
//   bit 7 = reset the controller
// A read has the controller's interrupt request in bit 7
#define FDC_CTRL            0xe6
#define FDC_CTRL_MOTOR      0x40
#define FDC_CTRL_RESET      0x80


// Main status register bits

// Request for master: the data register is ready for a byte
#define MSR_RQM             0x80

// Data direction: set if the controller has a byte for the CPU
#define MSR_DIO             0x40

// Non-DMA mode: a byte of the execution phase is waiting
#define MSR_NDM             0x20

// Controller busy: a command is running
#define MSR_CB              0x10

// Drives seeking or recalibrating (bits 0-3, a drive each)
#define MSR_DRIVES_BUSY     0x0f

// RQM and NDM together: a byte of a sector can be moved
#define MSR_BYTE            (MSR_RQM | MSR_NDM)


// Status registers

// The bits of ST0 that say how a seek or recalibrate ended: 0x20 is a
// normal end (the seek end bit alone, without the abnormal termination or
// invalid command bits)
#define ST0_END_MASK        0xe0
#define ST0_SEEK_END        0x20

// ST3 (sense drive status): bit 5 = the drive is ready
#define ST3_READY           0x20

// ST0 of a read or write: the termination bits, 0 for a normal one
#define ST0_TERMINATION     0xc0


// Commands

// Specify: the step rate and head unload time, then the head load time with
// bit 0 set for non-DMA mode
#define FDC_CMD_SPECIFY     0x03

// Sense drive status
#define FDC_CMD_SDS         0x04

// Recalibrate
#define FDC_CMD_RECALIBRATE 0x07

// Sense interrupt status
#define FDC_CMD_SIS         0x08

// Seek
#define FDC_CMD_SEEK        0x0f

// Write data, and read data: both in MFM (bit 6)
#define FDC_CMD_WRITE       0x45
#define FDC_CMD_READ        0x46


// The driver's errors (returned in hl) and its limits

#define FDC_E_NOTREADY      2
#define FDC_E_SEEK          3
#define FDC_E_FDC           4
#define FDC_E_TIMEOUT       5

// Attempts at a sector, and turns of the ready check before giving up on a
// drive
#define FDC_TRIES           3
#define FDC_SPINUP          0x3000
