
###############################################################
# Generate Segment Data
#
# $1 = driver name
# $2 = instance name
# $3 = attach ds* ? (always attaches, used as buffer size)
# $4 = FILE* for output console
# $5 = debounce in ms (default=0)
# $6 = repeatbegin in ms (default=500)
# $7 = repeatperiod in ms (default=15)
#
# Labels to the driver's local data will have the form:
#
# $2_cons_input_kbd_inkey_L1_LABELNAME
###############################################################

###############################################################
# BSS SEGMENT - EXTERNAL

define(`M4_cons_input_kbd_inkey_L1_PUT_SEGMENT_BSS_DEFVARS',dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = `cons_input_kbd_inkey_L1,' instance = $2

   defvars -1
   {
      $2_cons_input_kbd_inkey_L1_edit_buffer    ds.b $3
   }
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)


###############################################################
# BSS SEGMENT - ATTACHED

define(`M4_cons_input_kbd_inkey_L1_PUT_SEGMENT_BSS_DEFS',dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = `cons_input_kbd_inkey_L1,' instance = $2

   $2_cons_input_kbd_inkey_L1_edit_buffer:      defs $3
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)


###############################################################
# DATA SEGMENT - EXTERNAL

define(`M4_cons_input_kbd_inkey_L1_PUT_SEGMENT_DATA_DEFVARS',dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = `cons_input_kbd_inkey_L1,' instance = $2

   defvars -1
   {
      $2_cons_input_kbd_inkey_L1_file_state	ds.b 14
   }
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)


###############################################################
# DATA SEGMENT - ATTACHED

define(`M4_cons_input_kbd_inkey_L1_PUT_SEGMENT_DATA_DEFB',dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = `cons_input_kbd_inkey_L1,' instance = $2
   
   $2_cons_input_kbd_inkey_L1_file_state:
   
      defw $4
      defw $2_cons_input_kbd_inkey_L1_edit_buffer
      defw $2_cons_input_kbd_inkey_L1_edit_buffer
      defb $3
      defb 1
      defb 0
      defb ifdef($5,$5,0)
      defw ifdef($6,$6,500)
      defw ifdef($7,$7,15)
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)


###############################################################
# DATA SEGMENT - STORED

define(`M4_cons_input_kbd_inkey_L1_PUT_SEGMENT_DATA_S_DEFB',dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = `cons_input_kbd_inkey_L1,' instance = $2
   
   $2_cons_input_kbd_inkey_L1_file_state_s:
   
      defw $4
      defw $2_cons_input_kbd_inkey_L1_edit_buffer
      defw $2_cons_input_kbd_inkey_L1_edit_buffer
      defb $3
      defb 1
      defb 0
      defb ifdef($5,$5,0)
      defw ifdef($6,$6,500)
      defw ifdef($7,$7,15)
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)

