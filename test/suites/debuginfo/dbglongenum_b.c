/* See dbglongenum_a.c. h1 and h2 each have a local v of an enum of their own:
 * `print v` shows each function's enum, whatever the path length. */

enum eb { XV = 2, YB };
enum eb vb = YB;

enum ca { RED, GREEN, BLUE };
enum cb { ONE, TWO };

int h1(void)
{
    enum ca v = BLUE;
    v = v + 0;                      /* BREAK h1: print v = BLUE */
    return v;
}

int h2(void)
{
    enum cb v = TWO;
    v = v + 0;                      /* BREAK h2: print v = TWO */
    return v;
}

int fb(void)
{
    int r = vb;
    r = r + 1;                      /* BREAK b: print XV = 2 */
    return r + h1() + h2();
}
