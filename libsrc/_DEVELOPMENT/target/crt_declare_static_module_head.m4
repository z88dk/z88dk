
###############################################################
##             DECLARE STATIC MODULES PART 1                 ##
##   macros for statically declaring FILE structs in crts    ##
###############################################################

###############################################################
# Generate Segment Data
#
# $1 = driver name
# $2 = instance name
# $3 = attach ds* ? (0=no, see driver for specific meaning)
# more parameters forwarded to driver
#
# Labels to the driver's local data will have the form:
#
# $2_$1_LABELNAME
###############################################################


define(`M4_PUT_SEGMENT_BSS_DEFS', M4_$1`'_PUT_SEGMENT_BSS_DEFS($@))
define(`M4_PUT_SEGMENT_BSS_DEFVARS', M4_$1`'_PUT_SEGMENT_BSS_DEFVARS($@))

define(`M4_PUT_SEGMENT_DATA_DEFB', M4_$1`'_PUT_SEGMENT_DATA_DEFB($@))
define(`M4_PUT_SEGMENT_DATA_DEFVARS', M4_$1`'_PUT_SEGMENT_DATA_DEFVARS($@))
define(`M4_PUT_SEGMENT_DATA_S_DEFB', M4_$1`'_PUT_SEGMENT_DATA_S_DEFB($@))


###############################################################
# Statically Declare FILEs
#
# $1 = FILE instance name, FILE* label is "__FILE_$1"
# $2 = driver name
# $3 = driver instance name
# $4 = mode byte = 0x80 for write, 0x40 for read, 0xc0 for r/w
# $5 = driver flags (16-bit hex or dec number)
# $6 = attach ds * (0=no, leave undefined otherwise)
#
# See below for macros defining common mode and driver flags.
#
# Note that FILEs that require the host to allocate resources
# cannot be declared this way.  Instead those kinds of FILEs
# can be created in the crt startup by making an fopen() call.
###############################################################


define(`M4_FILE_MODE_R', 0x40)
define(`M4_FILE_MODE_W', 0x80)
define(`M4_FILE_MODE_RW', 0xc0)

define(`M4_FILE_DF_ITERM_SRELC', 0x03b1)   # cursor, crlf, echo, line, cook, input_terminal
define(`M4_FILE_DF_OTERM_C', 0x0012)       # cook, output_terminal

#####################################
# CREATE A FILE - DATA SEGMENT STORED

define(`M4_CREATE_FILE_DATA_S_DEFB',dnl
dnl
defw M4_OPEN_FILE_PTR
   
__FILE_$1_s:

   EXTERN $2
   
   defb 195		; JP instruction
   defw $2		; address of driver message dispatcher
   defb $4		; state_flags_0 = mode byte
   
   IF $4 & 0x40
   
      defb 0x02         ; state_flags_1 = make last operation a read
   
   ELSE
   
      defb 0            ; state_flags_1 = make last operation a write
   
   ENDIF
   
   defb 0		; printf conversion flags
   defb 0		; ungetc
   defb `0, 2, 0, 254, 0, 0'	; recursive mutex
   
   IF __CLIB_OPT_STDIO_FILE_EXTRA > 0
   
      defw $5
      defw ifdef($6,$6,$3_$2_file_state)
      
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 4
   
   ENDIF
)

#######################################
# CREATE A FILE - DATA SEGMENT ATTACHED

define(`M4_CREATE_FILE_DATA_DEFB',dnl
dnl
defw M4_OPEN_FILE_PTR
   
__FILE_$1:

   EXTERN $2
   
   defb 195		; JP instruction
   defw $2		; address of driver message dispatcher
   defb $4		; state_flags_0 = mode byte
   
   IF $4 & 0x40
   
      defb 0x02         ; state_flags_1 = make last operation a read
   
   ELSE
   
      defb 0            ; state_flags_1 = make last operation a write
   
   ENDIF
   
   defb 0		; printf conversion flags
   defb 0		; ungetc
   defb `0, 2, 0, 254, 0, 0'	; recursive mutex
   
   IF __CLIB_OPT_STDIO_FILE_EXTRA > 0
   
      defw $5
      defw ifdef($6,$6,$3_$2_file_state)
      
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 4
   
   ENDIF
)

#######################################
# CREATE A FILE - DATA SEGMENT EXTERNAL

define(`M4_CREATE_FILE_DATA_DEFVARS',dnl
dnl
defvars -1
   {
                                      ds.w 1
      __FILE_$1                       ds.b __CLIB_OPT_STDIO_FILE_EXTRA + 13
   }
)
