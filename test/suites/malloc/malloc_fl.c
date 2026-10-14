
#include "malloc_tests.h"

static void fill(unsigned char *p, unsigned n, unsigned char tag)
{
    unsigned i;

    for (i = 0; i < n; ++i)
        p[i] = (unsigned char)(tag + i);
}

static int same(unsigned char *p, unsigned n, unsigned char tag)
{
    unsigned i;

    for (i = 0; i < n; ++i)
    {
        if (p[i] != (unsigned char)(tag + i))
            return 0;
    }
    return 1;
}

static void w16(unsigned char *p, unsigned v)
{
    p[0] = (unsigned char)v;
    p[1] = (unsigned char)(v >> 8);
}

void fl_null(void)
{
    unsigned char *p;
    unsigned char *q;

    Assert(malloc(0) == 0, "malloc(0) returns 0");
    free(0);

    p = realloc(0, 24);
    Assert(p != 0, "realloc(NULL) allocates");
    fill(p, 24, 0x10);
    Assert(same(p, 24, 0x10), "realloc(NULL) payload");

    q = realloc(p, 24);
    Assert(q == p, "realloc same size stays");
    Assert(same(q, 24, 0x10), "realloc same size payload");

    q = realloc(p, 8);
    Assert(q == p, "realloc shrink stays");
    Assert(same(q, 8, 0x10), "realloc shrink payload");

    q = realloc(p, 0);
    Assert(q != 0, "realloc(p, 0) keeps the block");
    free(q);
}

void fl_calloc(void)
{
    unsigned char *p;
    unsigned i;

    p = calloc(9, 3);
    Assert(p != 0, "calloc allocates");
    for (i = 0; i < 27; ++i)
        Assert(p[i] == 0, "calloc is zero");
    free(p);
}

void fl_small(void)
{
    unsigned char *p;
    unsigned i;

    for (i = 1; i <= 7; ++i)
    {
        p = malloc(i);
        Assert(p != 0, "small malloc");
        fill(p, i, (unsigned char)i);
        Assert(same(p, i, (unsigned char)i), "small payload");
        free(p);
    }
}

void fl_free_payload(void)
{
    unsigned char *p;
    unsigned char *a;
    unsigned char *b;

    p = malloc(32);
    Assert(p != 0, "malloc 32");
    fill(p, 32, 0xa5);
    free(p);
    /* Free of the first block must not plant a node in the payload. */
    Assert(p[0] == 0xa5, "first free leaves byte 0");
    Assert(p[31] == (unsigned char)(0xa5 + 31), "first free leaves last byte");

    a = malloc(16);
    b = malloc(16);
    Assert(a != 0 && b != 0, "two blocks");
    fill(a, 16, 0x21);
    fill(b, 16, 0x5c);
    free(b);
    Assert(same(a, 16, 0x21), "neighbour payload");
    Assert(b[0] == 0x5c, "freed block byte 0");
    Assert(b[15] == (unsigned char)(0x5c + 15), "freed block last byte");
    free(a);
}

void fl_realloc_grow(void)
{
    unsigned char *a;
    unsigned char *b;
    unsigned char *c;

    a = malloc(8);
    Assert(a != 0, "malloc 8");
    fill(a, 8, 0x40);
    b = realloc(a, 80);
    Assert(b == a, "grow in place");
    Assert(same(b, 8, 0x40), "grow payload");
    c = malloc(8);
    Assert(c != 0, "malloc after grow");
    free(c);
    free(b);
}

void fl_realloc_move(void)
{
    unsigned char *a;
    unsigned char *b;
    unsigned char *c;

    a = malloc(8);
    b = malloc(8);
    Assert(a != 0 && b != 0, "two blocks");
    fill(a, 8, 0x11);
    fill(b, 8, 0x22);
    c = realloc(a, 64);
    Assert(c != 0, "realloc moves");
    Assert(c != a, "realloc did not stay");
    Assert(same(c, 8, 0x11), "moved payload");
    Assert(same(b, 8, 0x22), "neighbour after move");
    free(c);
    free(b);
}

void fl_coalesce(void)
{
    unsigned char *a;
    unsigned char *b;
    unsigned char *c;
    unsigned char *p;

    a = malloc(32);
    b = malloc(32);
    c = malloc(32);
    Assert(a != 0 && b != 0 && c != 0, "three blocks");
    fill(a, 32, 1);
    fill(b, 32, 2);
    fill(c, 32, 3);
    free(b);
    free(a);
    free(c);
    p = malloc(90);
    Assert(p != 0, "reuse coalesced hole");
    fill(p, 90, 9);
    Assert(same(p, 90, 9), "coalesced payload");
    free(p);
}

void fl_many(void)
{
    static unsigned char *slot[64];
    unsigned char *p;
    unsigned i;

    for (i = 0; i < 64; ++i)
    {
        slot[i] = malloc(8);
        Assert(slot[i] != 0, "many malloc");
        fill(slot[i], 8, (unsigned char)i);
    }
    for (i = 0; i < 64; ++i)
        Assert(same(slot[i], 8, (unsigned char)i), "many payload");
    for (i = 0; i < 64; ++i)
        free(slot[i]);
    p = malloc(400);
    Assert(p != 0, "large after many");
    free(p);
}

void fl_aligned(void)
{
    unsigned char *z;

    z = aligned_alloc(16, 32);
    Assert(z != 0, "aligned_alloc");
    Assert(((unsigned int)z & 15) == 0, "alignment");
    fill(z, 32, 0x77);
    Assert(same(z, 32, 0x77), "aligned payload");
    free(z);
}

void fl_private_reject(void)
{
    static unsigned char raw[420];
    unsigned char *p;
    unsigned char *q;
    unsigned char *a;
    unsigned char *b;
    unsigned i;

    for (i = 400; i < 420; ++i)
        raw[i] = 0x3c;

    Assert(heap_init(raw, 400) == raw, "heap_init");

    a = heap_alloc(raw, 20);
    b = heap_alloc(raw, 300);
    Assert(a != 0 && b != 0, "private alloc");
    fill(a, 20, 0x41);
    fill(b, 300, 0x42);
    p = heap_realloc(raw, a, 200);
    Assert(p == 0, "realloc that does not fit");
    Assert(same(a, 20, 0x41), "rejected realloc payload");
    Assert(same(b, 300, 0x42), "neighbour after reject");
    q = heap_realloc(raw, a, 24);
    Assert(q != 0, "small private realloc");
    Assert(same(q, 20, 0x41), "small private payload");
    heap_free(raw, q);
    heap_free(raw, b);

    for (i = 400; i < 420; ++i)
        Assert(raw[i] == 0x3c, "canary past the heap");
}

void fl_private_grow(void)
{
    static unsigned char raw[420];
    unsigned char *p;
    unsigned char *q;
    unsigned n;

    Assert(heap_init(raw, 400) == raw, "heap_init");
    p = heap_alloc(raw, 1);
    Assert(p != 0, "private seed");
    for (n = 1; n < 200; n = n * 2 + 1)
    {
        fill(p, n > 16 ? 16 : n, 0x70);
        q = heap_realloc(raw, p, n + 8);
        Assert(q == p, "private grow in place");
        Assert(same(q, n > 16 ? 16 : n, 0x70), "private grow payload");
        p = q;
    }
    heap_free(raw, p);
}

void fl_two_heaps(void)
{
    static unsigned char h1[320];
    static unsigned char h2[320];
    unsigned char *a;
    unsigned char *b;
    unsigned char *p;

    Assert(heap_init(h1, 320) == h1, "heap 1");
    Assert(heap_init(h2, 320) == h2, "heap 2");
    a = heap_alloc(h1, 20);
    b = heap_alloc(h2, 20);
    Assert(a != 0 && b != 0, "both heaps");
    fill(a, 20, 0x81);
    fill(b, 20, 0x82);
    heap_free(h1, a);
    Assert(same(b, 20, 0x82), "other heap after free");
    a = heap_alloc(h1, 40);
    Assert(a != 0, "heap 1 again");
    Assert(same(b, 20, 0x82), "heap 2 after heap 1 alloc");
    fill(a, 40, 0x83);
    p = heap_alloc(h2, 30);
    Assert(p != 0, "heap 2 second block");
    Assert(same(a, 40, 0x83), "heap 1 payload");
    Assert(same(b, 20, 0x82), "heap 2 first payload");
    heap_free(h1, a);
    heap_free(h2, b);
    heap_free(h2, p);
}

static unsigned blocks;

static void visit(heap_info_t *hi)
{
    if (hi->address != 0)
        ++blocks;
}

void fl_static_image(void)
{
    static unsigned char img[80];
    unsigned char *p;
    unsigned char *q;

    /* One exact block, then a committed == 0 wilderness.
       prev of the first block is 0, as a ROM image leaves it. */
    memset(img, 0, sizeof(img));
    w16(img + 6, (unsigned)(img + 20));
    w16(img + 8, 14);
    w16(img + 10, 0);
    fill(img + 12, 8, 0x91);
    w16(img + 20, (unsigned)(img + 78));
    w16(img + 22, 0);
    w16(img + 24, (unsigned)(img + 6));

    blocks = 0;
    heap_info(img, visit);
    Assert(blocks >= 2, "static image has two blocks");

    p = heap_alloc(img, 4);
    Assert(p == img + 26, "wilderness alloc");
    Assert(same(img + 12, 8, 0x91), "exact block payload");
    fill(p, 4, 0x92);
    q = heap_alloc(img, 4);
    Assert(q != 0, "second static alloc");
    Assert(q != p, "second block is distinct");
    Assert(same(p, 4, 0x92), "wilderness payload");
    Assert(same(img + 12, 8, 0x91), "exact block still intact");
    heap_free(img, q);
    heap_free(img, p);
    Assert(same(img + 12, 8, 0x91), "exact block after free");
}

int test_malloc_fl(void)
{
    suite_setup("malloc free-list Tests");

    suite_add_test(fl_null);
    suite_add_test(fl_calloc);
    suite_add_test(fl_small);
    suite_add_test(fl_free_payload);
    suite_add_test(fl_realloc_grow);
    suite_add_test(fl_realloc_move);
    suite_add_test(fl_coalesce);
    suite_add_test(fl_many);
    suite_add_test(fl_aligned);
    suite_add_test(fl_private_reject);
    suite_add_test(fl_private_grow);
    suite_add_test(fl_two_heaps);
    suite_add_test(fl_static_image);

    return suite_run();
}
