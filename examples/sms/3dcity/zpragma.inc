// Standard SMS Header

#pragma output   SMS_HDR_PRODUCT_CODE = 000000
#pragma output   SMS_HDR_VERSION      = 100
#pragma output   SMS_HDR_REGION       = 0x4
#pragma output   SMS_HDR_ROM_SIZE     = 0x1              // ignored; rom size is always set to 32k

// SDSC Header - not generated if no SDSC pragmas are present

#pragma output   SDSC_HDR_VERSION     = 100
#pragma output   SDSC_HDR_DATE        = 20160327        // if omitted current date is used
#pragma redirect SDSC_HDR_AUTHOR      = _author          // character string in program
#pragma redirect SDSC_HDR_NAME        = _name            // character string in program
#pragma redirect SDSC_HDR_DESCRIPTION = _description     // character string in program

// Compress Stored Data Section to Reduce ROM Size

#pragma output CRT_MODEL = 2

// Start BSS after the music manager memory from 0xC100 to 0xC2xx
#pragma output CRT_ORG_BSS = 0xc300
