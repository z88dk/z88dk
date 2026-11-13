/* +test harness for mini-FAT. The volume is ticks hook_io device 0. */
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "fatfs.h"

#define DISK_NSECTS 48

extern uint8_t ticks_get_sector(uint32_t lba, uint8_t *buf) __smallc;
extern uint8_t ticks_put_sector(uint32_t lba, uint8_t *buf) __smallc;

uint8_t ram_nsect = DISK_NSECTS;

extern void rt_invalidate(void);
extern uint8_t rt_dir_ofs_wrap(void);
extern uint8_t rt_wflag(void);
extern uint32_t fat_fsi_lba;
extern uint8_t fat_fsi_dirty;
extern uint32_t fat_last_clst;

static uint8_t sec[512];
static uint16_t sec_lba = 0xFFFF;
static uint8_t sec_dirty;

/* Publish the cached sector. ide_read and ide_write call this first. */
void disk_flush(void)
{
    if (!sec_dirty)
        return;
    if (ticks_put_sector((uint32_t)sec_lba, sec) == 0)
        sec_dirty = 0;
}

static void disk_load(uint16_t lba)
{
    if (sec_dirty && sec_lba == lba)
        return;
    disk_flush();
    sec_lba = lba;
    sec_dirty = 0;
    if (ticks_get_sector((uint32_t)lba, sec) != 0)
        memset(sec, 0, 512);
}

static uint8_t disk_get(uint32_t off)
{
    disk_load((uint16_t)(off >> 9));
    return sec[off & 511u];
}

static void disk_set(uint32_t off, uint8_t v)
{
    disk_load((uint16_t)(off >> 9));
    sec[off & 511u] = v;
    sec_dirty = 1;
}

static void disk_fill(uint32_t off, uint8_t v, uint16_t n)
{
    while (n--) {
        disk_set(off, v);
        off++;
    }
}

static void disk_write(uint32_t off, const void *src, uint16_t n)
{
    const uint8_t *p;

    p = (const uint8_t *)src;
    while (n--)
        disk_set(off++, *p++);
}

static int disk_cmp(uint32_t off, const void *src, uint16_t n)
{
    const uint8_t *p;

    p = (const uint8_t *)src;
    while (n--) {
        if (disk_get(off++) != *p++)
            return 1;
    }
    return 0;
}

static void disk_put_sector(uint16_t lba, const uint8_t *src)
{
    if (sec_dirty && sec_lba != lba)
        disk_flush();
    memcpy(sec, src, 512);
    sec_lba = lba;
    sec_dirty = 1;
}

static void disk_put_le32(uint32_t off, uint32_t v)
{
    disk_set(off, (uint8_t)v);
    disk_set(off + 1, (uint8_t)(v >> 8));
    disk_set(off + 2, (uint8_t)(v >> 16));
    disk_set(off + 3, (uint8_t)(v >> 24));
}

static void disk_zero(void)
{
    uint8_t i;

    sec_dirty = 0;
    sec_lba = 0xFFFF;
    memset(sec, 0, 512);
    for (i = 0; i < DISK_NSECTS; ++i)
        ticks_put_sector(i, sec);
}

static int fails;

static void expect(const char *name, int ok)
{
    printf("minifat_%s %s\n", name, ok ? "PASS" : "FAIL");
    if (!ok)
        ++fails;
}

static void put_le16(uint8_t *p, uint16_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
}

static void put_le32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
    p[2] = (uint8_t)(v >> 16);
    p[3] = (uint8_t)(v >> 24);
}

static void put_vbr(uint8_t csize, uint16_t n_rootent, uint16_t fatsz, uint16_t tot)
{
    uint8_t s[512];

    memset(s, 0, 512);
    s[0] = 0xEB; s[1] = 0x3C; s[2] = 0x90;
    memcpy(s + 3, "MSDOS5.0", 8);
    put_le16(s + 11, 512);
    s[13] = csize;
    put_le16(s + 14, 1);
    s[16] = 1;
    put_le16(s + 17, n_rootent);
    put_le16(s + 19, tot);
    s[21] = 0xF8;
    put_le16(s + 22, fatsz);
    s[510] = 0x55;
    s[511] = 0xAA;
    disk_put_sector(0, s);
}

/* FAT32 SFD. fatsz 512 covers nclst 65526. RootEntCnt and FSVer are the cases under test. */
static void put_fat32(uint8_t csize, uint16_t nroot, uint16_t fsver)
{
    uint8_t s[512];

    memset(s, 0, 512);
    s[0] = 0xEB; s[1] = 0x58; s[2] = 0x90;
    memcpy(s + 3, "MSDOS5.0", 8);
    put_le16(s + 11, 512);
    s[13] = csize;
    put_le16(s + 14, 1);
    s[16] = 1;
    put_le16(s + 17, nroot);
    s[21] = 0xF8;
    put_le32(s + 32, 1u + 512u + (uint32_t)csize * 65526u);
    put_le32(s + 36, 512);
    put_le16(s + 42, fsver);
    put_le32(s + 44, 2);
    s[510] = 0x55;
    s[511] = 0xAA;
    disk_put_sector(0, s);
}

#ifdef MINIFAT_API
static FATFS api_fs;
static FIL api_fil;
static DIR api_dir;
static FILINFO api_info;
static char api_cwd[64];
static uint8_t api_buf[600];
static uint8_t api_got[600];
static uint32_t api_nfree;
static FATFS *api_pfs;

static void api_reset(void)
{
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_vbr(1, 16, 1, 43);
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(514,  0xFF);
    ram_nsect = 48;
    memset(&api_fs, 0, sizeof api_fs);
}

/* MBR with one partition at LBA 40. The boot sector is not a volume. */
static void put_dead_mbr(void)
{
    uint8_t s[512];

    memset(s, 0, 512);
    s[510] = 0x55;
    s[511] = 0xAA;
    put_le32(s + 454, 40);
    disk_put_sector(0, s);
}

static void test_api(void)
{
    FRESULT fr;
    UINT n;
    int i;

    api_reset();
    ram_nsect = 0;
    fr = f_mount(&api_fs, "0:", 1);
    expect("api_not_ready", fr == FR_NOT_READY);
    ram_nsect = 48;
    fr = f_mount(&api_fs, "0:", 0);
    expect("api_lazy_reg", fr == FR_OK);
    ram_nsect = 0;
    fr = f_open(&api_fil, "HELLO.TXT", FA_READ);
    expect("api_lazy_nr", fr == FR_NOT_READY);
    ram_nsect = 48;

    api_reset();
    put_dead_mbr();
    ram_nsect = 10;
    fr = f_mount(&api_fs, "0:", 0);
    expect("api_lazy_disk_reg", fr == FR_OK);
    fr = f_open(&api_fil, "HELLO.TXT", FA_READ);
    expect("api_lazy_disk", fr == FR_DISK_ERR);
    fr = f_mount(&api_fs, "0:", 1);
    expect("api_dead_media", fr == FR_DISK_ERR);
    ram_nsect = 48;

    api_reset();
    fr = f_mount(&api_fs, "0:", 1);
    expect("api_mount", fr == FR_OK && api_fs.fs_type == 1);

    fr = f_open(0, "NOPE.TXT", FA_READ);
    expect("api_null", fr == FR_INVALID_OBJECT);

    fr = f_open(&api_fil, "NOPE.TXT", FA_READ);
    expect("api_miss", fr == FR_NO_FILE);

    fr = f_chdrive("0:");
    expect("api_drive", fr == FR_OK);
    fr = f_chdrive("1:");
    expect("api_drive1", fr == FR_INVALID_DRIVE);

    api_nfree = 0;
    api_pfs = 0;
    fr = f_getfree("0:", &api_nfree, &api_pfs);
    expect("api_free0", fr == FR_OK && api_nfree == 40 && api_pfs == &api_fs);

    fr = f_open(&api_fil, "HELLO.TXT", FA_WRITE | FA_CREATE_ALWAYS);
    expect("api_creat", fr == FR_OK);
    n = 0;
    fr = f_write(&api_fil, "Hi", 2, &n);
    expect("api_wr", fr == FR_OK && n == 2);
    expect("api_tell", f_tell(&api_fil) == 2);
    expect("api_size", f_size(&api_fil) == 2);
    expect("api_err", f_error(&api_fil) == 0);
    fr = f_sync(&api_fil);
    expect("api_sync", fr == FR_OK && f_tell(&api_fil) == 2);
    fr = f_rewind(&api_fil);
    expect("api_rew", fr == FR_OK && f_tell(&api_fil) == 0 && f_size(&api_fil) == 2);
    fr = f_close(&api_fil);
    expect("api_close", fr == FR_OK);
    fr = f_sync(&api_fil);
    expect("api_sync_cl", fr == FR_INVALID_OBJECT);
    fr = f_sync(0);
    expect("api_sync_null", fr == FR_INVALID_OBJECT);

    fr = f_open(&api_fil, "HELLO.TXT", FA_CREATE_NEW | FA_WRITE);
    expect("api_new_ex", fr == FR_EXIST);
    fr = f_open(&api_fil, "NEW.TXT", FA_CREATE_NEW | FA_WRITE);
    expect("api_new_ok", fr == FR_OK);
    fr = f_close(&api_fil);
    expect("api_new_cl", fr == FR_OK);
    fr = f_open(&api_fil, "NOFILE.TXT", FA_OPEN_EXISTING);
    expect("api_old_miss", fr == FR_NO_FILE);
    fr = f_open(&api_fil, "HELLO.TXT", FA_OPEN_EXISTING);
    expect("api_old_ok", fr == FR_OK);
    n = 0;
    fr = f_read(&api_fil, api_got, 1, &n);
    expect("api_old_rd", fr == FR_DENIED);
    fr = f_close(&api_fil);
    expect("api_old_cl", fr == FR_OK);

    fr = f_open(&api_fil, "HELLO.TXT", FA_READ);
    expect("api_open", fr == FR_OK);
    n = 0;
    memset(api_got, 0, 8);
    fr = f_read(&api_fil, api_got, 8, &n);
    expect("api_rd", fr == FR_OK && n == 2 && api_got[0] == 'H' && api_got[1] == 'i');
    expect("api_eof", f_eof(&api_fil));
    fr = f_lseek(&api_fil, 1);
    expect("api_seek", fr == FR_OK);
    n = 0;
    fr = f_read(&api_fil, api_got, 1, &n);
    expect("api_rdi", fr == FR_OK && n == 1 && api_got[0] == 'i');
    fr = f_close(&api_fil);
    expect("api_close2", fr == FR_OK);

    memset(&api_info, 0, sizeof api_info);
    fr = f_stat("HELLO.TXT", &api_info);
    expect("api_stat", fr == FR_OK && api_info.fsize == 2 && api_info.fname[0] == 'H');

    fr = f_chmod("HELLO.TXT", AM_RDO, AM_RDO);
    expect("api_chmod", fr == FR_OK);
    fr = f_stat("HELLO.TXT", &api_info);
    expect("api_rdo", fr == FR_OK && (api_info.fattrib & AM_RDO) != 0);
    fr = f_open(&api_fil, "HELLO.TXT", FA_WRITE | FA_OPEN_ALWAYS);
    expect("api_rdo_open", fr == FR_DENIED);
    fr = f_chmod("HELLO.TXT", 0, AM_RDO);
    expect("api_unrdo", fr == FR_OK);
    memset(&api_info, 0, sizeof api_info);
    fr = f_stat("HELLO.TXT", &api_info);
    expect("api_rdo_clr", fr == FR_OK && (api_info.fattrib & AM_RDO) == 0);

    api_info.fdate = 0x5891;
    api_info.ftime = 0x8800;
    fr = f_utime("HELLO.TXT", &api_info);
    expect("api_utime", fr == FR_OK);
    memset(&api_info, 0, sizeof api_info);
    fr = f_stat("HELLO.TXT", &api_info);
    expect("api_time", fr == FR_OK && api_info.fdate == 0x5891 && api_info.ftime == 0x8800);

    fr = f_open(&api_fil, "HELLO.TXT", FA_WRITE | FA_OPEN_APPEND);
    expect("api_app_open", fr == FR_OK);
    n = 0;
    fr = f_write(&api_fil, "!", 1, &n);
    expect("api_app", fr == FR_OK && n == 1);
    fr = f_close(&api_fil);
    expect("api_app_cl", fr == FR_OK);
    fr = f_open(&api_fil, "HELLO.TXT", FA_READ);
    n = 0;
    memset(api_got, 0, 8);
    fr = f_read(&api_fil, api_got, 8, &n);
    expect("api_app_rd", fr == FR_OK && n == 3 &&
           api_got[0] == 'H' && api_got[1] == 'i' && api_got[2] == '!');
    fr = f_close(&api_fil);
    expect("api_app_rd_cl", fr == FR_OK);

    fr = f_mkdir("SUB");
    expect("api_mkdir", fr == FR_OK);
    fr = f_mkdir("SUB");
    expect("api_mkdir2", fr == FR_EXIST);

    fr = f_open(&api_fil, "SUB/A.TXT", FA_WRITE | FA_CREATE_ALWAYS);
    expect("api_sub", fr == FR_OK);
    n = 0;
    fr = f_write(&api_fil, "A", 1, &n);
    expect("api_suba", fr == FR_OK && n == 1);
    fr = f_close(&api_fil);
    expect("api_sub_cl", fr == FR_OK);

    fr = f_chdir("SUB");
    expect("api_cd", fr == FR_OK);
    fr = f_getcwd(api_cwd, (UINT)sizeof api_cwd);
    expect("api_cwd", fr == FR_OK && strcmp(api_cwd, "0:/SUB") == 0);
    fr = f_chdir("..");
    expect("api_cdup", fr == FR_OK);
    fr = f_getcwd(api_cwd, (UINT)sizeof api_cwd);
    expect("api_cwd0", fr == FR_OK && strcmp(api_cwd, "0:/") == 0);

    fr = f_opendir(&api_dir, "SUB");
    expect("api_od", fr == FR_OK);
    memset(&api_info, 0, sizeof api_info);
    fr = f_readdir(&api_dir, &api_info);
    expect("api_rd_a", fr == FR_OK && strcmp(api_info.fname, "A.TXT") == 0);
    memset(&api_info, 0, sizeof api_info);
    fr = f_readdir(&api_dir, &api_info);
    expect("api_rd_end", fr == FR_OK && api_info.fname[0] == 0);
    fr = f_closedir(&api_dir);
    expect("api_cdir", fr == FR_OK);

    fr = f_open(&api_fil, "GROW.DAT", FA_WRITE | FA_CREATE_ALWAYS);
    expect("api_grow_open", fr == FR_OK);
    fr = f_expand(&api_fil, 512, 2);
    expect("api_expand_bad", fr == FR_INVALID_PARAMETER);
    fr = f_expand(&api_fil, 512, 0);
    expect("api_expand0", fr == FR_OK && api_fil.objsize == 0);
    fr = f_expand(&api_fil, 512, 1);
    expect("api_expand", fr == FR_OK && api_fil.objsize == 512);
    fr = f_close(&api_fil);
    expect("api_grow_cl", fr == FR_OK);
    fr = f_open(&api_fil, "GROW.DAT", FA_READ);
    expect("api_grow_rd_open", fr == FR_OK);
    n = 0;
    memset(api_got, 0x5A, 512);
    fr = f_read(&api_fil, api_got, 512, &n);
    expect("api_grow_rd", fr == FR_OK && n == 512 && api_got[0] == 0 && api_got[511] == 0);
    expect("api_grow_eof", f_eof(&api_fil) != 0);
    fr = f_close(&api_fil);
    expect("api_grow_rd_cl", fr == FR_OK);

    for (i = 0; i < 600; ++i)
        api_buf[i] = (uint8_t)(i * 3 + 1);
    fr = f_open(&api_fil, "BIG.DAT", FA_WRITE | FA_CREATE_ALWAYS);
    expect("api_big_open", fr == FR_OK);
    n = 0;
    fr = f_write(&api_fil, api_buf, 600, &n);
    expect("api_big_wr", fr == FR_OK && n == 600);
    fr = f_close(&api_fil);
    expect("api_big_cl", fr == FR_OK);
    fr = f_open(&api_fil, "BIG.DAT", FA_READ);
    expect("api_big_rd_open", fr == FR_OK);
    n = 0;
    memset(api_got, 0, 600);
    fr = f_read(&api_fil, api_got, 600, &n);
    expect("api_big_rd", fr == FR_OK && n == 600 && memcmp(api_buf, api_got, 600) == 0);
    expect("api_big_eof", f_eof(&api_fil) != 0);
    fr = f_close(&api_fil);
    expect("api_big_rd_cl", fr == FR_OK);

    fr = f_open(&api_fil, "GAP.DAT", FA_WRITE | FA_CREATE_ALWAYS);
    expect("api_gap_open", fr == FR_OK);
    fr = f_lseek(&api_fil, 100);
    expect("api_gap_seek", fr == FR_OK && api_fil.objsize == 100);
    n = 0;
    fr = f_write(&api_fil, "Z", 1, &n);
    expect("api_gap_wr", fr == FR_OK && n == 1 && api_fil.objsize == 101);
    fr = f_close(&api_fil);
    expect("api_gap_cl", fr == FR_OK);
    fr = f_open(&api_fil, "GAP.DAT", FA_READ);
    expect("api_gap_rd_open", fr == FR_OK);
    fr = f_lseek(&api_fil, 100);
    n = 0;
    api_got[0] = 0;
    fr = f_read(&api_fil, api_got, 1, &n);
    expect("api_gap_rd", fr == FR_OK && n == 1 && api_got[0] == 'Z');
    fr = f_close(&api_fil);
    expect("api_gap_rd_cl", fr == FR_OK);

    fr = f_rename("HELLO.TXT", "BYE.TXT");
    expect("api_ren", fr == FR_OK);
    fr = f_stat("HELLO.TXT", &api_info);
    expect("api_ren_old", fr == FR_NO_FILE);
    fr = f_stat("BYE.TXT", &api_info);
    expect("api_ren_new", fr == FR_OK && api_info.fsize == 3 && api_info.fname[0] == 'B');

    fr = f_unlink("SUB");
    expect("api_ul_busy", fr == FR_DENIED);
    fr = f_unlink("SUB/A.TXT");
    expect("api_ul_a", fr == FR_OK);
    fr = f_unlink("SUB");
    expect("api_ul_sub", fr == FR_OK);
    fr = f_unlink("BYE.TXT");
    expect("api_ul_bye", fr == FR_OK);
    fr = f_unlink("GROW.DAT");
    expect("api_ul_grow", fr == FR_OK);
    fr = f_unlink("BIG.DAT");
    expect("api_ul_big", fr == FR_OK);
    fr = f_unlink("GAP.DAT");
    expect("api_ul_gap", fr == FR_OK);
    fr = f_unlink("NEW.TXT");
    expect("api_ul_new", fr == FR_OK);

    api_nfree = 0;
    fr = f_getfree("0:", &api_nfree, 0);
    expect("api_free1", fr == FR_OK && api_nfree == 40);
}
#endif

int main(void)
{
    uint8_t n[11];
    uint32_t clst, parent;
    uint8_t rc;

    disk_zero();

    /* FAT12 SFD: nclst=40, csize=1, 1 FAT, 16 root ents.
     * tot = 1 + 1 + 1 + 40 = 43. n_fatent = 42. */
    put_vbr(1, 16, 1, 43);
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(514,  0xFF);
    ram_nsect = 48;

    rc = fat_mount();
    expect("mount_fat12", rc == 0 && cpm_fat_vol.fs_type == 1 &&
           cpm_fat_vol.n_fatent == 42);
    {
        uint32_t nfree = 0;

        rc = fat_getfree(&nfree);
        expect("fat12_getfree", rc == 0 && nfree == 40);
    }
    /* Cluster 2 is even. Byte offset 3. Value 3 in the low 12 bits. */
    disk_set(512 + 3,  0x03);
    disk_set(512 + 4,  0x00);
    rt_invalidate();
    clst = 2;
    rc = fat_next(&clst);
    expect("fat12_next", rc == 0 && clst == 3);

    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_vbr(1, 16, 1, 43);
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(514,  0xFF);
    rc = fat_mount();
    clst = 0;
    rc = fat_alloc(&clst);
    expect("fat12_alloc", rc == 0 && clst == 2);
    rc = fat_sync();
    expect("fat12_alloc_eoc", rc == 0 &&
           disk_get(512 + 3) == 0xFF && disk_get(512 + 4) == 0x0F);
    fat_dirty();
    expect("fat_dirty", rt_wflag() != 0);
    rc = fat_sync();
    expect("fat_dirty_sync", rc == 0 && rt_wflag() == 0 &&
           disk_get(512 + 3) == 0xFF && disk_get(512 + 4) == 0x0F);

    /* Cluster 341 is odd. Offset 511 spans FAT sectors 1 and 2.
     * fatsz=2, nclst=400, tot = 1+2+1+400 = 404. The data area is
     * past this 48-sector image. Mount and fat_next stay in the FAT. */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_vbr(1, 16, 2, 404);
    disk_set(1023,  0xC0);
    disk_set(1024,  0xAB);
    rc = fat_mount();
    expect("mount_fat12_span", rc == 0 && cpm_fat_vol.fs_type == 1);
    clst = 341;
    rc = fat_next(&clst);
    expect("fat12_span", rc == 0 && clst == 0xABCu);

    rt_invalidate();

    /* Inject a FAT16 window: 8 data clusters, 16-bit FAT, root at LBA 2. */
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 2;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_rootent = 16;
    cpm_fat_vol.n_fatent = 10;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.dirbase = 3;
    cpm_fat_vol.database = 4;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 2;
    fat_cwd = 0;
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(514,  0xFF);
    disk_set(515,  0xFF);
    disk_set(1024,  0xF8);
    disk_set(1025,  0xFF);
    disk_set(1026,  0xFF);
    disk_set(1027,  0xFF);

    memset(n, ' ', 11);
    memcpy(n, "HELLO   TXT", 11);
    parent = 0;
    rc = fat_dir_open(&parent);
    expect("dir_open_root", rc == 0);

    {
        uint32_t lba;

        lba = 0;
        expect("clst2sect_clst0", fat_clst2sect(&lba) != 0);
        lba = 1;
        expect("clst2sect_clst1", fat_clst2sect(&lba) != 0);
        lba = 10;                   /* n_fatent */
        expect("clst2sect_nfatent", fat_clst2sect(&lba) != 0);
        lba = 9;
        rc = fat_clst2sect(&lba);
        expect("clst2sect_last", rc == 0 && lba == 11);
    }

    rc = dir_find(n);
    expect("find_missing", rc == 1);
    rc = dir_create(n);
    expect("create_hello", rc == 0);
    clst = 0;
    rc = fat_alloc(&clst);
    expect("alloc", rc == 0 && clst == 2);
    rc = dir_find(n);
    expect("find_hello", rc == 0 && fat_dir_ptr && fat_dir_ptr[0] == 'H');

    {
        uint32_t box[2];

        box[0] = clst;
        box[1] = 0xA5A5A5A5ul;
        rc = fat_next(&box[0]);
        expect("next_eoc", rc == 0 && box[0] == 0x0FFFFFFFul);
        expect("next_neighbor", box[1] == 0xA5A5A5A5ul);
    }

    {
        uint32_t box[2];

        box[0] = clst;
        box[1] = 0xA5A5A5A5ul;
        rc = fat_clst2sect(&box[0]);
        expect("clst2sect", rc == 0 && box[0] == 4);
        expect("clst2sect_neighbor", box[1] == 0xA5A5A5A5ul);
    }

    rc = fat_sync();
    expect("sync_alloc", rc == 0);
    expect("fat2_mirror",
           disk_get(512 + 4) == disk_get(1024 + 4) &&
           disk_get(512 + 5) == disk_get(1024 + 5) &&
           disk_get(512 + 4) == 0xFF && disk_get(512 + 5) == 0xFF);
    {
        uint32_t nfree = 0, n2 = 0;
        rc = fat_getfree(&nfree);
        expect("getfree_after_alloc", rc == 0 && nfree == 7);
        rc = fat_getfree(&n2);
        expect("getfree_cached", rc == 0 && n2 == 7 &&
               cpm_fat_vol.free_valid == 1 && cpm_fat_vol.free_clst == 7);
    }

    /* dir_zap uses dir_ptr in fatwin: re-find so the window is the directory. */
    parent = 0;
    rc = fat_dir_open(&parent);
    rc |= dir_find(n);
    rc |= dir_zap();
    rc |= fat_sync();
    expect("zap_sync", rc == 0);
    parent = 0;
    fat_dir_open(&parent);
    rc = dir_find(n);
    expect("find_after_zap", rc == 1);

    rc = fat_free(&clst);
    rc |= fat_sync();
    expect("free", rc == 0);
    expect("fat2_after_free",
           disk_get(512 + 4) == 0 && disk_get(1024 + 4) == 0);
    {
        uint32_t nfree = 0;
        rc = fat_getfree(&nfree);
        expect("getfree_after_free", rc == 0 && nfree == 8 &&
               cpm_fat_vol.free_clst == 8);
    }

    /* FAT32: high nibble 0xF0000000 is free; 0x00000001 is used. */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 3;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_fatent = 6;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.database = 3;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(514,  0xFF);
    disk_set(515,  0x0F);
    disk_set(516,  0xFF);
    disk_set(517,  0xFF);
    disk_set(518,  0xFF);
    disk_set(519,  0x0F);
    disk_set(523,  0xF0);          /* cluster 2: 0xF0000000 */
    disk_set(524,  0x01);          /* cluster 3: 1 */
    {
        uint32_t nfree = 0;

        rc = fat_getfree(&nfree);
        expect("getfree_fat32_nibble", rc == 0 && nfree == 3);
    }

    /* Full sector plus a short tail. FAT16: 256 entries, then 10.
     * Clusters 0 and 1 are the media words; cluster 2 is used.
     */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 2;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_fatent = 266;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.fatsz = 2;
    cpm_fat_vol.n_fats = 1;
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(514,  0xFF);
    disk_set(515,  0xFF);
    disk_set(516,  0xFF);
    disk_set(517,  0xFF);
    {
        uint32_t nfree = 0;

        rc = fat_getfree(&nfree);
        expect("getfree_fat16_span", rc == 0 && nfree == 263);
    }
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 3;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_fatent = 130;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.fatsz = 2;
    cpm_fat_vol.n_fats = 1;
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(514,  0xFF);
    disk_set(515,  0x0F);
    disk_set(516,  0xFF);
    disk_set(517,  0xFF);
    disk_set(518,  0xFF);
    disk_set(519,  0x0F);
    disk_set(520,  0x01);
    {
        uint32_t nfree = 0;

        rc = fat_getfree(&nfree);
        expect("getfree_fat32_span", rc == 0 && nfree == 127);
    }

    /* FAT32 put_fat keeps bits 28-31 (0xA0000000 -> EOC is 0xAFFFFFFF). */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 3;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_fatent = 6;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.database = 3;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(514,  0xFF);
    disk_set(515,  0x0F);
    disk_set(516,  0xFF);
    disk_set(517,  0xFF);
    disk_set(518,  0xFF);
    disk_set(519,  0x0F);
    disk_set(523,  0xA0);          /* cluster 2: 0xA0000000 */
    clst = 0;
    rc = fat_alloc(&clst);
    expect("alloc_fat32_nibble", rc == 0 && clst == 2);
    expect("put_fat32_nibble",
           disk_get(512 + 8) == 0xFF && disk_get(512 + 9) == 0xFF &&
           disk_get(512 + 10) == 0xFF && disk_get(512 + 11) == 0xAF);

    expect("dir_next_wrap", rt_dir_ofs_wrap() == 1);

    /* FAT#2 at LBA 3 is past ram_nsect=3: sync must fail and keep wflag. */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    ram_nsect = 3;
    cpm_fat_vol.fs_type = 2;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_rootent = 16;
    cpm_fat_vol.n_fatent = 10;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.dirbase = 0;
    cpm_fat_vol.database = 2;
    cpm_fat_vol.fatsz = 2;
    cpm_fat_vol.n_fats = 2;
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(514,  0xFF);
    disk_set(515,  0xFF);
    clst = 0;
    rc = fat_alloc(&clst);
    expect("alloc_fat2_short", rc == 0 && clst == 2);
    rc = fat_sync();
    expect("sync_fat2_fail", rc != 0);
    expect("wflag_sticky", rt_wflag() != 0);
    expect("fat1_eoc", disk_get(512 + 4) == 0xFF && disk_get(512 + 5) == 0xFF);
    expect("fat2_unwritten", disk_get(1536 + 4) == 0);
    ram_nsect = 48;

    /* FAT32 cluster 0 is dirbase as a cluster (LBA 3), not as an LBA. */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 3;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_rootent = 0;
    cpm_fat_vol.n_fatent = 16;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.dirbase = 2;
    cpm_fat_vol.database = 3;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    disk_set(512 + 8,  0xFF);
    disk_set(512 + 9,  0xFF);
    disk_set(512 + 10,  0xFF);
    disk_set(512 + 11,  0x0F);
    {
        uint8_t ent[32];
        uint32_t z;

        disk_write(2 * 512, "FATASDIR   ", 11);
        disk_set(2 * 512 + 11,  0x20);
        disk_write(3 * 512, "REALROOT   ", 11);
        disk_set(3 * 512 + 11,  AM_DIR);
        z = 0;
        rc = fat_dir_open(&z);
        expect("fat32_clst0_open", rc == 0);
        rc = fat_dir_read(ent);
        expect("fat32_clst0_ent", rc == 0 && memcmp(ent, "REALROOT   ", 11) == 0);
    }

    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 2;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_rootent = 16;
    cpm_fat_vol.n_fatent = 16;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.dirbase = 2;
    cpm_fat_vol.database = 3;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(514,  0xFF);
    disk_set(515,  0xFF);
    disk_set(516,  2);             /* FAT[2] = 2 */
    disk_set(517,  0);
    clst = 2;
    rc = fat_next(&clst);
    expect("fat_self_loop", rc != 0);

    /* FAT16 root must not walk into database (n_rootent=32, dirbase=2, data=3). */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 2;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_rootent = 32;
    cpm_fat_vol.n_fatent = 16;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.dirbase = 2;
    cpm_fat_vol.database = 3;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    disk_set(1024,  'A');
    disk_write(1536, "OVERREADTXT", 11);
    disk_set(1536 + 11,  0x20);
    parent = 0;
    rc = fat_dir_open(&parent);
    expect("nroot32_overlap_open", rc == 0);
    {
        uint8_t ent[32], i, saw;

        saw = 0;
        for (i = 0; i < 20; ++i) {
            rc = fat_dir_read(ent);
            if (rc || ent[0] == 0)
                break;
            if (memcmp(ent, "OVERREADTXT", 11) == 0)
                saw = 1;
        }
        expect("nroot32_overlap_read", saw == 0);
    }

    /* FAT16 $F800 is a cluster. $FFF7 is a bad-cluster error. $FFF8 and $FFFF are EOC. */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 2;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_rootent = 16;
    cpm_fat_vol.n_fatent = 10;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.dirbase = 3;
    cpm_fat_vol.database = 4;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(512 + 4,  0x00);
    disk_set(512 + 5,  0xF8);
    disk_set(512 + 6,  0xF7);
    disk_set(512 + 7,  0xFF);
    disk_set(512 + 8,  0xF8);
    disk_set(512 + 9,  0xFF);
    disk_set(512 + 10,  0xFF);
    disk_set(512 + 11,  0xFF);
    clst = 2;
    rc = fat_next(&clst);
    expect("fat16_f800", rc == 0 && clst == 0xF800ul);
    clst = 3;
    rc = fat_next(&clst);
    expect("fat16_fff7", rc != 0);
    clst = 4;
    rc = fat_next(&clst);
    expect("fat16_fff8", rc == 0 && clst == 0x0FFFFFFFul);
    clst = 5;
    rc = fat_next(&clst);
    expect("fat16_ffff", rc == 0 && clst == 0x0FFFFFFFul);

    /* 16 root entries, no trailing 0x00. The 17th read must not repeat the last name. */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 2;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_rootent = 16;
    cpm_fat_vol.n_fatent = 8;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.dirbase = 2;
    cpm_fat_vol.database = 3;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    {
        uint8_t ent[32];
        uint8_t i, bad;

        for (i = 0; i < 16; ++i) {
            uint8_t e[32];

            memset(e, 0, 32);
            memset(e, ' ', 11);
            e[0] = (uint8_t)('A' + i);
            e[11] = 0x20;
            disk_write(1024 + (unsigned)i * 32, e, 32);
        }
        parent = 0;
        rc = fat_dir_open(&parent);
        expect("fullroot_open", rc == 0);
        bad = 0;
        for (i = 0; i < 16; ++i) {
            rc = fat_dir_read(ent);
            if (rc || ent[0] != (uint8_t)('A' + i))
                bad = 1;
        }
        rc = fat_dir_read(ent);
        expect("fullroot_end", bad == 0 && rc != 0);
    }

    /* Sector 2 holds 16 names. Sector 3 is past ram_nsect. The next read is a disk error. */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 2;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_rootent = 32;
    cpm_fat_vol.n_fatent = 16;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.dirbase = 2;
    cpm_fat_vol.database = 4;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    ram_nsect = 3;
    {
        uint8_t ent[32];
        uint8_t i, bad;

        for (i = 0; i < 16; ++i) {
            uint8_t e[32];

            memset(e, 0, 32);
            memset(e, ' ', 11);
            e[0] = (uint8_t)('A' + i);
            e[11] = 0x20;
            disk_write(1024 + (unsigned)i * 32, e, 32);
        }
        parent = 0;
        rc = fat_dir_open(&parent);
        expect("dir_io_open", rc == 0);
        bad = 0;
        for (i = 0; i < 15; ++i) {
            rc = fat_dir_read(ent);
            if (rc || ent[0] != (uint8_t)('A' + i))
                bad = 1;
        }
        rc = fat_dir_read(ent);
        expect("dir_io_err", bad == 0 && rc != 0 && ent[0] == (uint8_t)('A' + 15));
    }
    ram_nsect = 48;

    /* Disk $05 is the character $E5. A search for $05 itself misses. */
    rt_invalidate();
    disk_fill(1024, 0, 512);
    disk_set(1024,  0x05);
    disk_write(1025, "ELLO    TXT", 10);
    disk_set(1024 + 11,  0x20);
    memset(n, ' ', 11);
    n[0] = 0xE5;
    memcpy(n + 1, "ELLO    TXT", 10);
    parent = 0;
    rc = fat_dir_open(&parent);
    rc |= dir_find(n);
    expect("find_e5_kanji", rc == 0);
    n[0] = 0x05;
    parent = 0;
    rc = fat_dir_open(&parent);
    rc = dir_find(n);
    expect("find_05_raw", rc == 1);

    /* Directory bytes in lower case match an upper-case search. */
    rt_invalidate();
    disk_fill(1024, 0, 512);
    disk_write(1024, "hello   txt", 11);
    disk_set(1024 + 11,  0x20);
    memset(n, ' ', 11);
    memcpy(n, "HELLO   TXT", 11);
    parent = 0;
    rc = fat_dir_open(&parent);
    rc |= dir_find(n);
    expect("find_fold", rc == 0);

    /* Mount: partial FAT16 root, 64 KB clusters, FAT32 root count and FSVer. */
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_vbr(1, 16, 16, 4104);
    rc = fat_mount();
    expect("mount_root16", rc == 0 && cpm_fat_vol.fs_type == 2);

    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_vbr(1, 1, 16, 4104);
    rc = fat_mount();
    expect("mount_root1", rc == 13);

    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_vbr(1, 17, 16, 4104);
    rc = fat_mount();
    expect("mount_root17", rc == 13);

    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_vbr(1, 0, 16, 4104);
    rc = fat_mount();
    expect("mount_root0", rc == 13);

    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_vbr(128, 16, 1, 4089);
    rc = fat_mount();
    expect("mount_csize128", rc == 19 && cpm_fat_vol.fs_type == 0);

    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_fat32(64, 0, 0);
    rc = fat_mount();
    expect("mount_fat32", rc == 0 && cpm_fat_vol.fs_type == 3 && cpm_fat_vol.csize == 64);

    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_fat32(64, 16, 0);
    rc = fat_mount();
    expect("mount_fat32_root", rc == 13);

    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_fat32(64, 0, 1);
    rc = fat_mount();
    expect("mount_fat32_fsver", rc == 13);

    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_fat32(128, 0, 0);
    rc = fat_mount();
    expect("mount_fat32_csize", rc == 19 && cpm_fat_vol.fs_type == 0);

    /* FAT32 markers, cluster count in the FAT16 band. Must not mount as FAT16. */
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 2;
    {
        uint8_t s0[512];

        memset(s0, 0, 512);
        s0[0] = 0xEB; s0[1] = 0x58; s0[2] = 0x90;
        memcpy(s0 + 3, "MSDOS5.0", 8);
        put_le16(s0 + 11, 512);
        s0[13] = 1;
        put_le16(s0 + 14, 1);
        s0[16] = 1;
        s0[21] = 0xF8;
        put_le32(s0 + 32, 8258);
        put_le32(s0 + 36, 65);
        put_le32(s0 + 44, 2);
        s0[510] = 0x55;
        s0[511] = 0xAA;
        disk_put_sector(0, s0);
    }
    rc = fat_mount();
    expect("mount_hole", rc != 0 && cpm_fat_vol.fs_type == 0 && cpm_fat_vol.n_rootent == 0);

    /* FAT16 layout with a FAT32 cluster count, and a plausible RootClus in the boot area. */
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 3;
    {
        uint8_t s0[512];

        memset(s0, 0, 512);
        s0[0] = 0xEB; s0[1] = 0x3C; s0[2] = 0x90;
        memcpy(s0 + 3, "MSDOS5.0", 8);
        put_le16(s0 + 11, 512);
        s0[13] = 1;
        put_le16(s0 + 14, 1);
        s0[16] = 1;
        put_le16(s0 + 17, 16);
        s0[21] = 0xF8;
        put_le16(s0 + 22, 512);
        put_le32(s0 + 32, 66040);
        put_le32(s0 + 44, 2);
        s0[510] = 0x55;
        s0[511] = 0xAA;
        disk_put_sector(0, s0);
    }
    rc = fat_mount();
    expect("mount_fat16_as_32", rc != 0 && cpm_fat_vol.fs_type == 0);

    /* FAT of $200000 sectors. The same shape with a smaller FAT still mounts. */
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_fat32(1, 0, 0);
    disk_put_le32(36, 0x00200000u);
    disk_put_le32(32, 0x00200000u + 1u + 0xFFF6u);
    rc = fat_mount();
    expect("mount_fatsz_cap", rc == 13 && cpm_fat_vol.fs_type == 0);

    /* fatsz $001FFFFF is the last size under that cap. nclst $FFF6 is FAT32. */
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_fat32(1, 0, 0);
    disk_put_le32(36, 0x001FFFFFu);
    disk_put_le32(32, 0x001FFFFFu + 1u + 0xFFF6u);
    rc = fat_mount();
    expect("mount_fatsz_fit", rc == 0 && cpm_fat_vol.fs_type == 3);

    /* nclst past 28 bits. fatsz stays under the cap, so the cover check would pass. */
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_fat32(1, 0, 0);
    disk_put_le32(36, 0x001FFFFFu);
    disk_put_le32(32, 0xFFFFFFFFu);
    rc = fat_mount();
    expect("mount_nclst_max", rc == 13 && cpm_fat_vol.fs_type == 0);

    /* nclst $00100000 is inside $0FFFFFF5. fatsz $2002 covers n_fatent $100002. */
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_fat32(1, 0, 0);
    disk_put_le32(36, 0x00002002u);
    disk_put_le32(32, 0x00102003u);
    rc = fat_mount();
    expect("mount_nclst_1m", rc == 0 && cpm_fat_vol.fs_type == 3);

    /* Root cluster at $10000 is past n_fatent on this small FAT32 volume. */
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    put_fat32(64, 0, 0);
    disk_put_le32(44, 0x00010000u);
    rc = fat_mount();
    expect("mount_rootclus_hi", rc == 13 && cpm_fat_vol.fs_type == 0);

    /* 2048 FAT16 root entries: 65536 bytes must not wrap to an empty root. */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 2;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_rootent = 2048;
    cpm_fat_vol.n_fatent = 8;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.dirbase = 0;
    cpm_fat_vol.database = 128;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    disk_fill(0, ' ', 11);
    disk_set(0,  'A');
    disk_set(11,  0x20);
    parent = 0;
    rc = fat_dir_open(&parent);
    expect("root2048_open", rc == 0);
    {
        uint8_t ent[32];

        rc = fat_dir_read(ent);
        expect("root2048_ent", rc == 0 && ent[0] == 'A');
    }

    /* 2048 entries claimed, but only one root sector before database. */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 2;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_rootent = 2048;
    cpm_fat_vol.n_fatent = 8;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.dirbase = 2;
    cpm_fat_vol.database = 3;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    disk_set(1024,  'A');
    disk_set(1024 + 11,  0x20);
    disk_write(1536, "OVERREADTXT", 11);
    disk_set(1536 + 11,  0x20);
    parent = 0;
    rc = fat_dir_open(&parent);
    expect("root2048_clamp_open", rc == 0);
    {
        uint8_t ent[32];
        uint8_t i, saw;

        saw = 0;
        for (i = 0; i < 20; ++i) {
            rc = fat_dir_read(ent);
            if (rc || ent[0] == 0)
                break;
            if (memcmp(ent, "OVERREADTXT", 11) == 0)
                saw = 1;
        }
        expect("root2048_clamp", saw == 0);
    }

    /* dir_create stores a leading 0xE5 as 0x05, so the slot is not deleted. */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 2;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_rootent = 16;
    cpm_fat_vol.n_fatent = 8;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.dirbase = 2;
    cpm_fat_vol.database = 3;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    parent = 0;
    rc = fat_dir_open(&parent);
    memset(n, ' ', 11);
    n[0] = 0xE5;
    memcpy(n + 1, "ELLO    TXT", 10);
    rc |= dir_create(n);
    rc |= fat_sync();
    expect("create_e5_store", rc == 0 && disk_get(1024) == 0x05
           && disk_cmp(1025, "ELLO    TXT", 10) == 0);
    rc = dir_find(n);
    expect("create_e5_find", rc == 0);
    n[0] = 0x05;
    rc = dir_find(n);
    expect("create_e5_raw", rc == 1);

    /* 2 → 3 → 2. Each step succeeds. The walk is longer than the FAT. */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 2;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_rootent = 16;
    cpm_fat_vol.n_fatent = 10;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.dirbase = 3;
    cpm_fat_vol.database = 4;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(514,  0xFF);
    disk_set(515,  0xFF);
    disk_set(512 + 4,  3);
    disk_set(512 + 6,  2);
    {
        uint32_t steps;
        uint8_t bad;

        steps = 0;
        bad = 0;
        clst = 2;
        while (steps < cpm_fat_vol.n_fatent) {
            rc = fat_next(&clst);
            if (rc || (clst & 0x0FFFFFFFul) >= 0x0FFFFFF8ul) {
                bad = 1;
                break;
            }
            steps++;
        }
        expect("cycle_two", bad == 0 && steps == cpm_fat_vol.n_fatent);
    }

    cpm_fat_vol.csize = 8;
    clst = 8388608ul;
    fat_clusters(&clst);
    expect("cl_8mb", clst == 2048);
    clst = 8388609ul;
    fat_clusters(&clst);
    expect("cl_round", clst == 2049);
    clst = 4096;
    fat_clusters(&clst);
    expect("cl_one", clst == 1);
    cpm_fat_vol.csize = 1;
    clst = 512;
    fat_clusters(&clst);
    expect("cl_512", clst == 1);
    clst = 513;
    fat_clusters(&clst);
    expect("cl_513", clst == 2);
    clst = 0;
    fat_clusters(&clst);
    expect("cl_zero", clst == 0);
    clst = 0xFFFFFFFFul;
    fat_clusters(&clst);
    expect("cl_over", clst == 0);
    cpm_fat_vol.csize = 128;
    clst = 65536ul;
    fat_clusters(&clst);
    expect("cl_64k", clst == 1);
    cpm_fat_vol.csize = 0;
    clst = 512;
    fat_clusters(&clst);
    expect("cl_nocs", clst == 0);

    /* New cluster data is zero before the FAT link is published. */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 2;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_fatent = 8;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.database = 4;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(514,  0xFF);
    disk_set(515,  0xFF);
    disk_fill(4 * 512, 0xA5, 512);
    clst = 0;
    rc = fat_alloc(&clst);
    expect("alloc_wipe", rc == 0 && clst == 2 &&
           disk_get(4 * 512) == 0 && disk_get(4 * 512 + 511) == 0);
    expect("alloc_wipe_fat",
           disk_get(512 + 4) == 0xFF && disk_get(512 + 5) == 0xFF);

    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 2;
    cpm_fat_vol.csize = 2;
    cpm_fat_vol.n_fatent = 6;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.database = 3;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(514,  0xFF);
    disk_set(515,  0xFF);
    disk_fill(3 * 512, 0x5A, 1024);
    clst = 0;
    rc = fat_alloc(&clst);
    expect("alloc_wipe_csize2", rc == 0 && clst == 2 &&
           disk_get(3 * 512) == 0 && disk_get(3 * 512 + 511) == 0 &&
           disk_get(4 * 512) == 0 && disk_get(4 * 512 + 511) == 0);

    /* FAT16 root stays fixed. A full table does not allocate a cluster. */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 2;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_rootent = 16;
    cpm_fat_vol.n_fatent = 8;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.dirbase = 2;
    cpm_fat_vol.database = 3;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    {
        uint8_t slot;

        for (slot = 0; slot < 16; ++slot) {
            disk_set(2 * 512 + slot * 32,  'A');
            disk_set(2 * 512 + slot * 32 + 11,  0x20);
        }
    }
    parent = 0;
    rc = fat_dir_open(&parent);
    memset(n, ' ', 11);
    memcpy(n, "NEWFILE TXT", 11);
    rc = dir_create(n);
    expect("fat16_root_full", rc == 1 && disk_get(512 + 4) == 0);

    /* FAT32 directory at EOC grows by one zeroed cluster. */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 3;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_fatent = 8;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.dirbase = 2;
    cpm_fat_vol.database = 3;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(514,  0xFF);
    disk_set(515,  0x0F);
    disk_set(516,  0xFF);
    disk_set(517,  0xFF);
    disk_set(518,  0xFF);
    disk_set(519,  0x0F);
    disk_set(512 + 8,  0xFF);
    disk_set(512 + 9,  0xFF);
    disk_set(512 + 10,  0xFF);
    disk_set(512 + 11,  0x0F);
    {
        uint8_t slot;

        for (slot = 0; slot < 16; ++slot) {
            disk_set(3 * 512 + slot * 32,  'B');
            disk_set(3 * 512 + slot * 32 + 11,  0x20);
        }
    }
    parent = 2;
    rc = fat_dir_open(&parent);
    expect("fat32_dir_open", rc == 0);
    memset(n, ' ', 11);
    memcpy(n, "STRETCH TXT", 11);
    rc = dir_create(n);
    rc |= fat_sync();
    expect("fat32_stretch", rc == 0);
    expect("fat32_stretch_link",
           disk_get(512 + 8) == 3 && disk_get(512 + 9) == 0 &&
           disk_get(512 + 10) == 0 && disk_get(512 + 11) == 0 &&
           disk_get(512 + 12) == 0xFF && disk_get(512 + 13) == 0xFF &&
           disk_get(512 + 14) == 0xFF && disk_get(512 + 15) == 0x0F);
    expect("fat32_stretch_name",
           disk_cmp(4 * 512, "STRETCH TXT", 11) == 0);

    /* Sync writes the two FSInfo fields and leaves the signatures. */
    rt_invalidate();
    disk_zero();
    memset(&cpm_fat_vol, 0, sizeof cpm_fat_vol);
    cpm_fat_vol.fs_type = 3;
    cpm_fat_vol.csize = 1;
    cpm_fat_vol.n_fatent = 8;
    cpm_fat_vol.fatbase = 1;
    cpm_fat_vol.database = 3;
    cpm_fat_vol.fatsz = 1;
    cpm_fat_vol.n_fats = 1;
    cpm_fat_vol.free_valid = 1;
    cpm_fat_vol.free_clst = 5;
    disk_set(512,  0xF8);
    disk_set(513,  0xFF);
    disk_set(514,  0xFF);
    disk_set(515,  0x0F);
    disk_set(516,  0xFF);
    disk_set(517,  0xFF);
    disk_set(518,  0xFF);
    disk_set(519,  0x0F);
    disk_set(6 * 512 + 0,  0x52);
    disk_set(6 * 512 + 1,  0x61);
    disk_set(6 * 512 + 2,  0x41);
    disk_set(6 * 512 + 3,  0x41);
    disk_set(6 * 512 + 484,  0x72);
    disk_set(6 * 512 + 485,  0x72);
    disk_set(6 * 512 + 486,  0x41);
    disk_set(6 * 512 + 487,  0x61);
    disk_set(6 * 512 + 510,  0x55);
    disk_set(6 * 512 + 511,  0xAA);
    fat_fsi_lba = 6;
    fat_fsi_dirty = 0;
    fat_last_clst = 0;
    clst = 0;
    rc = fat_alloc(&clst);
    expect("fsinfo_alloc", rc == 0 && clst == 2 && fat_fsi_dirty == 0);
    expect("fsinfo_free",
           disk_get(6 * 512 + 488) == 4 && disk_get(6 * 512 + 489) == 0 &&
           disk_get(6 * 512 + 490) == 0 && disk_get(6 * 512 + 491) == 0);
    expect("fsinfo_nxt",
           disk_get(6 * 512 + 492) == 2 && disk_get(6 * 512 + 493) == 0 &&
           disk_get(6 * 512 + 494) == 0 && disk_get(6 * 512 + 495) == 0);
    expect("fsinfo_sig",
           disk_get(6 * 512) == 0x52 && disk_get(6 * 512 + 484) == 0x72 &&
           disk_get(6 * 512 + 510) == 0x55 && disk_get(6 * 512 + 511) == 0xAA);

#ifdef MINIFAT_API
    test_api();
#endif
    puts(fails ? "MINIFAT_BAD" : "MINIFAT_OK");
    return fails ? 1 : 0;
}
