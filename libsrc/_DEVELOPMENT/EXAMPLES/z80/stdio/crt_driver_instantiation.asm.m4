   ;# DRIVER INSTANTIATION
   ;# sets up a windowed output terminal on stdout

   ;# fd=0, stdin

   include(`terminal/term_01_input_char.m4')
   m4_term_01_input_char(_stdin, __i_fcntl_fdstruct_1, 0x01b0, 64)

   ;# m4_term_01_input_char(file, connected output terminal, flags, edit buffer size)
   ;#   flags:
   ;#   bits 15..10  reserved (includes some state for driver base class)
   ;#   bit 9 = 1 to enable printed cursor
   ;#   bit 8 = 1 to enable crlf conversion (will be filtered to generate lf only)
   ;#   bit 7 = 1 to echo typed input characters
   ;#   bit 6 = 1 to enable password mode (input printed as *)
   ;#   bit 5 = 1 to enable line mode (input is edited before being delivered)
   ;#   bit 4 = 1 to enable cook mode (input characters are interpretted in some way)
   ;#   bit 3 = 1 for caps lock

   ;# fd=1, stdout

   include(`terminal/term_01_output_char.m4')dnl
   m4_term_01_output_char(_stdout, 0x2370, 0, 0, 0, 32, 0, 16, 0)dnl

   ;# m4_term_01_output_char(file, flags, cursor.x, cursor.y, window.x, window.width, window.y, window.height, scroll limit)
   ;#   flags:
   ;#   bit 13 = (page mode) 1 = clear on full screen, 0 = wrap on full screen
   ;#   bit  9 = enable signal bell
   ;#   bit  8 = enable bell
   ;#   bit  7 = page mode (1) or scroll mode (0)
   ;#   bit  6 = enable pause on full screen
   ;#   bit  5 = cook output chars
   ;#   bit  4 = enable crlf conversion (c side \n -> \r\n)

   ;# fd=2, stderr dup of stdout

   include(`../m4_file_dup.m4')dnl
   m4_file_dup(_stderr, 0x80, __i_fcntl_fdstruct_1)dnl
