



// Execute a command on the SubCPU
// Entry: a = command
//        hl = buffer with bytes
//         b = number of input bytes
//         c = number of output bytes expected
#define SUB_EXECUTE         0xc92f

// Execute a command with no arguments and no return values
#define SUB_EXEC_CMD        0xe428

// SubCPU commands

// Returns year (be), month, mday, weekday, hour, minute, second
#define SUB_TIME_READ       0x01

// Returns: right = 0x33, 0x37 = left, up = 0x31, down = 0x35
#define SUB_STICK           0x02

// Trigger button 1: 0x00/0xff
#define SUB_STRIG0          0x03
// Trigger button 2
#define SUB_STRIG1          0x04

// Reads ram (addressLE in)
// Retursns byte data
#define SUB_TR6834_READ     0x05

// Writes RAM: uint8_t data, addressLE
#define SUB_TR6834_WRITE        0x06

// Scroll min, scroll max - scrolls by character
#define SUB_SCROLL_SET      0x07

// Scroll
#define SUB_SCROLL_EXEC     0x08

// Clear line (row)
#define SUB_LINE_CLEAR      0x09

#define SUB_TIME_WRITE      0x0a

// Returns weekday
#define SUB_CALENDAR        0x0b

#define SUB_ALARM_WRITE    0x0c

#define SUB_BUZZER_ON       0x0d
#define SUB_BUZZER_OFF      0x0e

// Read an LCD line (param line), returns 120 values?
#define SUB_LCD_READ_LINE   0x0f

// Input: x,y
// Return: 0xff = set, 0x00 not set
#define SUB_LCD_POINT       0x10

// Input: x,y
// Sets point
#define SUB_LCD_PSET        0x11

// Input: x,y
// Resets point
#define SUB_LCD_PRESET      0x12

// Input: x,y
// xors point
#define SUB_LCD_PEOR        0x13

// Input x1,y1,x2,y2
// Draws a line
#define SUB_LCD_LINE        0x14

// Input x,y,r
// Draws a line
#define SUB_LCD_CIRCLE      0x15

#define SUB_UDK_WRITE       0x16
#define SUB_UDK_READ        0x17
#define SUB_UDK_ON          0x18
#define SUB_UDK_OFF         0x19

// Define a character
// Input: a code (128 -> 159) or 224+
// 8 bytes of data
#define SUB_UDC_WRITE       0x1a

// Read a character
// Input: char code
// Output: 8 bytes of character
#define SUB_UDC_READ        0x1b

// Reset the UDC
#define SUB_UDC_INIT        0x1c

#define SUB_PROG_WRITE      0x1d
#define SUB_PROG_WRITE2     0x1e
#define SUB_PROG_ON         0x1f
#define SUB_PROG_OFF        0x20
#define SUB_PROG_STATUS     0x21

#define SUB_ON_STATE        0x22
#define SUB_TURN_OFF        0x23

// Prints a character to screen
// Input: x,y, char code
#define SUB_LOCATE          0x24

#define SUB_CURSOR_ON       0x25
#define SUB_CURSOR_OFF      0x26

// Read a key row
// Input: 16 bits, row matrix index
// Output: State of that io port
#define SUB_READ_KEY_ROW    0x27

// Test a key
// Input: code
// Output: 0x00/0xff
#define SUB_TEST_KEYCODE    0x28

#define SUB_INIT_SEC        0x29
#define SUB_INIT_DATE       0x2a

#define SUB_LCD_OFF         0x2b
#define SUB_LCD_ON          0x2c

// Clear keyboard buffer
#define SUB_KBD_CLEAR       0x2d

// Clear display
#define SUB_CLS             0x2e

// Go to (0,0)
#define SUB_HONE            0x2f

#define SUB_DUDK_ON         0x30
#define SUB_DUDK_OFF        0x31

#define SUB_REPEAT_ON       0x32
#define SUB_REPEAT_OFF      0x33

#define SUB_UDK_KANA        0x34
#define SUB_UDK_WRITE2      0x35

#define SUB_ALARM_READ      0x36
#define SUB_BUZZER_ZERO     0x37

#define SUB_CLICK_OFF       0x38
#define SUB_CLICK_ON        0x39

#define SUB_LOCATE_CLOSE    0x3a

#define SUB_KBD_ON          0x3b
#define SUB_KBD_OFF         0x3c

#define SUB_START_ON        0x3d
#define SUB_START_OFF       0x3e

#define SUB_SLEEP           0x3f

#define SUB_UDK_INIT        0x40

// Write 6x8 char at cursor
// Input: 8 bytes of data
#define SUB_CHAR_WRITE      0x41

// Read character from cursor
// Output: 8 bytes of data
#define SUB_CHAR_READ       0x42

#define SUB_SCANL           0x43
#define SUB_SCANR           0x44
#define SUB_TIME_CHK        0x45
#define SUB_ALARM_CHK       0x46


// Jumps to c1be
#define FW_PRINTC	0x009f
#define ROM_PRINTC	0xc1be

// XY position in screen copy 0x214
#define CONSOLE_COORDS   0x00b8




// Determine XY POS (hl=yx)
#define FW_CALC_XYPOS	0x0075
#define ROM_CALC_XYPOS	0xc250
