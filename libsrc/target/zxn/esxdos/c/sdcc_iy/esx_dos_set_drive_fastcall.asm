; unsigned char esx_dos_set_drive(unsigned char drive)

SECTION code_esxdos

PUBLIC _esx_dos_set_drive_fastcall

EXTERN asm_esx_dos_set_drive

_esx_dos_set_drive_fastcall:

   push iy
   
   call asm_esx_dos_set_drive
   
   pop iy
   ret
