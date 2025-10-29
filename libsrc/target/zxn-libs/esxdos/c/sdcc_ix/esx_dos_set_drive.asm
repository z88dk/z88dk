; unsigned char esx_dos_set_drive(unsigned char drive)

SECTION code_esxdos

PUBLIC _esx_dos_set_drive

EXTERN _esx_dos_set_drive_fastcall

_esx_dos_set_drive:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esx_dos_set_drive_fastcall
