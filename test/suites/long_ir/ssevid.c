/* [ss-evidence] Lazy spill drops a spill store when no later use reads its
 * slot. A use whose register serve no hook proved now also counts as served
 * when nothing in its op touched the slot. The emu.c do_add shapes drop their
 * stores; the values read after a branch or across a loop keep them. */
#include "test.h"
#include <string.h>
#include <intrinsic.h>

typedef unsigned char type8;
typedef signed char type8s;
typedef unsigned long type32;

#define read_l(p)     (intrinsic_swap_endian_32(*(type32 *)(p)))
#define write_l(p, v) (*(type32 *)(p) = intrinsic_swap_endian_32(v))

static type8 b1[4], b2[4];
static type8 *arg1, *arg2;
static int sink;

static void add_b(void)
{
    write_l(arg1, read_l(arg1) + (type8s)arg2[0]);
}

static void add_l(void)
{
    write_l(arg1, read_l(arg1) + read_l(arg2));
}

static void note(int v) { sink += v; }
static int note2(int v) { sink += 2 * v; return v + 1; }

/* The sum is read again after a call and in the other arm. */
static long keep_branch(long a, long b, int c)
{
    long s = a + b;
    note(c);
    if (c > 2)
        return s - 1;
    return s + (long)c;
}

/* The running total is read on the next trip. */
static long keep_loop(long a, int n)
{
    long t = a;
    int i;
    for (i = 0; i < n; i++) {
        t = t + (long)i * 3;
        note(i);
    }
    return t;
}

/* sccz80/loops.c loop16: the truncated counter's store is dropped, and the
   increment, done in place on the long counter's slot, must not trust a long
   cache whose low half BC then holds the element address. */
static unsigned char arr[300];
static void loop16(unsigned char *a)
{
    for (unsigned long i = 0; i < 300; i++)
        a[i] = 16;
}

/* [ss-keep-hl] emu.c's `ptr = effective(...)`: a word call result used only
   from HL keeps no slot store. */
static unsigned char cells[8];
static unsigned char *eff(int i) { return &cells[i & 7]; }
static void put2(int i, unsigned int v)
{
    unsigned char *p = eff(i);
    p[0] = v >> 8;
    p[1] = v;
}

/* emu.c dict_lookup's synonym pass: every `effective(...)` result is a
   call result read straight from HL. */
static unsigned char mem[64];
static unsigned long output;
static unsigned int dtab;
static unsigned char *effective(unsigned long p) { return &mem[(unsigned int)p & 63]; }
#define read_w(p)     ((unsigned int)((p)[0] << 8 | (p)[1]))
#define write_w(p, v) ((p)[0] = (unsigned char)((v) >> 8), (p)[1] = (unsigned char)(v))
static void synonyms(void)
{
    unsigned long bak = output;
    unsigned char c;
    unsigned int t;
    while ((c = effective(output)[1]) != 0xff) {
        if (c == 0x0b) {
            t = read_w(effective(dtab + read_w(effective(output + 2)) * 2));
            effective(output)[1] = t & 0x1f;
            write_w(effective(output + 2), (unsigned int)(t >> 5));
        }
        output += 4;
    }
    output = bak;
}

/* [gb-hl-to-de / #G10] `t += call()`: on gbz80 the result moves to DE by a
   copy, not the stack swap z80asm makes of `ex de,hl`. */
static int sq(int i) { return i * i - 3; }
static int acc_calls(int n)
{
    int t = 7, i;
    for (i = 0; i < n; i++)
        t += sq(i);
    return t;
}

/* [ss-byte] emu.c set_arg1's (Ax)+: byte operands used from A keep no slot
   store; a byte read back after a call keeps its store. */
static unsigned char opsize, regnr;
static unsigned long regs[16];
static unsigned long read_reg(int i) { return regs[i & 15]; }
static void write_reg(int i, unsigned long v) { regs[i & 15] = v; }
static unsigned long postinc(void)
{
    unsigned long a = read_reg(8 + regnr);
    write_reg(8 + regnr, a + (1 << opsize));
    return a;
}
static int byte_kept(unsigned char k)
{
    unsigned char m = (unsigned char)(k ^ opsize);
    note(m);
    return m + note2(m);
}

/* [ss-byte] examples/console/enigma.c's encoder: the notch compare loads a
   byte that only the next `cp (hl)` reads, and its slot store goes. */
static const unsigned char rotor[] = "EKMFLGDQVZNTOWYHXUSPAIBRCJAJDKSIRUXBLHWTMCQGZNPYFVOEBDFHJLCPRTXVZNYEIWGAKMUSQOESOVPZJAYQUIRHXLNFTGKDCMWBVZBRGITYUPSDNHLXAWMJQOFECK";
static const unsigned char ref[] = "YRUHQSLDPXNGOKMIEBFZCWVJAT";
static const unsigned char notch[] = "QEVJZ";
static unsigned int flag;
static const unsigned char order[3] = { 3, 1, 2 };
static const unsigned char rings[3] = { 'W', 'X', 'T' };
static unsigned char pos[3];
static const unsigned char plug[] = "AMTE";
static char *enigma(const char *in, char *out)
{
    unsigned int i, j;
    int ch;
    char *o = out;
    pos[0] = 'A'; pos[1] = 'W'; pos[2] = 'E';
    flag = 0;
    while ((ch = *in++) != 0) {
        pos[0]++;
        if (pos[0] > 'Z') pos[0] -= 26;
        if (flag) {
            pos[1]++;
            if (pos[1] > 'Z') pos[1] -= 26;
            pos[2]++;
            if (pos[2] > 'Z') pos[2] -= 26;
            flag = 0;
        }
        if (pos[0] == notch[order[0] - 1]) {
            pos[1]++;
            if (pos[1] > 'Z') pos[1] -= 26;
            if (pos[1] == notch[order[1] - 1]) flag = 1;
        }
        for (i = 0; plug[i]; i += 2) {
            if (ch == plug[i]) ch = plug[i + 1];
            else if (ch == plug[i + 1]) ch = plug[i];
        }
        for (i = 0; i < 3; i++) {
            ch += pos[i] - 'A';
            if (ch > 'Z') ch -= 26;
            ch -= rings[i] - 'A';
            if (ch < 'A') ch += 26;
            ch = rotor[((order[i] - 1) * 26) + ch - 'A'];
            ch += rings[i] - 'A';
            if (ch > 'Z') ch -= 26;
            ch -= pos[i] - 'A';
            if (ch < 'A') ch += 26;
        }
        ch = ref[ch - 'A'];
        for (i = 3; i; i--) {
            ch += pos[i - 1] - 'A';
            if (ch > 'Z') ch -= 26;
            ch -= rings[i - 1] - 'A';
            if (ch < 'A') ch += 26;
            for (j = 0; j < 26; j++)
                if (rotor[(26 * (order[i - 1] - 1)) + j] == ch) break;
            ch = j + 'A';
            ch += rings[i - 1] - 'A';
            if (ch > 'Z') ch -= 26;
            ch -= pos[i - 1] - 'A';
            if (ch < 'A') ch += 26;
        }
        for (i = 0; plug[i]; i += 2) {
            if (ch == plug[i]) ch = plug[i + 1];
            else if (ch == plug[i + 1]) ch = plug[i];
        }
        *o++ = (char)ch;
    }
    *o = 0;
    return out;
}

static void test_ssevid(void)
{
    b1[0] = 0x12; b1[1] = 0x34; b1[2] = 0x56; b1[3] = 0x78;
    b2[0] = 0xff; b2[1] = 0x00; b2[2] = 0x00; b2[3] = 0x01;
    arg1 = b1; arg2 = b2;
    add_b();                                   /* 0x12345678 + (-1) */
    assertEqual(b1[3], 0x77);
    assertEqual(b1[2], 0x56);
    add_l();                                   /* + 0xff000001 */
    assertEqual(b1[0], 0x11);
    assertEqual(b1[1], 0x34);
    assertEqual(b1[2], 0x56);
    assertEqual(b1[3], 0x78);
    sink = 0;
    assertEqual((int)keep_branch(70000L, 5L, 2), 4471);
    assertEqual((int)(keep_branch(70000L, 5L, 2) >> 16), 1);
    assertEqual((int)keep_branch(70000L, 5L, 9), 4468);
    assertEqual((int)keep_loop(100000L, 10), -30937);
    assertEqual(sink, 58);
    loop16(arr);
    assertEqual(arr[0], 16);
    assertEqual(arr[17], 16);
    assertEqual(arr[255], 16);
    assertEqual(arr[256], 16);
    assertEqual(arr[299], 16);
    put2(3, 0xbeef);
    put2(14, 0x1234);
    assertEqual(cells[3], 0xbe);
    assertEqual(cells[4], 0xef);
    assertEqual(cells[6], 0x12);
    assertEqual(cells[7], 0x34);
    assertEqual(acc_calls(10), 262);
    /* words at 0 and 4 (0x0b: replaced), 8 (kept), 12 (end) */
    mem[1] = 0x0b; mem[2] = 0; mem[3] = 10;
    mem[5] = 0x0b; mem[6] = 0; mem[7] = 11;
    mem[9] = 0x22;
    mem[13] = 0xff;
    mem[40] = 0x12; mem[41] = 0x34;      /* dtab 20 + 10 * 2 */
    mem[42] = 0xab; mem[43] = 0xcd;
    dtab = 20;
    output = 0;
    synonyms();
    assertEqual(mem[1], 0x14);
    assertEqual(mem[2], 0x00);
    assertEqual(mem[3], 0x91);
    assertEqual(mem[5], 0x0d);
    assertEqual(mem[6], 0x05);
    assertEqual(mem[7], 0x5e);
    assertEqual(mem[9], 0x22);
    assertEqual((int)output, 0);
    regs[10] = 0x10000L; regnr = 2; opsize = 2;
    assertEqual((int)postinc(), 0);
    assertEqual((int)(regs[10] >> 16), 1);
    assertEqual((int)regs[10], 4);
    opsize = 1;
    postinc();
    assertEqual((int)regs[10], 6);
    sink = 0;
    assertEqual(byte_kept(0x40), 0x83);
    assertEqual(sink, 0x41 * 3);
    {
        char buf[32];
        const char *e = enigma("HELLOWORLDQQQQQQQQQQQQQQQQQQQQ", buf);
        assertEqual(memcmp(e, "RXSECSTDFE", 10), 0);
        assertEqual(e[29], 'H');
    }
}

int main(int argc, char *argv[])
{
    suite_setup("ssevid");
    suite_add_test(test_ssevid);
    return suite_run();
}
