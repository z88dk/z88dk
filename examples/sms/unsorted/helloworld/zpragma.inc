// Standard SMS Header

#pragma output   SMS_HDR_PRODUCT_CODE = 107026
#pragma output   SMS_HDR_VERSION      = 1
#pragma output   SMS_HDR_REGION       = 0x3
#pragma output   SMS_HDR_ROM_SIZE     = 0x1              // ignored; rom size is always set to 32k

// SDSC Header - not generated if no SDSC pragmas are present

#pragma output   SDSC_HDR_VERSION     = 199
#pragma output   SDSC_HDR_DATE        = 20170416         // if omitted current date is used
#pragma redirect SDSC_HDR_AUTHOR      = _author          // character string in program
#pragma redirect SDSC_HDR_NAME        = _name            // character string in program
#pragma redirect SDSC_HDR_DESCRIPTION = _description     // character string in program

// Eliminate Unused Printf Converters

#pragma printf = ""    // generates a reference to the printf core so only employ if actually using the printf() family

// Output Terminal Options

#pragma output CRT_OTERM_CHAR_PATTERN_OFFSET = -32       // ascii code 32 of the font will be mapped to tile 0
#pragma output CRT_OTERM_BACKGROUND_CHAR     = 0         // background tile is an absolute tile 0-511

#pragma output CRT_OTERM_WINDOW_X      = 4
#pragma output CRT_OTERM_WINDOW_WIDTH  = 24
#pragma output CRT_OTERM_WINDOW_Y      = 4
#pragma output CRT_OTERM_WINDOW_HEIGHT = 16
