dnl############################################################
dnl## INITIALIZE M4 VARIABLES USED FOR STATIC INSTANTIATIONS ##
dnl############################################################
dnl
dnl# I_STDIO_FILE_NUM = number of static FILEs instantiated in crt
dnl# I_FCNTL_FD_NUM   = number of static file descriptors created
dnl# I_FCNTL_STDIO_HEAP_SIZE = byte size of static FDSTRUCTs

; When FILEs and FDSTRUCTs are instantiated labels are assigned
; to point at the start of each structure.
;
; The label formats are:
;
; i_fcntl_fdstruct_n = address of static FDSTRUCT #n (0..I_FCNTL_FD_NUM-1)
; i_stdio_file_n     = address of static FILE structure #n (0..I_STDIO_FILE_NUM-1)

define(`I_STDIO_FILE_NUM', 0)dnl
define(`I_FCNTL_FD_NUM', 0)dnl
define(`I_FCNTL_STDIO_HEAP_SIZE', 0)dnl
