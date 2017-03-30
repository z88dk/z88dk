; void PSGSilenceChannels(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGSilenceChannels

EXTERN asm_PSGlib_SilenceChannels

defc _PSGSilenceChannels = asm_PSGlib_SilenceChannels
