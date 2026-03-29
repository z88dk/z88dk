/*
  Return default disk device, i.e. as set by the HDOS SET DEFAULT
  command. Return value is a three character string terminated in a
  null, e.g. "SY0" or "DK1". Only works on HDOS 3 as previous versions
  have no concept of a default device.
*/

#include <arch/hdos.h>

char *default_device()
{
    static char s[4];

    /* Stored as 3 bytes from $006A-$006C (HDOS 3 only) */
    memcpy(s, 0x6a, 3);
    s[3] = 0; // Null terminate.

    return s;
}
