; void PSGSetMusicVolumeAttenuation(unsigned char attenuation)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGSetMusicVolumeAttenuation

EXTERN asm_PSGlib_SetMusicVolumeAttenuation

_PSGSetMusicVolumeAttenuation:

   pop af
   pop hl
   push hl
   push af

   jp asm_PSGlib_SetMusicVolumeAttenuation
