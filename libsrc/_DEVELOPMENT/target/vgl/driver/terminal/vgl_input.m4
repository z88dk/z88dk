dnl############################################################
dnl##            VGL_INPUT STATIC INSTANTIATOR               ##
dnl############################################################
dnl##                                                        ##
dnl## m4_vgl_input(...)                                      ##
dnl##                                                        ##
dnl## $1 = label attached to FILE or 0 if fd only            ##
dnl## $2 = label attached to output FDSTRUCT or 0 if none    ##
dnl## $3 = ioctl_flags (16 bits)                             ##
dnl## $4 = size of edit buffer attached to FDSTRUCT or 0     ##
dnl## $5 = key debounce in ms (0 default)                    ##
dnl## $6 = key start repeat delay in ms (500 default)        ##
dnl## $7 = key repeat period in ms (15 default)              ##
dnl##                                                        ##
dnl############################################################

define(`m4_vgl_input',dnl

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; FILE  : `ifelse($1,0,`(none)',$1)'
   ;
   ; driver: vgl_input
   ; fd    : __I_FCNTL_NUM_FD
   ; mode  : read only
   ; type  : 001 = input terminal
   ; tie   : `ifelse($2,0,`(none)',$2)'
   ;
   ; ioctl_flags   : $3
   ; buffer size   : $4 bytes
   ; debounce      : $5 ms
   ; repeat_start  : $6 ms
   ; repeat_period : $7 ms
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


)dnl
