;Aquarius+ Kernel Routines

; System Routines
aux_call               equ $2100 ; Call routine in auxillary ROM
ext_call               equ $2103 ; Call routine in extended ROM
gfx_call               equ $2106 ; Call graphics routine
str_copy               equ $2109 ; Copy null-terminated string
str_length             equ $210C ; Get null-terminated string length
print_c_string         equ $210F ; Print null-terminated string
print_string_immd      equ $2112 ; Print inline null terminated string
str_stringdesc         equ $2115 ; Build descriptor for null terminated string
str_tempdesc           equ $2118 ; Build descriptor for null terminated string in DSCTMP
uppercase_char         equ $211B ; Convert character to lowercase
lowercase_char         equ $211E ; Convert character to uppercase
sys_fill_mem           equ $2121 ; Fill main memory with byte
sys_swap_mem           equ $2124 ; Swap bytes
key_clear_fifo         equ $2127 ; Clear alternate keyboard buffer
key_read_ascii         equ $212A ; Read from alternate keyboard buffer
key_read_scancode      equ $212D ; Read scan code sequence from alternate keyboard buffer
key_set_keymode        equ $2130 ; Set alternate keyboard buffer mode
key_pressed            equ $2133 ; Check matrix for keypress

; ESP Interface
esp_cmd                equ $213C ; Issue command
esp_cmd_string         equ $213F ; Issue ESP command with string argument
esp_get_result         equ $2142 ; Get first ESP result byte
esp_close_all          equ $2145 ; Close all files and directories
esp_get_byte           equ $2148 ; Get byte into A
esp_get_bc             equ $214B ; Get word into BC
esp_get_de             equ $214E ; Get word into DE
esp_get_long           equ $2151 ; Get long into BC,DE
esp_get_datetime       equ $2154 ; Read date and time into string buffer
esp_get_mouse          equ $2157 ; Read mouse position
esp_get_version        equ $215A ; Read system version
esp_load_fpga          equ $215D ; Load FPGA Core
esp_read_buff          equ $2160 ; Read bytes to string buffer
esp_read_byte          equ $2163 ; Read byte from ESP
esp_read_bytes         equ $2166 ; Read bytes to main memory
esp_read_line          equ $2169 ; Read line from text file
esp_read_paged         equ $216C ; Read bytes to paged memory
esp_send_byte          equ $216F ; Send byte in A
esp_send_bc            equ $2172 ; Send word in BC
esp_send_de            equ $2175 ; Send word in DE
esp_send_long          equ $2178 ; Send long in BC,DE
esp_send_bytes         equ $217B ; Send bytes from main memory
esp_send_string        equ $217E ; Send String from main memory
esp_send_strdesc       equ $2181 ; Send BASIC string from main memory
esp_set_keymode        equ $2184 ; Set alternate keyboard port mode
esp_write_byte         equ $2187 ; ** Not implemented **
esp_write_bytes        equ $218A ; Write bytes from main memory
esp_write_repbyte      equ $218D ; Write byte repeatedly
esp_write_paged        equ $2190 ; Write bytes from paged memory

; Paged Memory
page_check_next4read   equ $219C ; Verify next page is valid for read
page_check_next4write  equ $219F ; Verify next page is valid for write
page_check_read        equ $21A2 ; Verify page is valid for Read
page_check_write       equ $21A5 ; Verify page is valid for Write
page_coerce_de_addr    equ $21A8 ; Coerce address in to bank 3
page_coerce_hl_addr    equ $21AB ; Coerce address in to bank 1
page_copy_bytes        equ $21AE ; Copy Bytes from Page to another Page
page_fast_copy         equ $21B1 ; Copy bytes between pages with no rollover
page_fast_read_bytes   equ $21B4 ; Read bytes from page with no rollover
page_fast_write_bytes  equ $21B7 ; Write bytes to page with no rollover
page_fill_all_byte     equ $21BA ; Fill entire page with byte
page_fill_all_word     equ $21BD ; Fill entire page with word
page_fill_byte         equ $21C0 ; Fill paged memory with byte
page_fill_word         equ $21C3 ; Fill paged memory with word
page_full_copy         equ $21C6 ; Copy entire page to another page
page_inc_de_addr       equ $21C9 ; Increment Page 3 Write Address
page_inc_hl_addr       equ $21CC ; Increment Page 1 Write Address
page_map_auxrom        equ $21CF ; Map Auxillary ROM into bank 3, saving original page
page_map_extrom        equ $21D2 ; Map Extended ROM into bank 3, saving original page
page_map_bank1         equ $21D5 ; Map page into bank 1, saving original page
page_map_bank3         equ $21D8 ; Map page into bank 3, saving original page
page_map_vidram        equ $21DB ; Map Video RAM into bank 1, saving original page
page_mem_compare       equ $21DE ; Compare main memory with paged memory
page_mem_swap_bytes    equ $21E1 ; Swap paged memory with main memory
page_next_bank1        equ $21E4 ; Map next Page into Bank 1
page_next_bank3        equ $21E7 ; Map next Page into Bank 3
page_next_de_address   equ $21EA ; Map next Page into Bank 3 and coerce address
page_next_hl_address   equ $21ED ; Map next Page into Bank 1 and coerce address
page_page_compare      equ $21F0 ; Compare paged memory with paged memory
page_read_byte         equ $21F3 ; Read Byte from Page
page_read_bytes        equ $21F6 ; Read bytes from paged memory to main memory
page_read_word         equ $21F9 ; Read Word from Page
page_restore_bank1     equ $21FC ; Restore original page to bank 1 and return
page_restore_bank3     equ $21FF ; Restore original page to bank 3 and return
page_restore_two       equ $2202 ; Restore original pages to banks 1 and 3
page_set_for_read      equ $2205 ; Map Page into Bank 3 for write
page_set4read_coerce   equ $2208 ; Map Page into Bank 3 and coerce address to bank 3       ;
page_set_for_write     equ $220B ; Map Page into Bank 3 for write
page_set4write_coerce  equ $220E ; Map Page into valid Bank 3 and coerce address to bank 3
page_set_aux           equ $2211 ; Set bank 3 to Auxillary ROM page
page_set_basbuf        equ $2214 ; Set bank 3 to BASIC buffer RAM page
page_set_plus          equ $2217 ; Set bank 3 to Extended ROM page
page_swap_two          equ $221A ; Map pages into banks 1 and 3, saving original pages
page_write_byte        equ $221D ; Write Byte to Page
page_write_word        equ $2220 ; Write Word to Page
page_write_bytes       equ $2223 ; Write Bytes to Page

; Extended ROM
get_linbuf_addr        equ $C200 ; Get Line Buffer Address
get_strbuf_addr        equ $C203 ; Get String Buffer Address
FLOAT_BC               equ $C206 ; Convert BC to unsigned float in FACC
FLOAT_DE               equ $C209 ; Convert DE to unsigned float in FACC
FLOAT_CDE              equ $C20C ; Convert CDE to unsigned float in FACC

; DOS
dos_change_dir         equ $C000 ; Change Directory
dos_close              equ $C003 ; Close file or directory
dos_close_all          equ $C006 ; Close all files
dos_create_dir         equ $C009 ; Create directory
dos_delete             equ $C00C ; Delete file/directory
dos_stat               equ $C00F ; Return File Status
dos_get_cwd            equ $C012 ; Get Current Directory
dos_open               equ $C015 ; Open file
dos_open_append        equ $C018 ; Open file for write
dos_open_dir           equ $C01B ; Open directory for read
dos_open_read          equ $C01E ; Open file for read
dos_open_write         equ $C021 ; Open file for write
dos_read_dir           equ $C024 ; Read directory entry
dos_rename             equ $C027 ; Delete file/directory
dos_rewind             equ $C02A ; Move to beginning of file
dos_seek               equ $C02D ; Move to position in file
dos_tell               equ $C030 ; Get current position in file

; File I/O
file_get_dir           equ $C033 ; Extract path from filespec
file_get_ext           equ $C036 ; Extract extension from filespec
file_trim_dir          equ $C03C ; Trim path from filespec
file_trim_ext          equ $C03F ; Trim extension from filespec
file_load_binary       equ $C042 ; Load binary file into main memory
file_load_chrset       equ $C045 ; Load file into alternate chrset buffer
file_load_paged        equ $C048 ; Load binary file into paged memory
file_load_palette      equ $C04B ; Load and set palette
file_load_pt3          equ $C04E ; Load PT3 file into PT3 buffer
file_load_rom          equ $C051 ; Load ROM file into page 35
file_load_screen       equ $C054 ; Load screen image
file_load_strbuf       equ $C057 ; Load file into BASIC string buffer
file_save_binary       equ $C060 ; Save binary file from main memory
file_save_paged        equ $C063 ; Save file from paged memory
file_save_palette      equ $C066 ; Get and save palette
file_save_screen       equ $C069 ; Save screen image
file_save_strbuf       equ $C06C ; Save BASIC string buffer to file
file_load_defchrs      equ $C06F ; Load file into default chrset buffer
file_load_tilemap      equ $C072 ; Load tilemap
file_save_tilemap      equ $C075 ; Save tilemap
file_save_chrset       equ $C078 ;
file_read_dir          equ $C081 ; Read directory entry as ASCII string

; String Operations
string_trim            equ $C090 
string_trim_left       equ $C093 
string_trim_right      equ $C096 
string_search          equ $C099 
string_search_array    equ $C09C 

; BASIC Line Buffer
basbuf_read_byte       equ $C0A8 
basbuf_read_bytes      equ $C0AB 
basbuf_read_word       equ $C0AE 
basbuf_write_byte      equ $C0B1 
basbuf_write_bytes     equ $C0B4 
basbuf_write_word      equ $C0B7 
runarg_count           equ $C0BA 
runarg_get             equ $C0BD 

; Miscellaneous
pause_jiffies          equ $C0CC 
read_gamepad           equ $C0CF 

; Bitmap Graphics
bitmap_init_vars       equ $C100 ; Initialize bitmap system variables
bitmap_set_mode        equ $C103 ; Set bitmap mode system variable from video control register
bitmap_read_sysvars    equ $C106 ; Read bitmap system variables
bitmap_read_color      equ $C109 ; Get Bitmap Draw Colors
bitmap_write_color     equ $C10C ; Set Bitmap Draw Colors
bitmap_clear_screen    equ $C10F ; Clear Bitmap
bitmap_fill_byte       equ $C112 ; Fill Bitmap with Byte
bitmap_fill_color      equ $C115 ; Fill Bitmap Color RAM
bitmap_line            equ $C118 ; [Future]
bitmap_setpixel        equ $C12D ; Draw pixel
bitmap_resetpixel      equ $C130 ; Erase pixel on 1 bpp bitmap screen
bitmap_getpixel        equ $C133 ; Return pixel/bloxel at position
bitmap_get             equ $C136 ; [future] Read Bitmap Screen Section into Buffer
colormap_fill          equ $C145 ; Fill 1bpp Color Map Rectangle with Byte

; Palette and Colors
palette_reset          equ $C154 ; Reset palette to default colors
palette_set            equ $C157 ; palette_set
palette_get            equ $C15A ; Get palette
rgb_to_asc             equ $C160 ; Convert Binary RGB list to ASCII
asc_to_rgb             equ $C163 ; Convert ASCII RRGGBB to binary GB0R

; Text Screen Read and Write
screen_clear_color     equ $C178 ; Fill Color RAM with current/default colors
screen_read_byte       equ $C184 ; Read byte from screen
screen_write_byte      equ $C187 ; Write byte to screen
screen_read_string     equ $C18A ; Read string from Screen RAM
screen_write_string    equ $C18D ; Write string to Screen RAM
screen_read_paged      equ $C196 
screen_write_paged     equ $C199 
screen_read_fast       equ $C19C 
screen_write_fast      equ $C19F 
oolor_read_byte        equ $C1A8 ; Read byte from Color RAM
color_write_byte       equ $C1AB ; Write byte to Color RAM
color_read_string      equ $C1AE ; Read string from Color RAM
color_write_string     equ $C1B1 ; Write string to Color RAM
screen_clear_cursor    equ $C1C0 ; Remove cursor from screen
screen_invert_color    equ $C1C6 
screen_invert_cursor   equ $C1C9 
screen_get             equ $C1D2 ; Read Text Screen Section into Buffer
screen_put             equ $C1D5 ; Write Text Screen Section from Buffer
screen_fill            equ $C1D8 ; Fill Text or Color Screen Rectangle with Byte

; Text Screen Switch and Swap
init_screen_buffers    equ $C1E4 
init_screen_vars       equ $C1E7 
screen_reset           equ $C1F0 
screen_status          equ $C1F3 
screen_restore         equ $C1FC 
screen_stash           equ $C1FF 
screen_swap            equ $C202 
screen_switch          equ $C205 

; Tilemap
tile_set               equ $C20E 
tile_get               equ $C211 
tile_from_chrrom       equ $C214 
tile_combine_props     equ $C217 
tilemap_set_offset     equ $C220 
tilemap_get_offset     equ $C223 
tilemap_set_tile       equ $C226 
tilemap_get_tile       equ $C229 
tilemap_fill           equ $C22C 
tilemap_get            equ $C22F 
tilemap_put            equ $C232 
