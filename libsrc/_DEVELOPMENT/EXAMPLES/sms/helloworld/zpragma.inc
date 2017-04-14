// Standard SMS Header

#pragma output   SMS_HDR_PRODUCT_CODE = 107026
#pragma output   SMS_HDR_VERSION      = 1
#pragma output   SMS_HDR_REGION       = 0x3
#pragma output   SMS_HDR_ROM_SIZE     = 0x1              // ignored; rom size is always set to 32k

// SDSC Header - not generated if no SDSC pragmas are present

#pragma output   SDSC_HDR_VERSION     = 199
#pragma output   SDSC_HDR_DATE        = 20170414         // if omitted current date is used
#pragma redirect SDSC_HDR_AUTHOR      = _author          // character string in program
#pragma redirect SDSC_HDR_NAME        = _name            // character string in program
#pragma redirect SDSC_HDR_DESCRIPTION = _description     // character string in program

// Eliminate Unused Printf Converters

#pragma printf = ""         // generates a reference to printf so only employ if using printf()

// Output Terminal Options

#pragma output CRT_OTERM_CHAR_PATTERN_OFFSET = -32       // ascii code 32 of the font will be mapped to character 0
#pragma output CRT_OTERM_WINDOW_WIDTH = 32
#pragma output CRT_OTERM_WINDOW_HEIGHT = 12
