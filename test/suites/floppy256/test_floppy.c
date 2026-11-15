/* Mini-FAT through the real 256-byte floppy glue. The image is RAM.
   Init reports unit 0 ready without asking the hook, so a dead disk is
   FR_DISK_ERR and not FR_NOT_READY. */
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "fatfs.h"

#define NSECTS 8

extern uint8_t f256_image[];
extern uint8_t f256_fail;
extern unsigned char f256_init_unit(unsigned int unit) __z88dk_fastcall;
extern unsigned char f256_sp_stable(void);
extern unsigned char f256_wait_keeps(void);
extern void f256_quiet(void);

static int fails;
static FATFS fs;
static FIL fil;

static void expect(const char *name, int ok)
{
    printf("floppy_%s %s\n", name, ok ? "PASS" : "FAIL");
    if (!ok)
        ++fails;
}

static void put16(uint16_t off, uint16_t v)
{
    f256_image[off] = (uint8_t)v;
    f256_image[off + 1] = (uint8_t)(v >> 8);
}

static void make_fs(void)
{
    memset(f256_image, 0, NSECTS * 512);
    f256_image[0] = 0xEB;
    f256_image[1] = 0x3C;
    f256_image[2] = 0x90;
    memcpy(f256_image + 3, "MSDOS5.0", 8);
    put16(11, 512);
    f256_image[13] = 1;
    put16(14, 1);
    f256_image[16] = 1;
    put16(17, 16);
    put16(19, NSECTS);
    f256_image[21] = 0xF8;
    put16(22, 1);
    f256_image[510] = 0x55;
    f256_image[511] = 0xAA;
    f256_image[512] = 0xF8;
    f256_image[513] = 0xFF;
    f256_image[514] = 0xFF;
}

static void reset_vol(void)
{
    f256_quiet();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    memset(&fs, 0, sizeof fs);
    memset(&fil, 0, sizeof fil);
}

int main(void)
{
    FRESULT fr;
    UINT n;
    uint8_t got[4];

    expect("init0", f256_init_unit(0) == 1);
    expect("init1", f256_init_unit(1) == 0);
    expect("sp", f256_sp_stable() == 0);
    expect("wait", f256_wait_keeps() == 0);

    f256_fail = 255;
    reset_vol();
    make_fs();
    fr = f_mount(&fs, "0:", 1);
    expect("dead", fr == FR_DISK_ERR);

    f256_fail = 2;
    reset_vol();
    make_fs();
    fr = f_mount(&fs, "0:", 1);
    expect("retry", fr == FR_OK && fs.fs_type == 1);

    f256_fail = 0;
    reset_vol();
    make_fs();
    fr = f_mount(&fs, "0:", 1);
    expect("mount", fr == FR_OK && fs.fs_type == 1);
    fr = f_chdrive("1:");
    expect("drive1", fr == FR_INVALID_DRIVE);

    f256_fail = 2;
    fr = f_open(&fil, "HELLO.TXT", FA_WRITE | FA_CREATE_ALWAYS);
    expect("open", fr == FR_OK);
    n = 0;
    fr = f_write(&fil, "Hi", 2, &n);
    expect("write", fr == FR_OK && n == 2);
    fr = f_close(&fil);
    expect("close", fr == FR_OK);

    f256_fail = 0;
    fr = f_open(&fil, "HELLO.TXT", FA_READ);
    expect("reopen", fr == FR_OK);
    n = 0;
    memset(got, 0, sizeof got);
    fr = f_read(&fil, got, 2, &n);
    expect("read", fr == FR_OK && n == 2 && got[0] == 'H' && got[1] == 'i');
    fr = f_close(&fil);
    expect("read_close", fr == FR_OK);

    puts(fails ? "FLOPPY_BAD" : "FLOPPY_OK");
    return fails ? 1 : 0;
}
