dnl############################################################
dnl##           LEAVE EMPTY SLOT IN FD TABLE                 ##
dnl############################################################
dnl##                                                        ##
dnl## m4_file_absent                                         ##
dnl##                                                        ##
dnl############################################################
dnl
define(`m4_file_absent', dnl

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; FILE ABSENT
   ; fd   : __I_FCNTL_NUM_FD
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; empty fd table entry
   
   SECTION data_fcntl_fdtable_body
   defw 0
   
   ; FDSTRUCT structure
   
   defc __i_fcntl_fdstruct_`'__I_FCNTL_NUM_FD = 0

   `define(`__I_FCNTL_NUM_FD', incr(__I_FCNTL_NUM_FD))'dnl
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)dnl
