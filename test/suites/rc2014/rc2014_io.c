/*
 * RC2014 target I/O suite for z88dk-ticks
 *
 * Covers:
 *   - serial: printf / putchar and scanf (via piped stdin + sscanf)
 *   - disk:   host create/write/lseek/read/close through ticks SYSCALL
 *             (real CF/IDE ports are not emulated by ticks; host files
 *             exercise the same create/write/lseek/read/close sequence)
 *
 * Note: open/seek flags passed to host_* must match src/ticks/ticks.h
 * (Z88DK_O_* / Z88DK_SEEK_*), not newlib <fcntl.h> values.
 *
 * Build/run via Makefile targets:
 *   test_rc2014_io_CODE.bin      - Z80  +rc2014 -subtype=basic -clib=new
 *   test_rc2014_io85_CODE.bin    - 8085 +rc2014 -subtype=basic85
 */

#include <stdio.h>
#include <string.h>
#include "test.h"

/* Host-file fcntl (ticks SYSCALL) — see ticks_host_fcntl.asm */
extern int host_open(const char *name, int flags, int mode);
extern int host_creat(const char *name, int mode);
extern int host_close(int fd);
extern int host_read(int fd, void *buf, unsigned int len);
extern int host_write(int fd, void *buf, unsigned int len);
extern long host_lseek(int fd, long posn, int whence);

/* Flags must match src/ticks/ticks.h — not newlib fcntl.h */
#define H_O_RDONLY  0
#define H_O_WRONLY  1
#define H_O_RDWR    2
#define H_O_APPEND  256
#define H_O_TRUNC   512
#define H_O_CREAT   1024

#define H_SEEK_SET  0
#define H_SEEK_END  1
#define H_SEEK_CUR  2

#define TEST_FILE "rc2014_suite.dat"

static void test_printf_basic(void)
{
    int n;
    char buf[64];

    n = sprintf(buf, "RC2014 %d %s", 42, "ok");
    Assert(n > 0, "sprintf returned non-positive");
    Assert(strcmp(buf, "RC2014 42 ok") == 0, "sprintf format mismatch");

    /* Live serial path: putchar / printf → RST 08 → ticks hook_rc2014 */
    printf("printf_serial_ok\n");
#ifdef __8085
    printf("cpu=8085\n");
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
    /*
     * Live serial input via RST 10.  The Makefile pipes a line into
     * z88dk-ticks stdin for this binary run.
     * Expected line: 7 99
     */
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
    static char payload[] = "RC2014-disk-test-payload";

    fd = host_creat(TEST_FILE, 0666);
    Assert(fd >= 0, "host_creat");

    n = host_write(fd, payload, (unsigned)strlen(payload));
    Assert(n == (int)strlen(payload), "host_write full payload");

    n = host_close(fd);
    Assert(n == 0, "host_close after write");
}

static void test_file_read_verify(void)
{
    int fd, n;
    char buf[64];
    static char expect[] = "RC2014-disk-test-payload";

    fd = host_open(TEST_FILE, H_O_RDONLY, 0);
    Assert(fd >= 0, "host_open O_RDONLY");

    memset(buf, 0, sizeof(buf));
    n = host_read(fd, buf, (unsigned)strlen(expect));
    Assert(n == (int)strlen(expect), "host_read length");
    Assert(memcmp(buf, expect, strlen(expect)) == 0, "host_read data");

    host_close(fd);
}

static void test_file_lseek(void)
{
    int fd, n;
    long pos;
    char ch;
    static char expect[] = "RC2014-disk-test-payload";

    fd = host_open(TEST_FILE, H_O_RDWR, 0);
    Assert(fd >= 0, "host_open O_RDWR for lseek");

    pos = host_lseek(fd, 7L, H_SEEK_SET);
    Assert(pos == 7L, "lseek SEEK_SET 7");

    n = host_read(fd, &ch, 1);
    Assert(n == 1, "read one after lseek");
    Assert(ch == expect[7], "byte at offset 7");

    pos = host_lseek(fd, 0L, H_SEEK_SET);
    Assert(pos == 0L, "lseek back to start");

    n = host_write(fd, "zzzzzz", 6);
    Assert(n == 6, "overwrite via lseek+write");

    pos = host_lseek(fd, 0L, H_SEEK_SET);
    {
        char buf[8];
        memset(buf, 0, sizeof(buf));
        n = host_read(fd, buf, 6);
        Assert(n == 6, "re-read overwritten");
        Assert(memcmp(buf, "zzzzzz", 6) == 0, "overwritten data");
    }

    pos = host_lseek(fd, 0L, H_SEEK_END);
    Assert(pos == (long)strlen(expect), "SEEK_END size");

    host_close(fd);
}

static void test_file_multi(void)
{
    int fd1, fd2, n;
    char buf[32];

    fd1 = host_creat("rc2014_a.dat", 0666);
    fd2 = host_creat("rc2014_b.dat", 0666);
    Assert(fd1 >= 0 && fd2 >= 0, "creat two files");
    Assert(fd1 != fd2, "distinct fds");

    n = host_write(fd1, "alpha", 5);
    Assert(n == 5, "write a");
    n = host_write(fd2, "beta!", 5);
    Assert(n == 5, "write b");

    host_close(fd1);
    host_close(fd2);

    fd1 = host_open("rc2014_a.dat", H_O_RDONLY, 0);
    fd2 = host_open("rc2014_b.dat", H_O_RDONLY, 0);
    Assert(fd1 >= 0 && fd2 >= 0, "reopen two files");

    memset(buf, 0, sizeof(buf));
    n = host_read(fd1, buf, 5);
    Assert(n == 5, "read a length");
    Assert(memcmp(buf, "alpha", 5) == 0, "file a content");

    memset(buf, 0, sizeof(buf));
    n = host_read(fd2, buf, 5);
    Assert(n == 5, "read b length");
    Assert(memcmp(buf, "beta!", 5) == 0, "file b content");

    host_close(fd1);
    host_close(fd2);
}

int main(void)
{
    suite_setup("RC2014 serial+disk I/O");

    suite_add_test(test_printf_basic);
    suite_add_test(test_sscanf);
    suite_add_test(test_scanf_serial);
    suite_add_test(test_file_creat_write_close);
    suite_add_test(test_file_read_verify);
    suite_add_test(test_file_lseek);
    suite_add_test(test_file_multi);

    return suite_run();
}
