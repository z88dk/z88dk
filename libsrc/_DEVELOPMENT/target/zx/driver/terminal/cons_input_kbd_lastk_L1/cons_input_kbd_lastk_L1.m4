
###############################################################
# Generate Segment Data
#
# $1 = driver name
# $2 = instance name
# $3 = attach ds* ? (always attaches, used as buffer size)
# $4 = FILE* for output console
#
# Labels to the driver's local data will have the form:
#
# $2_cons_input_kbd_lastk_L1_LABELNAME
###############################################################

###############################################################
# BSS SEGMENT - EXTERNAL

define(`M4_cons_input_kbd_lastk_L1_PUT_SEGMENT_BSS_DEFVARS',dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = `cons_input_kbd_lastk_L1,' instance = $2

   defvars -1
   {
      $2_cons_input_kbd_lastk_L1_edit_buffer    ds.b $3
   }
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)


###############################################################
# BSS SEGMENT - ATTACHED

define(`M4_cons_input_kbd_lastk_L1_PUT_SEGMENT_BSS_DEFS',dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = `cons_input_kbd_lastk_L1,' instance = $2

   $2_cons_input_kbd_lastk_L1_edit_buffer:      defs $3
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)


###############################################################
# DATA SEGMENT - EXTERNAL

define(`M4_cons_input_kbd_lastk_L1_PUT_SEGMENT_DATA_DEFVARS',dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = `cons_input_kbd_lastk_L1,' instance = $2

   defvars -1
   {
      $2_cons_input_kbd_lastk_L1_file_state	ds.b 7
   }
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)


###############################################################
# DATA SEGMENT - ATTACHED

define(`M4_cons_input_kbd_lastk_L1_PUT_SEGMENT_DATA_DEFB',dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = `cons_input_kbd_lastk_L1,' instance = $2
   
   $2_cons_input_kbd_lastk_L1_file_state:
   
      defw $4
      defw $2_cons_input_kbd_lastk_L1_edit_buffer
      defw $2_cons_input_kbd_lastk_L1_edit_buffer
      defb $3
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)


###############################################################
# DATA SEGMENT - STORED

define(`M4_cons_input_kbd_lastk_L1_PUT_SEGMENT_DATA_S_DEFB',dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = `cons_input_kbd_lastk_L1,' instance = $2
   
   $2_cons_input_kbd_lastk_L1_file_state_s:
   
      defw $4
      defw $2_cons_input_kbd_lastk_L1_edit_buffer
      defw $2_cons_input_kbd_lastk_L1_edit_buffer
      defb $3
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)

