; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION data_clib
SECTION data_SMSlib

PUBLIC __SMSlib_clipWin_x0
PUBLIC __SMSlib_clipWin_y0
PUBLIC __SMSlib_clipWin_x1
PUBLIC __SMSlib_clipWin_y1

; must be in this order

__SMSlib_clipWin_x0:

   defb 0

__SMSlib_clipWin_y0:

   defb 0

__SMSlib_clipWin_x1:

   defb 255

__SMSlib_clipWin_y1:

   defb 191
