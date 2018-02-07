   ;# DRIVER INSTANTIATION
   ;# sets up a windowed output terminal on stdout

   ;# fd=0, stdin
   
   include(`../m4_file_absent.m4')dnl
   m4_file_absent

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
