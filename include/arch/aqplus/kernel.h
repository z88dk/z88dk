#ifndef AQPLUS_KERNEL_H
#define AQPLUS_KERNEL_H

// Aquarius+ Kernel Routines
// System Routines
#define AUX_CALL 0x2100          // Call routine in auxillary ROM
#define EXT_CALL 0x2103          // Call routine in extended ROM
#define GFX_CALL 0x2106          // Call graphics routine
#define STR_COPY 0x2109          // Copy null-terminated string
#define STR_LENGTH 0x210c        // Get null-terminated string length
#define PRINT_C_STRING 0x210f    // Print null-terminated string
#define PRINT_STRING_IMMD 0x2112 // Print inline null terminated string
#define STR_STRINGDESC 0x2115    // Build descriptor for null terminated string
#define STR_TEMPDESC 0x2118      // Build descriptor for null terminated string in DSCTMP
#define UPPERCASE_CHAR 0x211b    // Convert character to lowercase
#define LOWERCASE_CHAR 0x211e    // Convert character to uppercase
#define SYS_FILL_MEM 0x2121      // Fill main memory with byte
#define SYS_SWAP_MEM 0x2124      // Swap bytes
#define KEY_CLEAR_FIFO 0x2127    // Clear alternate keyboard buffer
#define KEY_READ_ASCII 0x212a    // Read from alternate keyboard buffer
#define KEY_READ_SCANCODE 0x212d // Read scan code sequence from alternate keyboard buffer
#define KEY_SET_KEYMODE 0x2130   // Set alternate keyboard buffer mode
#define KEY_PRESSED 0x2133       // Check matrix for keypress
// ESP Interface
#define ESP_CMD 0x213c           // Issue command
#define ESP_CMD_STRING 0x213f    // Issue ESP command with string argument
#define ESP_GET_RESULT 0x2142    // Get first ESP result byte
#define ESP_CLOSE_ALL 0x2145     // Close all files and directories
#define ESP_GET_BYTE 0x2148      // Get byte into A
#define ESP_GET_BC 0x214b        // Get word into BC
#define ESP_GET_DE 0x214e        // Get word into DE
#define ESP_GET_LONG 0x2151      // Get long into BC,DE
#define ESP_GET_DATETIME 0x2154  // Read date and time into string buffer
#define ESP_GET_MOUSE 0x2157     // Read mouse position
#define ESP_GET_VERSION 0x215a   // Read system version
#define ESP_LOAD_FPGA 0x215d     // Load FPGA Core
#define ESP_READ_BUFF 0x2160     // Read bytes to string buffer
#define ESP_READ_BYTE 0x2163     // Read byte from ESP
#define ESP_READ_BYTES 0x2166    // Read bytes to main memory
#define ESP_READ_LINE 0x2169     // Read line from text file
#define ESP_READ_PAGED 0x216c    // Read bytes to paged memory
#define ESP_SEND_BYTE 0x216f     // Send byte in A
#define ESP_SEND_BC 0x2172       // Send word in BC
#define ESP_SEND_DE 0x2175       // Send word in DE
#define ESP_SEND_LONG 0x2178     // Send long in BC,DE
#define ESP_SEND_BYTES 0x217b    // Send bytes from main memory
#define ESP_SEND_STRING 0x217e   // Send String from main memory
#define ESP_SEND_STRDESC 0x2181  // Send BASIC string from main memory
#define ESP_SET_KEYMODE 0x2184   // Set alternate keyboard port mode
#define ESP_WRITE_BYTE 0x2187    // ** Not implemented **
#define ESP_WRITE_BYTES 0x218a   // Write bytes from main memory
#define ESP_WRITE_REPBYTE 0x218d // Write byte repeatedly
#define ESP_WRITE_PAGED 0x2190   // Write bytes from paged memory
// Paged Memory
#define PAGE_CHECK_NEXT4READ 0x219c  // Verify next page is valid for read
#define PAGE_CHECK_NEXT4WRITE 0x219f // Verify next page is valid for write
#define PAGE_CHECK_READ 0x21a2       // Verify page is valid for Read
#define PAGE_CHECK_WRITE 0x21a5      // Verify page is valid for Write
#define PAGE_COERCE_DE_ADDR 0x21a8   // Coerce address in to bank 3
#define PAGE_COERCE_HL_ADDR 0x21ab   // Coerce address in to bank 1
#define PAGE_COPY_BYTES 0x21ae       // Copy Bytes from Page to another Page
#define PAGE_FAST_COPY 0x21b1        // Copy bytes between pages with no rollover
#define PAGE_FAST_READ_BYTES 0x21b4  // Read bytes from page with no rollover
#define PAGE_FAST_WRITE_BYTES 0x21b7 // Write bytes to page with no rollover
#define PAGE_FILL_ALL_BYTE 0x21ba    // Fill entire page with byte
#define PAGE_FILL_ALL_WORD 0x21bd    // Fill entire page with word
#define PAGE_FILL_BYTE 0x21c0        // Fill paged memory with byte
#define PAGE_FILL_WORD 0x21c3        // Fill paged memory with word
#define PAGE_FULL_COPY 0x21c6        // Copy entire page to another page
#define PAGE_INC_DE_ADDR 0x21c9      // Increment Page 3 Write Address
#define PAGE_INC_HL_ADDR 0x21cc      // Increment Page 1 Write Address
#define PAGE_MAP_AUXROM 0x21cf       // Map Auxillary ROM into bank 3, saving original page
#define PAGE_MAP_EXTROM 0x21d2       // Map Extended ROM into bank 3, saving original page
#define PAGE_MAP_BANK1 0x21d5        // Map page into bank 1, saving original page
#define PAGE_MAP_BANK3 0x21d8        // Map page into bank 3, saving original page
#define PAGE_MAP_VIDRAM 0x21db       // Map Video RAM into bank 1, saving original page
#define PAGE_MEM_COMPARE 0x21de      // Compare main memory with paged memory
#define PAGE_MEM_SWAP_BYTES 0x21e1   // Swap paged memory with main memory
#define PAGE_NEXT_BANK1 0x21e4       // Map next Page into Bank 1
#define PAGE_NEXT_BANK3 0x21e7       // Map next Page into Bank 3
#define PAGE_NEXT_DE_ADDRESS 0x21ea  // Map next Page into Bank 3 and coerce address
#define PAGE_NEXT_HL_ADDRESS 0x21ed  // Map next Page into Bank 1 and coerce address
#define PAGE_PAGE_COMPARE 0x21f0     // Compare paged memory with paged memory
#define PAGE_READ_BYTE 0x21f3        // Read Byte from Page
#define PAGE_READ_BYTES 0x21f6       // Read bytes from paged memory to main memory
#define PAGE_READ_WORD 0x21f9        // Read Word from Page
#define PAGE_RESTORE_BANK1 0x21fc    // Restore original page to bank 1 and return
#define PAGE_RESTORE_BANK3 0x21ff    // Restore original page to bank 3 and return
#define PAGE_RESTORE_TWO 0x2202      // Restore original pages to banks 1 and 3
#define PAGE_SET_FOR_READ 0x2205     // Map Page into Bank 3 for write
#define PAGE_SET4READ_COERCE 0x2208  // Map Page into Bank 3 and coerce address to bank 3
#define PAGE_SET_FOR_WRITE 0x220b    // Map Page into Bank 3 for write
#define PAGE_SET4WRITE_COERCE 0x220e // Map Page into valid Bank 3 and coerce address to bank 3
#define PAGE_SET_AUX 0x2211          // Set bank 3 to Auxillary ROM page
#define PAGE_SET_BASBUF 0x2214       // Set bank 3 to BASIC buffer RAM page
#define PAGE_SET_PLUS 0x2217         // Set bank 3 to Extended ROM page
#define PAGE_SWAP_TWO 0x221a         // Map pages into banks 1 and 3, saving original pages
#define PAGE_WRITE_BYTE 0x221d       // Write Byte to Page
#define PAGE_WRITE_WORD 0x2220       // Write Word to Page
#define PAGE_WRITE_BYTES 0x2223      // Write Bytes to Page
// Extended ROM
#define GET_LINBUF_ADDR 0xc200 // Get Line Buffer Address
#define GET_STRBUF_ADDR 0xc203 // Get String Buffer Address
#define FLOAT_BC 0xc206        // Convert BC to unsigned float in FACC
#define FLOAT_DE 0xc209        // Convert DE to unsigned float in FACC
#define FLOAT_CDE 0xc20c       // Convert CDE to unsigned float in FACC
// DOS
#define DOS_CHANGE_DIR 0xc000  // Change Directory
#define DOS_CLOSE 0xc003       // Close file or directory
#define DOS_CLOSE_ALL 0xc006   // Close all files
#define DOS_CREATE_DIR 0xc009  // Create directory
#define DOS_DELETE 0xc00c      // Delete file/directory
#define DOS_STAT 0xc00f        // Return File Status
#define DOS_GET_CWD 0xc012     // Get Current Directory
#define DOS_OPEN 0xc015        // Open file
#define DOS_OPEN_APPEND 0xc018 // Open file for write
#define DOS_OPEN_DIR 0xc01b    // Open directory for read
#define DOS_OPEN_READ 0xc01e   // Open file for read
#define DOS_OPEN_WRITE 0xc021  // Open file for write
#define DOS_READ_DIR 0xc024    // Read directory entry
#define DOS_RENAME 0xc027      // Delete file/directory
#define DOS_REWIND 0xc02a      // Move to beginning of file
#define DOS_SEEK 0xc02d        // Move to position in file
#define DOS_TELL 0xc030        // Get current position in file
// File I/O
#define FILE_GET_DIR 0xc033      // Extract path from filespec
#define FILE_GET_EXT 0xc036      // Extract extension from filespec
#define FILE_TRIM_DIR 0xc03c     // Trim path from filespec
#define FILE_TRIM_EXT 0xc03f     // Trim extension from filespec
#define FILE_LOAD_BINARY 0xc042  // Load binary file into main memory
#define FILE_LOAD_CHRSET 0xc045  // Load file into alternate chrset buffer
#define FILE_LOAD_PAGED 0xc048   // Load binary file into paged memory
#define FILE_LOAD_PALETTE 0xc04b // Load and set palette
#define FILE_LOAD_PT3 0xc04e     // Load PT3 file into PT3 buffer
#define FILE_LOAD_ROM 0xc051     // Load ROM file into page 35
#define FILE_LOAD_SCREEN 0xc054  // Load screen image
#define FILE_LOAD_STRBUF 0xc057  // Load file into BASIC string buffer
#define FILE_SAVE_BINARY 0xc060  // Save binary file from main memory
#define FILE_SAVE_PAGED 0xc063   // Save file from paged memory
#define FILE_SAVE_PALETTE 0xc066 // Get and save palette
#define FILE_SAVE_SCREEN 0xc069  // Save screen image
#define FILE_SAVE_STRBUF 0xc06c  // Save BASIC string buffer to file
#define FILE_LOAD_DEFCHRS 0xc06f // Load file into default chrset buffer
#define FILE_LOAD_TILEMAP 0xc072 // Load tilemap
#define FILE_SAVE_TILEMAP 0xc075 // Save tilemap
#define FILE_SAVE_CHRSET 0xc078
#define FILE_READ_DIR 0xc081 // Read directory entry as ASCII string
// String Operations
#define STRING_TRIM 0xc090
#define STRING_TRIM_LEFT 0xc093
#define STRING_TRIM_RIGHT 0xc096
#define STRING_SEARCH 0xc099
#define STRING_SEARCH_ARRAY 0xc09c
// BASIC Line Buffer
#define BASBUF_READ_BYTE 0xc0a8
#define BASBUF_READ_BYTES 0xc0ab
#define BASBUF_READ_WORD 0xc0ae
#define BASBUF_WRITE_BYTE 0xc0b1
#define BASBUF_WRITE_BYTES 0xc0b4
#define BASBUF_WRITE_WORD 0xc0b7
#define RUNARG_COUNT 0xc0ba
#define RUNARG_GET 0xc0bd
// Bitmap Graphics
#define BITMAP_INIT_VARS 0xc0cc    // Initialize bitmap system variables
#define BITMAP_SET_MODE 0xc0cf     // Set bitmap mode system variable from video control register
#define BITMAP_READ_SYSVARS 0xc0d2 // Read bitmap system variables
#define BITMAP_READ_COLOR 0xc0d5   // Get Bitmap Draw Colors
#define BITMAP_WRITE_COLOR 0xc0d8  // Set Bitmap Draw Colors
#define BITMAP_CLEAR_SCREEN 0xc0db // Clear Bitmap
#define BITMAP_FILL_BYTE 0xc0de    // Fill Bitmap with Byte
#define BITMAP_FILL_COLOR 0xc0e1   // Fill Bitmap Color RAM
#define BITMAP_LINE 0xc0e4         // [Future]
#define BITMAP_SETPIXEL 0xc0f9     // Draw pixel
#define BITMAP_RESETPIXEL 0xc0fc   // Erase pixel on 1 bpp bitmap screen
#define BITMAP_GETPIXEL 0xc0ff     // Return pixel/bloxel at position
#define BITMAP_GET 0xc102          // [future] Read Bitmap Screen Section into Buffer
#define COLORMAP_FILL 0xc111       // Fill 1bpp Color Map Rectangle with Byte
// Palette and Colors
#define PALETTE_RESET 0xc120 // Reset palette to default colors
#define PALETTE_SET 0xc123   // palette_set
#define PALETTE_GET 0xc126   // Get palette
#define RGB_TO_ASC 0xc12c    // Convert Binary RGB list to ASCII
#define ASC_TO_RGB 0xc12f    // Convert ASCII RRGGBB to binary GB0R
// Text Screen Read and Write
#define SCREEN_CLEAR_COLOR 0xc144  // Fill Color RAM with current/default colors
#define SCREEN_READ_BYTE 0xc150    // Read byte from screen
#define SCREEN_WRITE_BYTE 0xc153   // Write byte to screen
#define SCREEN_READ_STRING 0xc156  // Read string from Screen RAM
#define SCREEN_WRITE_STRING 0xc159 // Write string to Screen RAM
#define SCREEN_READ_PAGED 0xc162
#define SCREEN_WRITE_PAGED 0xc165
#define SCREEN_READ_FAST 0xc168
#define SCREEN_WRITE_FAST 0xc16b
#define OOLOR_READ_BYTE 0xc174     // Read byte from Color RAM
#define COLOR_WRITE_BYTE 0xc177    // Write byte to Color RAM
#define COLOR_READ_STRING 0xc17a   // Read string from Color RAM
#define COLOR_WRITE_STRING 0xc17d  // Write string to Color RAM
#define SCREEN_CLEAR_CURSOR 0xc18c // Remove cursor from screen
#define SCREEN_INVERT_COLOR 0xc192
#define SCREEN_INVERT_CURSOR 0xc195
#define SCREEN_GET 0xc19e  // Read Text Screen Section into Buffer
#define SCREEN_PUT 0xc1a1  // Write Text Screen Section from Buffer
#define SCREEN_FILL 0xc1a4 // Fill Text or Color Screen Rectangle with Byte
// Text Screen Switch and Swap
#define INIT_SCREEN_BUFFERS 0xc1b0
#define INIT_SCREEN_VARS 0xc1b3
#define SCREEN_RESET 0xc1bc
#define SCREEN_STATUS 0xc1bf
#define SCREEN_RESTORE 0xc1c8
#define SCREEN_STASH 0xc1cb
#define SCREEN_SWAP 0xc1ce
#define SCREEN_SWITCH 0xc1d1
// Tilemap
#define TILE_SET 0xc1da
#define TILE_GET 0xc1dd
#define TILE_FROM_CHRROM 0xc1e0
#define TILE_COMBINE_PROPS 0xc1e3
#define TILEMAP_SET_OFFSET 0xc1ec
#define TILEMAP_GET_OFFSET 0xc1ef
#define TILEMAP_SET_TILE 0xc1f2
#define TILEMAP_GET_TILE 0xc1f5
#define TILEMAP_FILL 0xc1f8
#define TILEMAP_GET 0xc1fb
#define TILEMAP_PUT 0xc1fe

#endif // AQPLUS_KERNEL_H
