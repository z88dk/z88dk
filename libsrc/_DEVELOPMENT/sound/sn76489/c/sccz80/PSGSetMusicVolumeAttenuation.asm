; void PSGSetMusicVolumeAttenuation(unsigned char attenuation)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGSetMusicVolumeAttenuation

EXTERN asm_PSGlib_SetMusicVolumeAttenuation

defc PSGSetMusicVolumeAttenuation = asm_PSGlib_SetMusicVolumeAttenuation

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _PSGSetMusicVolumeAttenuation
defc _PSGSetMusicVolumeAttenuation = PSGSetMusicVolumeAttenuation
ENDIF

