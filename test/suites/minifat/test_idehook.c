/* Mount, write, and read back through the ticks IDE hook. */
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "fatfs.h"

extern uint8_t ticks_put_sector(uint32_t lba, uint8_t *buf);

static uint8_t sector[512];
static uint8_t got[8];
static FATFS fs;
static FIL fil;

static void put_le16(uint8_t *p, uint16_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
}

static int fail(void)
{
    puts("IDEHOOK_FAIL");
    return 1;
}

int main(void)
{
    FRESULT fr;
    UINT n;

    memset(sector, 0, 512);
    sector[0] = 0xEB;
    sector[1] = 0x3C;
    sector[2] = 0x90;
    memcpy(sector + 3, "MSDOS5.0", 8);
    put_le16(sector + 11, 512);
    sector[13] = 1;
    put_le16(sector + 14, 1);
    sector[16] = 1;
    put_le16(sector + 17, 16);
    put_le16(sector + 19, 43);
    sector[21] = 0xF8;
    put_le16(sector + 22, 1);
    sector[510] = 0x55;
    sector[511] = 0xAA;
    if (ticks_put_sector(0, sector) != 0)
        return fail();

    memset(sector, 0, 512);
    sector[0] = 0xF8;
    sector[1] = 0xFF;
    sector[2] = 0xFF;
    if (ticks_put_sector(1, sector) != 0)
        return fail();

    fr = f_mount(&fs, "0:", 1);
    if (fr != FR_OK)
        return fail();
    fr = f_open(&fil, "HELLO.TXT", FA_WRITE | FA_CREATE_ALWAYS);
    if (fr != FR_OK)
        return fail();
    n = 0;
    fr = f_write(&fil, "Hi", 2, &n);
    if (fr != FR_OK || n != 2)
        return fail();
    fr = f_close(&fil);
    if (fr != FR_OK)
        return fail();

    memset(&fs, 0, sizeof fs);
    memset(&fil, 0, sizeof fil);
    fr = f_mount(&fs, "0:", 1);
    if (fr != FR_OK)
        return fail();
    fr = f_open(&fil, "HELLO.TXT", FA_READ);
    if (fr != FR_OK)
        return fail();
    n = 0;
    memset(got, 0, sizeof got);
    fr = f_read(&fil, got, 8, &n);
    f_close(&fil);
    if (fr != FR_OK || n != 2 || got[0] != 'H' || got[1] != 'i')
        return fail();
    puts("IDEHOOK_OK");
    return 0;
}
