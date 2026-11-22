dnl############################################################
dnl## INITIALIZE M4 VARIABLES USED FOR STATIC INSTANTIATIONS ##
dnl############################################################
dnl
dnl# __I_STDIO_NUM_FILE  = number of static FILEs instantiated in crt
dnl# __I_FCNTL_NUM_FD    = number of static file descriptors created
dnl# __I_FCNTL_HEAP_SIZE = byte size of static FDSTRUCTs
dnl# __I_FCNTL_NUM_HEAP  = number of allocations in heap

; When FILEs and FDSTRUCTs are instantiated labels are assigned
; to point at created structures.
;
; The label formats are:
;
; __i_stdio_file_n     = address of static FILE structure #n (0..__I_STDIO_NUM_FILE-1)
; __i_fcntl_fdstruct_n = address of static FDSTRUCT #n (0..__I_FCNTL_NUM_FD-1)
; __i_fcntl_heap_n     = address of allocation #n on heap (0..__I_FCNTL_NUM_HEAP-1)

define(`__I_STDIO_NUM_FILE', 0)dnl
define(`__I_FCNTL_NUM_FD', 0)dnl
define(`__I_FCNTL_HEAP_SIZE', 0)dnl
define(`__I_FCNTL_NUM_HEAP', 0)dnl
