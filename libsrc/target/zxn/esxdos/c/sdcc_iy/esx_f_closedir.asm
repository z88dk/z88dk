; unsigned char esx_f_closedir(unsigned char handle)

SECTION code_esxdos

PUBLIC _esx_f_closedir

EXTERN _esx_f_close

defc _esx_f_closedir = _esx_f_close
