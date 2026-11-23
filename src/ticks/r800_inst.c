
// R800 instructions

#include "ticks.h"
#include "r800_times.h"

// Unsigned 8 bit multiplication
void r800_mulub(uint8_t opcode)
{
    int op = (opcode >> 3 ) & 0x07;
    uint8_t r2;
    uint16_t v;
    
    switch ( op ) {
    case 0x00:
        r2 = b;
        break;
    case 0x01:
        r2 = c;
        break;
    case 0x02:
        r2  = d;
        break;
    case 0x03:
        r2 = e;
        break;
    case 0x04:
        r2 = h;
        break;
    case 0x05:
        r2 = l;
    case 0x06:
        return;   // No opcode here
    case 0x07:
        r2 = a;
        break;
    }
    
    v = a * r2;  
    h = (v >> 8) & 0xff;
    l = v & 0xff;
    st += 14;
}

// DE:HL = HL • rr
void r800_muluw(uint8_t opcode)
{
    int  op = (opcode >> 4) &0x03;
    uint32_t r;
    uint32_t result;

    switch (op) {
    case 0x00:
        r = (( b * 256 ) + c);
        break;
    case 0x01:
        r = (( d * 256 ) + e);
        break;
    case 0x02:
        r = (( h * 256 ) + l);
        break;
    case 0x03:
        r = (sp & 0xffff);
        break;
    }

    result = (( h * 256 ) + l) * r;
    d = (result >> 24) & 0xff;
    e = (result >> 16) & 0xff;
    h  = (result >> 8 ) & 0xff;
    l = result & 0xff;
    st += 36;
}
/* The R800 instruction timings come from one table, keyed by the opcode bytes. The handlers
   add what they add; once an instruction is complete its time is taken from the table instead,
   from where the instruction started. An opcode the table does not list keeps the handler's time.
   The opcode is read before the instruction runs, since a store can change the bytes after it. */
static long long r800_t0;
static unsigned short r800_pc0;
static const unsigned char *r800_entry;

void r800_begin(void)
{
    unsigned short a = pc;
    int b0 = get_memory_inst(a), b1 = get_memory_inst((unsigned short)(a + 1)), cls, op;

    r800_t0 = st;
    r800_pc0 = a;
    if ( b0 == 0xdd || b0 == 0xfd ) {
        if ( b1 == 0xcb ) { cls = 4; op = get_memory_inst((unsigned short)(a + 3)); }
        else { cls = 1; op = b1; }
    } else if ( b0 == 0xed ) { cls = 2; op = b1; }
    else if ( b0 == 0xcb ) { cls = 3; op = b1; }
    else { cls = 0; op = b0; }
    r800_entry = r800_times[cls][op];
}

void r800_retime(void)
{
    const unsigned char *e = r800_entry;

    if ( !e || e[2] == 0 ) return;
    /* a branch is taken when it did not go on to the next instruction */
    st = r800_t0 + ( (unsigned short)(r800_pc0 + e[2]) != pc ? e[0] : e[1] );
}
