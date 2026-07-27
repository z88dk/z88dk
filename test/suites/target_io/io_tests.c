/*
 * Shared serial + disk I/O tests for z88dk-ticks target coverage.
 *
 * Build with a fcntl backend and target-specific flags; see Makefile.
 */

#include <stdio.h>
#include <string.h>
#include "test.h"
#include "io_port.h"

static void test_printf_basic(void)
{
    int n;
    char buf[64];

    n = sprintf(buf, "%s %d %s", TIO_LABEL, 42, "ok");
    Assert(n > 0, "sprintf returned non-positive");
    /* Expected: "<LABEL> 42 ok" */
    Assert(strstr(buf, "42") != 0, "sprintf embeds number");
    Assert(strstr(buf, "ok") != 0, "sprintf embeds string");

    printf("printf_serial_ok\n");
#ifdef __8085
    printf("cpu=8085\n");
#elif defined(__8080)
    printf("cpu=8080\n");
#else
    printf("cpu=z80\n");
#endif
}

static void test_sscanf(void)
{
    int a, b, r;
    char s[16];
    unsigned u;
    long L;

    r = sscanf("12 34", "%d %d", &a, &b);
    Assert(r == 2, "sscanf two ints");
    Assert(a == 12 && b == 34, "sscanf int values");

    r = sscanf("hello 0x2A", "%s %x", s, &u);
    Assert(r == 2, "sscanf string hex");
    Assert(strcmp(s, "hello") == 0, "sscanf string");
    Assert(u == 42, "sscanf hex");

    r = sscanf("-12345", "%ld", &L);
    Assert(r == 1, "sscanf long");
    Assert(L == -12345L, "sscanf long value");
}

static void test_scanf_serial(void)
{
    /* Makefile pipes: 7 99 */
    int x, y, r;

    printf("scanf_prompt\n");
    r = scanf("%d %d", &x, &y);
    Assert(r == 2, "scanf read two ints from serial");
    Assert(x == 7, "scanf first value");
    Assert(y == 99, "scanf second value");
}

static void test_file_creat_write_close(void)
{
    int fd, n;
    static char payload[] = TIO_PAYLOAD;

    fd = tio_creat(TIO_TEST_FILE, 0666);
    Assert(fd >= 0, "creat");

    n = tio_write(fd, payload, (unsigned)strlen(payload));
    Assert(n == (int)strlen(payload), "write full payload");

    n = tio_close(fd);
    Assert(n == 0, "close after write");
}

static void test_file_read_verify(void)
{
    int fd, n;
    char buf[64];
    static char expect[] = TIO_PAYLOAD;

    fd = tio_open(TIO_TEST_FILE, TIO_O_RDONLY, 0);
    Assert(fd >= 0, "open O_RDONLY");

    memset(buf, 0, sizeof(buf));
    n = tio_read(fd, buf, (unsigned)strlen(expect));
    Assert(n == (int)strlen(expect), "read length");
    Assert(memcmp(buf, expect, strlen(expect)) == 0, "read data");

    tio_close(fd);
}

static void test_file_lseek(void)
{
    int fd, n;
    long pos;
    char ch;
    static char expect[] = TIO_PAYLOAD;

    fd = tio_open(TIO_TEST_FILE, TIO_O_RDWR, 0);
    Assert(fd >= 0, "open O_RDWR for lseek");

    pos = tio_lseek(fd, (long)TIO_SEEK_OFF, TIO_SEEK_SET);
    Assert(pos == (long)TIO_SEEK_OFF, "lseek SEEK_SET");

    n = tio_read(fd, &ch, 1);
    Assert(n == 1, "read one after lseek");
    Assert(ch == expect[TIO_SEEK_OFF], "byte at seek offset");

    pos = tio_lseek(fd, 0L, TIO_SEEK_SET);
    Assert(pos == 0L, "lseek back to start");

    n = tio_write(fd, "zzzz", 4);
    Assert(n == 4, "overwrite via lseek+write");

    pos = tio_lseek(fd, 0L, TIO_SEEK_SET);
    {
        char buf[8];
        memset(buf, 0, sizeof(buf));
        n = tio_read(fd, buf, 4);
        Assert(n == 4, "re-read overwritten");
        Assert(memcmp(buf, "zzzz", 4) == 0, "overwritten data");
    }

    /* CP/M extents may pad; host files are exact — accept >= */
    pos = tio_lseek(fd, 0L, TIO_SEEK_END);
    Assert(pos >= (long)strlen(expect), "SEEK_END size");

    tio_close(fd);
}

static void test_file_multi(void)
{
    int fd1, fd2, n;
    char buf[32];

    fd1 = tio_creat(TIO_FILE_A, 0666);
    fd2 = tio_creat(TIO_FILE_B, 0666);
    Assert(fd1 >= 0 && fd2 >= 0, "creat two files");
    Assert(fd1 != fd2, "distinct fds");

    n = tio_write(fd1, "alpha", 5);
    Assert(n == 5, "write a");
    n = tio_write(fd2, "beta!", 5);
    Assert(n == 5, "write b");

    tio_close(fd1);
    tio_close(fd2);

    fd1 = tio_open(TIO_FILE_A, TIO_O_RDONLY, 0);
    fd2 = tio_open(TIO_FILE_B, TIO_O_RDONLY, 0);
    Assert(fd1 >= 0 && fd2 >= 0, "reopen two files");

    memset(buf, 0, sizeof(buf));
    n = tio_read(fd1, buf, 5);
    Assert(n == 5, "read a length");
    Assert(memcmp(buf, "alpha", 5) == 0, "file a content");

    memset(buf, 0, sizeof(buf));
    n = tio_read(fd2, buf, 5);
    Assert(n == 5, "read b length");
    Assert(memcmp(buf, "beta!", 5) == 0, "file b content");

    tio_close(fd1);
    tio_close(fd2);
}

static void test_file_fopen(void)
{
    FILE *fp;
    char buf[32];
    int n;
    static char payload[] = "FOPEN-OK!";

    /* fputs + fread: fgets without newline is flaky on some stdio paths */
    fp = fopen("fopen.dat", "w");
    Assert(fp != 0, "fopen write");
    Assert(fputs(payload, fp) >= 0, "fputs");
    Assert(fclose(fp) == 0, "fclose after write");

    fp = fopen("fopen.dat", "r");
    Assert(fp != 0, "fopen read");
    memset(buf, 0, sizeof(buf));
    n = (int)fread(buf, 1, strlen(payload), fp);
    Assert(n == (int)strlen(payload), "fread length");
    Assert(memcmp(buf, payload, strlen(payload)) == 0, "fopen round-trip");
    Assert(fclose(fp) == 0, "fclose after read");
}

#ifdef __Z88DK_NEWLIB
#include <arch/cpm.h>

static void test_newlib_devices(void)
{
    FILE *f;

    /* Logical names → FILE* (stdio character units) */
    f = (FILE *)cpm_device_file("CRT:");
    Assert((void *)f == (void *)stdout, "CRT: → stdout");
    f = (FILE *)cpm_device_file("LPT:");
    Assert((void *)f == (void *)stdlst, "LPT: → stdlst");
    f = (FILE *)cpm_device_file("PTR:");
    Assert((void *)f == (void *)stdrdr, "PTR: → stdrdr");
    f = (FILE *)cpm_device_file("PTP:");
    Assert((void *)f == (void *)stdpun, "PTP: → stdpun");

    /* Physical streams exist */
    Assert(stdrdr != 0 && stdpun != 0 && stdlst != 0, "stdrdr/stdpun/stdlst");

    /* IOBYTE macros expand to BDOS 7/8 — compile-time surface only here */
    Assert(CPM_DEV_LPT == 2 && CPM_IOBYTE_LST_SHIFT == 6, "iobyte constants");
}
#endif

int main(void)
{
    suite_setup(TIO_LABEL " serial+disk I/O");

    suite_add_test(test_printf_basic);
    suite_add_test(test_sscanf);
    suite_add_test(test_scanf_serial);
    suite_add_test(test_file_creat_write_close);
    suite_add_test(test_file_read_verify);
    suite_add_test(test_file_lseek);
    suite_add_test(test_file_multi);
    suite_add_test(test_file_fopen);
#ifdef __Z88DK_NEWLIB
    suite_add_test(test_newlib_devices);
#endif

    return suite_run();
}
