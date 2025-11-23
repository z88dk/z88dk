; unsigned char esx_f_closedir(unsigned char handle)

SECTION code_esxdos

PUBLIC _esx_f_closedir_fastcall

EXTERN _esx_f_close_fastcall

defc _esx_f_closedir_fastcall = _esx_f_close_fastcall
