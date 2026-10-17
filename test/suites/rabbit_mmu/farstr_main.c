// The far string functions on Rabbit, on real far memory (above 64k) and on
// strings that cross 256 byte, 4k and 64k boundaries
#include <stdio.h>
#include <string.h>

#pragma output CLIB_OPT_PRINTF=0x7fffffff

static int checks, fails;

static void check(int ok, int line)
{
    checks++;
    if ( !ok ) {
        fails++;
        printf("FAIL line %d\n", line);
    }
}

#define CHECK(c) check((c), __LINE__)

int main(void)
{
    char *__far a = (char *__far)0x81ff6L;      // crosses a 4k page and a 256 byte boundary
    char *__far b = (char *__far)0x90ff0L;
    char *__far c = (char *__far)0xa0ff8L;
    char *__far d = (char *__far)0x8fffaL;      // crosses the 64k boundary
    char        near_buf[40];
    char        buf[60];

    strcpyf(a, "hello world");
    CHECK(strlenf(a) == 11);
    CHECK(strcmpf(a, "hello world") == 0);
    CHECK(a[3] == 'l');
    strcatf(a, "!!");
    CHECK(strcmpf(a, "hello world!!") == 0);
    strncatf(a, "abcdef", 3);
    CHECK(strcmpf(a, "hello world!!abc") == 0);
    CHECK(strlenf(a) == 16);

    // far to far
    strcpyf(b, a);
    CHECK(strcmpf(b, a) == 0);
    CHECK(strcmpf(a, b) == 0);
    b[5] = 'X';
    CHECK(strcmpf(a, b) < 0);
    CHECK(strcmpf(b, a) > 0);
    CHECK(strncmpf(a, b, 5) == 0);
    CHECK(strncmpf(a, b, 6) < 0);
    CHECK(memcmpf(a, b, 5) == 0);
    CHECK(memcmpf(a, b, 6) < 0);
    CHECK(memcmpf(b, a, 6) > 0);

    // case
    strcpyf(c, a);
    struprf(c);
    CHECK(strcmpf(c, a) != 0);
    CHECK(strcasecmpf(c, a) == 0);
    CHECK(c[0] == 'H');
    strlwrf(c);
    CHECK(strcmpf(c, a) == 0);
    CHECK(strcasecmpf("HELLO", "hello") == 0);
    CHECK(strcasecmpf("hello", "help") < 0);

    // searching
    CHECK(strchrf(a, 'w') == a + 6);
    CHECK(strchrf(a, 'Z') == (char *__far)0);
    CHECK(strrchrf(a, 'l') == a + 9);
    CHECK(strrchrf(a, 'o') == a + 7);
    CHECK(strnchrf(a, 6, 'w') == (char *__far)0);
    CHECK(strnchrf(a, 7, 'w') == a + 6);
    CHECK(memchrf(a, 'r', 16) == a + 8);
    CHECK(memchrf(a, 'r', 8) == (char *__far)0);
    CHECK(memchrf(a, 'r', 9) == a + 8);

    // copying and filling
    memsetf(c, 'x', 20);
    CHECK(c[0] == 'x');
    CHECK(c[19] == 'x');
    strncpyf(c, "ab", 6);
    CHECK(c[0] == 'a' && c[1] == 'b');
    CHECK(c[2] == 0 && c[5] == 0);
    CHECK(c[6] == 'x');
    memcpyf(c, a, 17);
    CHECK(strcmpf(c, a) == 0);

    // across the 64k boundary
    strcpyf(d, "crossing the 64k line");
    CHECK(strlenf(d) == 21);
    CHECK(strcmpf(d, "crossing the 64k line") == 0);
    CHECK(strchrf(d, 'k') == d + 15);

    // near memory used with the far functions
    strcpyf(near_buf, a);
    CHECK(strcmp(near_buf, "hello world!!abc") == 0);
    strcatf(near_buf, d);
    CHECK(strcmp(near_buf, "hello world!!abccrossing the 64k line") == 0);
    CHECK(strlenf(near_buf) == 37);

    // sprintf with a far string
    sprintf(buf, "[%S]", a);
    CHECK(strcmp(buf, "[hello world!!abc]") == 0);
    if ( strcmp(buf, "[hello world!!abc]") != 0 ) printf("got <%s>\n", buf);
    sprintf(buf, "%.5S|%-8S|", a, (char *__far)"abc");
    CHECK(strcmp(buf, "hello|abc     |") == 0);
    if ( strcmp(buf, "hello|abc     |") != 0 ) printf("got <%s>\n", buf);
    sprintf(buf, "%25S", d);
    CHECK(strcmp(buf, "    crossing the 64k line") == 0);
    if ( strcmp(buf, "    crossing the 64k line") != 0 ) printf("got <%s>\n", buf);

    printf("checks=%d fails=%d\n", checks, fails);
    return 0;
}
