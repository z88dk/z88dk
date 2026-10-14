
// zcc +z80 -vn -startup=0 -O2 -clib=new malloc_fl_test.c -o malloc_fl -create-app
//
// Allocator cases that malloc_test does not cover: realloc in place and
// by copy, realloc(NULL) / realloc(p,0), coalesce, a static wilderness,
// two heaps, and a canary past the heap.

#include <stdlib.h>
#include <string.h>
#include <malloc.h>

unsigned char emit_byte;

static void emit(unsigned int c)
{
   emit_byte = (unsigned char)c;
   __asm
      ld a,(_emit_byte)
      out (1),a
   __endasm
}

static void emit_s(char *s)
{
   while (*s)
      emit(*s++);
}

static void emit_u(unsigned v)
{
   char buf[6];
   unsigned i;

   i = 0;
   if (v == 0)
   {
      emit('0');
      return;
   }
   while (v)
   {
      buf[i++] = (char)('0' + (v % 10));
      v /= 10;
   }
   while (i)
      emit(buf[--i]);
}

static unsigned badline;

static void fail(unsigned line)
{
   if (badline == 0)
      badline = line;
}

#define CHECK(cond) do { if (!(cond)) fail(__LINE__); } while (0)

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

static unsigned blocks;

static void visit(heap_info_t *hi)
{
   if (hi->address != 0)
      ++blocks;
}

static void test_default(void)
{
   unsigned char *p;
   unsigned char *q;
   unsigned char *a;
   unsigned char *b;
   unsigned char *c;
   unsigned char *slot[64];
   unsigned i;
   unsigned char *z;

   CHECK(malloc(0) == 0);
   free(0);

   p = realloc(0, 24);
   CHECK(p != 0);
   fill(p, 24, 0x10);
   CHECK(same(p, 24, 0x10));

   q = realloc(p, 24);
   CHECK(q == p);
   CHECK(same(q, 24, 0x10));

   q = realloc(p, 8);
   CHECK(q == p);
   CHECK(same(q, 8, 0x10));

   q = realloc(p, 0);
   CHECK(q != 0);
   free(q);

   p = calloc(9, 3);
   CHECK(p != 0);
   for (i = 0; i < 27; ++i)
      CHECK(p[i] == 0);
   free(p);

   for (i = 1; i <= 7; ++i)
   {
      p = malloc(i);
      CHECK(p != 0);
      fill(p, i, (unsigned char)i);
      CHECK(same(p, i, (unsigned char)i));
      free(p);
   }

   p = malloc(32);
   CHECK(p != 0);
   fill(p, 32, 0xa5);
   free(p);
   /* Free of the first block must not plant a node in the payload. */
   CHECK(p[0] == 0xa5);
   CHECK(p[31] == (unsigned char)(0xa5 + 31));

   a = malloc(16);
   b = malloc(16);
   CHECK(a != 0 && b != 0);
   fill(a, 16, 0x21);
   fill(b, 16, 0x5c);
   free(b);
   CHECK(same(a, 16, 0x21));
   CHECK(b[0] == 0x5c);
   CHECK(b[15] == (unsigned char)(0x5c + 15));
   free(a);

   a = malloc(8);
   CHECK(a != 0);
   fill(a, 8, 0x40);
   b = realloc(a, 80);
   CHECK(b == a);
   CHECK(same(b, 8, 0x40));
   c = malloc(8);
   CHECK(c != 0);
   free(c);
   free(b);

   a = malloc(8);
   b = malloc(8);
   CHECK(a && b);
   fill(a, 8, 0x11);
   fill(b, 8, 0x22);
   c = realloc(a, 64);
   CHECK(c != 0);
   CHECK(c != a);
   CHECK(same(c, 8, 0x11));
   CHECK(same(b, 8, 0x22));
   free(c);
   free(b);

   a = malloc(32);
   b = malloc(32);
   c = malloc(32);
   CHECK(a && b && c);
   fill(a, 32, 1);
   fill(b, 32, 2);
   fill(c, 32, 3);
   free(b);
   free(a);
   free(c);
   p = malloc(90);
   CHECK(p != 0);
   fill(p, 90, 9);
   CHECK(same(p, 90, 9));
   free(p);

   for (i = 0; i < 64; ++i)
   {
      slot[i] = malloc(8);
      CHECK(slot[i] != 0);
      fill(slot[i], 8, (unsigned char)i);
   }
   for (i = 0; i < 64; ++i)
      CHECK(same(slot[i], 8, (unsigned char)i));
   for (i = 0; i < 64; ++i)
      free(slot[i]);
   p = malloc(400);
   CHECK(p != 0);
   free(p);

   z = aligned_alloc(16, 32);
   CHECK(z != 0);
   CHECK(((unsigned int)z & 15) == 0);
   fill(z, 32, 0x77);
   CHECK(same(z, 32, 0x77));
   free(z);
}

static void test_private(void)
{
   static unsigned char raw[420];
   static unsigned char h1[320];
   static unsigned char h2[320];
   static unsigned char img[80];
   unsigned char *p;
   unsigned char *q;
   unsigned char *a;
   unsigned char *b;
   unsigned n;
   unsigned i;

   for (i = 400; i < 420; ++i)
      raw[i] = 0x3c;

   CHECK(heap_init(raw, 400) == raw);

   a = heap_alloc(raw, 20);
   b = heap_alloc(raw, 300);
   CHECK(a != 0 && b != 0);
   fill(a, 20, 0x41);
   fill(b, 300, 0x42);
   p = heap_realloc(raw, a, 200);
   CHECK(p == 0);
   CHECK(same(a, 20, 0x41));
   CHECK(same(b, 300, 0x42));
   q = heap_realloc(raw, a, 24);
   CHECK(q != 0);
   CHECK(same(q, 20, 0x41));
   heap_free(raw, q);
   heap_free(raw, b);

   for (i = 400; i < 420; ++i)
      CHECK(raw[i] == 0x3c);

   CHECK(heap_init(raw, 400) == raw);
   p = heap_alloc(raw, 1);
   CHECK(p != 0);
   for (n = 1; n < 200; n = n * 2 + 1)
   {
      fill(p, n > 16 ? 16 : n, 0x70);
      q = heap_realloc(raw, p, n + 8);
      CHECK(q == p);
      CHECK(same(q, n > 16 ? 16 : n, 0x70));
      p = q;
   }
   heap_free(raw, p);

   CHECK(heap_init(h1, 320) == h1);
   CHECK(heap_init(h2, 320) == h2);
   a = heap_alloc(h1, 20);
   b = heap_alloc(h2, 20);
   CHECK(a && b);
   fill(a, 20, 0x81);
   fill(b, 20, 0x82);
   heap_free(h1, a);
   CHECK(same(b, 20, 0x82));
   a = heap_alloc(h1, 40);
   CHECK(a != 0);
   CHECK(same(b, 20, 0x82));
   fill(a, 40, 0x83);
   p = heap_alloc(h2, 30);
   CHECK(p != 0);
   CHECK(same(a, 40, 0x83));
   CHECK(same(b, 20, 0x82));
   heap_free(h1, a);
   heap_free(h2, b);
   heap_free(h2, p);

   /* Static image: one exact block, then a committed == 0 wilderness.
      prev of the first block is 0, as a ROM image leaves it. */
   memset(img, 0, sizeof(img));
   w16(img + 6, (unsigned)(img + 20));   /* next */
   w16(img + 8, 14);                     /* committed: header + 8 */
   w16(img + 10, 0);                     /* prev, list not built */
   fill(img + 12, 8, 0x91);
   w16(img + 20, (unsigned)(img + 78));  /* wilderness next = terminator */
   w16(img + 22, 0);
   w16(img + 24, (unsigned)(img + 6));   /* prev = first block */

   blocks = 0;
   heap_info(img, visit);
   CHECK(blocks >= 2);

   p = heap_alloc(img, 4);
   CHECK(p == img + 26);
   CHECK(same(img + 12, 8, 0x91));
   fill(p, 4, 0x92);
   q = heap_alloc(img, 4);
   CHECK(q != 0);
   CHECK(q != p);
   CHECK(same(p, 4, 0x92));
   CHECK(same(img + 12, 8, 0x91));
   heap_free(img, q);
   heap_free(img, p);
   CHECK(same(img + 12, 8, 0x91));
}

int main(void)
{
   test_default();
   test_private();

   if (badline)
   {
      emit_s("FAIL ");
      emit_u(badline);
      emit('\n');
   }
   else
      emit_s("OK\n");

   return 0;
}
