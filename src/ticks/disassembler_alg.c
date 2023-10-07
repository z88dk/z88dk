
#include <stdio.h>
#include <inttypes.h>
#include "cpu.h"
#include "syms.h"
#include "backend.h"
#include "disassembler.h"
#include "debugger.h"


static char *rp2_table[] = { "bc", "de", "hl", "af"};
static char *cc_table[] = { "nz", "z", "nc", "c", "po", "pe", "p", "m"};
static char *alu_table[] = { "add", "adc", "sub", "sbc", "and", "xor", "or", "cp"};
static char *rot_table[] = { "rlc", "rrc", "rl", "rr", "sla", "sra", "sll", "srl" };
static char *assorted_mainpage_opcodes[] = { "rlca", "rrca", "rla", "rra", "daa", "cpl", "scf", "ccf" };

static char *rabbit_cc_table[] = { "nz", "z", "nc", "c", "lz", "lo", "p", "m" };
static char *r4k_cc_table[] = { "gt", "gtu", "lt", "v" };
static char *r4k_ps_table[] = { "pw", "px", "py", "pz" };
static char *r4k_32b_table[] = { "bcde", "jkhl" };
static char *r4k_16b_table[] = { "bc", "de", "ix", "iy" }; // Used for 6d page

static char *kc160_p_table[] = {  "a", "xp", "yp", "zp" };

typedef struct {
    int       index;
    unsigned int    pc;
    int       len;
    int       skip;
    uint8_t   prefix;
    uint8_t   displacement;
    uint8_t   opcode;
    uint8_t   instr_bytes[6];
    uint8_t   am;
    uint8_t   adl;
    uint8_t   kc_prefix;
} dcontext;


#define READ_BYTE(state,val) do { \
    val = bk.get_memory(state->pc++, MEM_TYPE_INST); \
    state->instr_bytes[state->len++] = val; \
} while (0)

#define PEEK_BYTE(state,val) do { \
    val = bk.get_memory(state->pc, MEM_TYPE_INST); \
} while (0)

#define BUF_PRINTF(fmt, ...) do { \
    offs += snprintf(buf + offs, buflen - offs, fmt, ## __VA_ARGS__); \
} while(0)

#define BUF_RESET() do { \
   offs = 0; \
   if (compact <= 1) { \
        offs = snprintf(buf, buflen, "%-20s", ""); \
   } \
} while (0)

#define WORDIS24(state) ( (state->adl && state->am == 0 ) || (state->am) >= 3 )

static char *handle_rot(dcontext *state,  uint8_t z)
{
    char *instr = rot_table[z];

    if ( z == 6 ) {
        instr = NULL;
        if ( cansll() ) {
            instr = "sll";
        } else if ( isr800() ) {
            instr = "sla";
        } else if ( isgbz80() ) {
            instr = "swap";
        }
    } 

    return instr;
}

static char *handle_rel8(dcontext *state, char *buf, size_t buflen)
{
    const char   *label;
    size_t  offs = 0;
    int8_t  displacement;

    READ_BYTE(state, displacement);

    if ( (label = find_symbol(state->pc + displacement, SYM_ADDRESS)) != NULL ) {
        BUF_PRINTF("%s",label);
    } else {
        char temp[10];

        if ( c_autolabel ) {
            snprintf(temp,sizeof(temp),"L%04x",(unsigned short)(state->pc + displacement));
            symbol_add_autolabel(state->pc + displacement,temp);
            BUF_PRINTF("%s",temp);
        } else if ( state->adl ) {
            BUF_PRINTF("$%06x", (state->pc + displacement));
        } else {
            BUF_PRINTF("$%04x", (unsigned short)(state->pc + displacement));
        }
    }
    
    
    return buf;
}


static char *handle_rel16(dcontext *state, char *buf, size_t buflen)
{
    const char   *label;
    size_t  offs = 0;
    int16_t  displacement;
    uint8_t   d1,d2;

    READ_BYTE(state, d1);
    READ_BYTE(state, d2);

    displacement = (d2<<8)|d1;

    if ( (label = find_symbol(state->pc + displacement, SYM_ADDRESS)) != NULL ) {
        BUF_PRINTF("%s",label);
    } else {
        char temp[10];

        if ( c_autolabel ) {
            snprintf(temp,sizeof(temp),"L%04x",(unsigned short)(state->pc + displacement));
            symbol_add_autolabel(state->pc + displacement,temp);
            BUF_PRINTF("%s",temp);
        } else if ( state->adl ) {
            BUF_PRINTF("$%06x", (state->pc + displacement));
        } else {
            BUF_PRINTF("$%04x", (unsigned short)(state->pc + displacement));
        }
    }
    
    
    return buf;
}

static char *handle_addr16(dcontext *state, char *buf, size_t buflen)
{
    size_t   offs = 0;
    const char    *label;
    uint8_t  lsb;
    uint8_t  msb;
    uint8_t  mmsb = 0;
    
    READ_BYTE(state, lsb);
    READ_BYTE(state, msb);
    if ( WORDIS24(state) ) {
        READ_BYTE(state, mmsb);
    }

    if ( (label = find_symbol(lsb + msb * 256 + mmsb * 65536, SYM_ADDRESS)) != NULL ) {
        BUF_PRINTF("%s",label);
    } else {
        char temp[10];

        if ( c_autolabel ) {
            if ( WORDIS24(state) ) 
                snprintf(temp,sizeof(temp),"L%02x%02x%02x",mmsb,msb,lsb);
            else
                snprintf(temp,sizeof(temp),"L%02x%02x",msb,lsb);
            symbol_add_autolabel(lsb + msb * 256 + mmsb * 65536,temp);
            BUF_PRINTF("%s",temp);
        } else if ( WORDIS24(state) ) {
            BUF_PRINTF("$%02x%02x%02x", mmsb, msb, lsb);
        } else {
            BUF_PRINTF("$%02x%02x", msb, lsb);
        }
    }
    return buf;
}

static char *handle_addr24(dcontext *state, char *buf, size_t buflen)
{
    size_t   offs = 0;
    const char    *label;
    uint8_t  lsb;
    uint8_t  msb;
    uint8_t  mmsb;
    
    READ_BYTE(state, lsb);
    READ_BYTE(state, msb);
    READ_BYTE(state, mmsb);

    if ( (label = find_symbol(lsb + msb * 256 + mmsb * 65536, SYM_ADDRESS)) != NULL ) {
        BUF_PRINTF("%s",label);
    } else {
        char temp[10];

        if ( c_autolabel ) {
            snprintf(temp,sizeof(temp),"L%02x%02x%02x",mmsb,msb,lsb);
            symbol_add_autolabel(lsb + msb * 256 + mmsb * 65536,temp);
            BUF_PRINTF("%s",temp);
        } else BUF_PRINTF("$%02x%02x%02x", mmsb, msb, lsb);
    }
    return buf;
}

static char *handle_immed8(dcontext *state, char *buf, size_t buflen)
{
    size_t offs = 0;
    uint8_t lsb;
    
    READ_BYTE(state, lsb);
    BUF_PRINTF("$%02x", lsb);
    
    return buf;
}

static char *handle_immed16(dcontext *state, char *buf, size_t buflen)
{
    size_t offs = 0;
    uint8_t lsb;
    uint8_t msb;
    uint8_t mmsb;
    
    READ_BYTE(state, lsb);
    READ_BYTE(state, msb);
    if ( WORDIS24(state) ) {
        READ_BYTE(state, mmsb);
        BUF_PRINTF("$%02x%02x%02x", mmsb, msb, lsb);
    } else {
        BUF_PRINTF("$%02x%02x", msb, lsb);
    }
    
    
    return buf;
}

static char *handle_immed16_be(dcontext *state, char *buf, size_t buflen)
{
    size_t offs = 0;
    uint8_t lsb;
    uint8_t msb;
    
    READ_BYTE(state, msb);
    READ_BYTE(state, lsb);
    
    BUF_PRINTF("$%02x%02x", msb, lsb);
    
    return buf;
}

static char *handle_immed24(dcontext *state, char *buf, size_t buflen)
{
    size_t offs = 0;
    uint8_t lsb;
    uint8_t msb;
    uint8_t mlsb;
    
    READ_BYTE(state, lsb);
    READ_BYTE(state, msb);
    READ_BYTE(state, mlsb);

    BUF_PRINTF("$%02x%02x%02x", mlsb, msb, lsb);
    
    return buf;
}

static char *handle_immed32(dcontext *state, char *buf, size_t buflen)
{
    size_t offs = 0;
    uint8_t lsb;
    uint8_t msb;
    uint8_t mlsb;
    uint8_t mmsb;
    
    READ_BYTE(state, lsb);
    READ_BYTE(state, msb);
    READ_BYTE(state, mlsb);
    READ_BYTE(state, mmsb);

    BUF_PRINTF("$%02x%02x%02x%02x", mmsb, mlsb, msb, lsb);
    
    return buf;
}

static char *handle_hl(int index)
{
    static char *table[] = { "hl", "ix", "iy"};
    return table[index];
}

static char* handle_kc_prefix(uint8_t pfx)
{
    static char* kc160_prefix_table[] = { "x", "y", "a", "p", "", "", "", "z" };
    if (!iskc160ext() || pfx > 7)
        return "";
    else
        return kc160_prefix_table[pfx];
}

static char* handle_kc_segment(uint8_t pfx)
{
    if (!iskc160ext() || pfx > 7)
        return "";
    else {
        static char buffer[10]; // NOTE: not reentrant
        snprintf(buffer, sizeof(buffer), "%s%s:", handle_kc_prefix(pfx), pfx == 2 ? "" : "p");
        return buffer;
    }
}

static char *handle_register8(dcontext *state, uint8_t y, char *buf, size_t buflen)
{
    static char *table[3][8] = {
        { "b", "c", "d", "e", "h", "l", "hl", "a" },
        { "b", "c", "d", "e", "ixh", "ixl", "ix", "a" },
        { "b", "c", "d", "e", "iyh", "iyl", "iy", "a" }
    };
    size_t offs = 0;
    int index = state->index;

    /* Turn off ixl/h handling for Rabbit and Z180 */
    if ( !canixh() && y != 6 ) {
        index = 0;
    }
    if ( y == 6 && index ) {
        int8_t displacement = state->displacement;

        if ( state->prefix != 0xcb )
            READ_BYTE(state, displacement);
            BUF_PRINTF("(%s%s%s$%02x)",handle_kc_prefix(state->kc_prefix),table[index][y], displacement < 0 ? "-" : "+", displacement < 0 ? -displacement : displacement);
        return buf;
    } 
    if (y == 6) {
        BUF_PRINTF("(%s%s)",handle_kc_prefix(state->kc_prefix),table[index][y]);
    } else {
        BUF_PRINTF("%s", table[index][y]);
    }
    return buf;
}

static char *handle_displacement(dcontext *state, char *buf, size_t buflen)
{
    int8_t dis;
    size_t offs = 0;

    READ_BYTE(state, dis);
    BUF_PRINTF("%s$%02x",  dis < 0 ? "-" : "+", dis < 0 ? -dis : dis);
    return buf;
}

static char *handle_register16(dcontext *state, uint8_t p, int index)
{
    static char *table[3][4] = {
        { "bc", "de", "hl", "sp" },
        { "bc", "de", "ix", "sp" },
        { "bc", "de", "iy", "sp" },
    };
    
    return table[index][p];
}

static char *handle_register16_2(dcontext *state, uint8_t p, int index)
{
    static char *table[3][4] = {
        { "bc", "de", "hl", "af" },
        { "bc", "de", "ix", "af" },
        { "bc", "de", "iy", "af" },
    };
    
    
    return table[index][p];
}

static char *kc160_handle_register_r24(dcontext *state, uint8_t p)
{
    static char *table[3] = { "xix", "yiy", "ahl" };
    return table[p];
}

static char *handle_block_instruction(dcontext *state, uint8_t z, uint8_t y)
{
    static char *table[4][5] = { 
        { "ldi", "cpi", "ini", "outi", "outi2"},
        { "ldd", "cpd", "ind", "outd", "outd2", },
        { "ldir", "cpir", "inir", "otir", "oti2r"},
        { "lddr", "cpdr", "indr", "otdr", "otd2r"}
    };

    if ( israbbit() && z != 0 ) return "nop";

    return table[y-4][z];
}

static char *kc160_handle_register_rel(dcontext *state, uint8_t index)
{
    static char *table[3] = { "iy", "ix" , "sp" };
    static char buffer[10]; // NOTE: not reentrant
    snprintf(buffer, sizeof(buffer), "%s%s", handle_kc_prefix(state->kc_prefix), table[index]);
    return buffer;
}

static char* handle_ed_assorted_instructions(dcontext* state, uint8_t y)
{
    static char* table[] = { "ld        i,a",   "ld        r,a",   "ld        a,i",   "ld        a,r",   "rrd",             "rld",    "ld        i,i",  "ld        r,r" };
    static char* z180_table[] = { "ld        i,a",   "ld        r,a",   "ld        a,i",   "ld        a,r",   "rrd",             "rld",    "nop",             "nop" };
    static char* r2ka_table[] = { "ld        eir,a", "ld        iir,a", "ld        a,eir", "ld        a,iir", "ld        xpc,a", "nop",    "ld        a,xpc", "nop" };
    static char* r3k_table[] = { "ld        eir,a", "ld        iir,a", "ld        a,eir", "ld        a,iir", "ld        xpc,a", "setusr", "ld        a,xpc", "rdmode" };
    static char* kc160_table[] = { "ld        i,a",   "ld        r,a",   "ld        a,i",   "ld        a,r",   "rrd",             "rld",    "mul       de,hl", "muls     de,hl" };


    if (iskc160ext() && state->kc_prefix < 8 && (y == 4 || y == 5)) {  // rrd, rld
        static char buffer[20]; // NOTE: not reentrant
        snprintf(buffer, sizeof(buffer), "%-10s(%shl)", kc160_table[y], handle_kc_prefix(state->kc_prefix));
        return buffer;
    }
    else {
        return c_cpu & CPU_R2KA ? r2ka_table[y] :
            c_cpu & (CPU_R3K | CPU_R4K) ? r3k_table[y] :
            c_cpu & (CPU_Z180 | CPU_EZ80) ? z180_table[y] :
            iskc160() ? kc160_table[y] : table[y];
    }
}

static char *handle_im_instructions(dcontext *state, uint8_t y)
{
    char *table[] =      { "im        0", "im        0/1", "im        1", "im        2", "im        0",  "im        0/1", "im        1",  "im        2"};
    char *z180_table[] = { "im        0", "nop       ",    "im        1", "im        2", "nop       ",   "nop       ",    "slp       ",   "nop       "};
    char *r2ka_table[] = { "ipset     0", "ipset     2",   "ipset     1", "ipset     3", "nop       ",   "nop       ",    "push      ip", "pop       ip"};
    char *r3k_table[] =  { "ipset     0", "ipset     2",   "ipset     1", "ipset     3", "push      su", "pop       su",  "push      ip", "pop       ip"};
    char *ez80table[] =  { "im        0", "nop       ",    "im        1", "im        2", "im        0",  "ld        a,mb","slp       ",   "rsmix     "};
    char *kc160table[] = { "im        0", "im        3",   "im        1", "im        2", "nop       ",   "nop       ",    "mul       hl", "muls      hl"};
    
    return c_cpu & CPU_R2KA ? r2ka_table[y] : 
           c_cpu & (CPU_R3K|CPU_R4K) ? r3k_table[y] : 
           c_cpu & CPU_Z180 ? z180_table[y] : 
           isez80() ? ez80table[y] : iskc160() ? kc160table[y] : table[y];
}   

static char *handle_ez80_am(dcontext *state, char *opcode)
{
    static char buf[128];
    static char *modes[] = { "", ".sis", ".lis", ".sil", ".lil" };

    snprintf(buf,sizeof(buf),"%s%s", opcode, isez80() ? modes[state->am] : "");

    return buf;
}

int disassemble2(int pc, char *bufstart, size_t buflen, int compact)
{
    dcontext    s_state = {0};
    dcontext   *state = &s_state;
    int         i;
    uint8_t     b;
    char        *buf;
    const char  *label;
    size_t       offs = 0;
    int          start_pc = pc;
    char         dolf = 0; 
    char         opbuf1[256];
    char         opbuf2[256];

    state->pc = pc;
    state->adl = c_adl_mode;
    state->kc_prefix = 0xff;

    label = find_symbol(pc, SYM_ADDRESS);
    if (label && (compact <= 1)) {
        offs += snprintf(bufstart + offs, buflen - offs, "%s:%s",label, compact ? "" : "\n");
    }
    buf = bufstart + offs;
    buflen -= offs;

    if (compact <= 1) {
        offs = snprintf(buf, buflen, "%-20s", "");
    }

    if ( address_is_code(state->pc) == 0 ) {
        READ_BYTE(state, b);
        BUF_PRINTF("%-10s$%02x","defb",b);
    } else {
        state->am = 0;
        do {
            READ_BYTE(state, b);

            // Decoding the main page
            // x = the opcode's 1st octal digit (i.e. bits 7-6)
            // y = the opcode's 2nd octal digit (i.e. bits 5-3)
            // z = the opcode's 3rd octal digit (i.e. bits 2-0)
            uint8_t x = b >> 6;
            uint8_t y = ( b & 0x38) >> 3;
            uint8_t z = b & 0x07;
            uint8_t p = (y & 0x06) >> 1;
            uint8_t q = y & 0x01;

            switch ( x ) {
                case 0:
                    //printf("Index %d x=%d y=%d z=%d p=%d q=%d\n",state->index, x,y,z,p,q);
                    if ( state->index && israbbit4k() && q == 1 && z == 2 && p < 2 ) {
                        BUF_PRINTF("%-10s%s,(%s)", p == 0 ? "ldf" : "ld", r4k_32b_table[state->index-1], p == 0 ? handle_addr24(state, opbuf1, sizeof(opbuf1)) : "hl");
                    } else if ( state->index && israbbit4k() && q == 1 && z == 3 && p < 2 ) {
                        BUF_PRINTF("%-10s(%s),%s", p == 0 ? "ldf" : "ld", p == 0 ? handle_addr24(state, opbuf1, sizeof(opbuf1)) : "hl", r4k_32b_table[state->index-1]);
                    } else if ( state->index && israbbit4k() && q == 1 && z == 4 ) {
                        BUF_PRINTF("%-10s%s,(%s+hl)","ld", r4k_32b_table[state->index-1], r4k_ps_table[p]);
                    } else if ( state->index && israbbit4k() && q == 1 && z == 5 ) {
                        BUF_PRINTF("%-10s(%s+hl),%s","ld", r4k_ps_table[p], r4k_32b_table[state->index-1]);
                    } else if ( state->index && israbbit4k() && q == 1 && z == 6 ) {
                        BUF_PRINTF("%-10s%s,(%s%s)","ld", r4k_32b_table[state->index-1], r4k_ps_table[p], handle_displacement(state, opbuf1,sizeof(opbuf1)));
                    } else if ( state->index && israbbit4k() && q == 1 && z == 7 ) {
                        BUF_PRINTF("%-10s(%s%s),%s","ld", r4k_ps_table[p], handle_displacement(state, opbuf1,sizeof(opbuf1)), r4k_32b_table[state->index-1]);
                    } else switch ( z ) {
                        case 0:
                            if ( y == 0 ) BUF_PRINTF("nop");
                            else if ( y == 1 ) {
                                if ( canaltreg() ) BUF_PRINTF("%-10saf,af\'","ex");
                                else if (isgbz80() ) BUF_PRINTF("%-10s(%s),sp","ld",handle_addr16(state, opbuf1,sizeof(opbuf1)));
                                else if (is8085() ) BUF_PRINTF("%-10shl,bc", "sub");
                                else BUF_PRINTF("nop");
                            } else if ( y == 2 ) {
                                if ( isgbz80() ) {
                                    uint8_t p; 
                                    PEEK_BYTE(state, p); 
                                    if ( p == 0 ) READ_BYTE(state, b);
                                    BUF_PRINTF("%-10s","stop");
                                } 
                                else if ( is8080() ) BUF_PRINTF("nop");                            
                                else if ( is8085() ) BUF_PRINTF("%-10shl","sra");                            
                                else BUF_PRINTF("%-10s%s","djnz", handle_rel8(state, opbuf1, sizeof(opbuf1)));                  
                            } else if ( y == 3 ) {
                                if ( is8085() ) BUF_PRINTF("%-10s%s","rl","de");
                                else if ( !is8080() ) BUF_PRINTF("%-10s%s", "jr",handle_rel8(state, opbuf1, sizeof(opbuf1)));
                                else BUF_PRINTF("nop");
                            } else if ( is8085() ) {
                                if ( y == 4 ) BUF_PRINTF("%-10s","rim");
                                else if ( y == 5 ) BUF_PRINTF("%-10sde,hl+%s","ld", handle_immed8(state, opbuf2, sizeof(opbuf2)));
                                else if ( y == 6 ) BUF_PRINTF("%-10s","sim");
                                else if ( y == 7 ) BUF_PRINTF("%-10sde,sp+%s", "ld", handle_immed8(state, opbuf2, sizeof(opbuf2)));
                            } else if ( !is8080() ) BUF_PRINTF("%-10s%s,%s", "jr", cc_table[y-4], handle_rel8(state, opbuf1,  sizeof(opbuf1)));  
                            else BUF_PRINTF("nop");
                            break;
                        case 1:
                           if ( q == 0 ) {
                               if ( isez80() && y == 6 && state->index )
                                   BUF_PRINTF("%-10s%s,%s",handle_ez80_am(state, "ld"), handle_hl(state->index == 1 ? 2 : 1), handle_register8(state, 6, opbuf1, sizeof(opbuf1)));
                               else BUF_PRINTF("%-10s%s,%s",handle_ez80_am(state, "ld"), handle_register16(state, p,state->index), handle_immed16(state, opbuf1, sizeof(opbuf1)));
                           } else BUF_PRINTF("%-10s%s%s,%s", handle_ez80_am(state,"add"), handle_kc_prefix(state->kc_prefix),handle_hl(state->index), handle_register16(state, p, state->index));
                            break;
                        case 2:
                            if ( q == 0 ) {
                                if ( p == 0 ) BUF_PRINTF("%-10s(%sbc),a",handle_ez80_am(state,"ld"),handle_kc_prefix(state->kc_prefix));
                                else if ( p == 1 ) BUF_PRINTF("%-10s(%sde),a",handle_ez80_am(state,"ld"),handle_kc_prefix(state->kc_prefix));
                                else if ( p == 2 && !isgbz80()) BUF_PRINTF("%-10s(%s%s),%s",handle_ez80_am(state,"ld"),handle_kc_segment(state->kc_prefix),handle_addr16(state, opbuf1, sizeof(opbuf1)),handle_hl(state->index));
                                else if ( p == 2 && isgbz80() ) BUF_PRINTF("%-10s(hl+),a","ld");
                                else if ( p == 3 && !isgbz80() ) BUF_PRINTF("%-10s(%s%s),a",handle_ez80_am(state,"ld"),handle_kc_segment(state->kc_prefix),handle_addr16(state, opbuf1, sizeof(opbuf1)));
                                else if ( p == 3 && isgbz80() ) BUF_PRINTF("%-10s(hl-),a","ld");                            
                            } else if ( q == 1 ) {
                                if ( p == 0 ) BUF_PRINTF("%-10sa,(%sbc)",handle_ez80_am(state,"ld"),handle_kc_prefix(state->kc_prefix));
                                else if ( p == 1 ) BUF_PRINTF("%-10sa,(%sde)",handle_ez80_am(state,"ld"),handle_kc_prefix(state->kc_prefix));
                                else if ( p == 2 && !isgbz80() ) BUF_PRINTF("%-10s%s,(%s%s)", handle_ez80_am(state,"ld"),handle_hl(state->index),handle_kc_segment(state->kc_prefix),handle_addr16(state, opbuf1, sizeof(opbuf1)));
                                else if ( p == 2 && isgbz80() ) BUF_PRINTF("%-10sa,(hl+)", "ld");
                                else if ( p == 3 && !isgbz80() ) BUF_PRINTF("%-10sa,(%s%s)",handle_ez80_am(state,"ld"),handle_kc_segment(state->kc_prefix),handle_addr16(state, opbuf1, sizeof(opbuf1)));
                                else if ( p == 3 && isgbz80() ) BUF_PRINTF("%-10sa,(hl-)", "ld");                            
                            } 
                            break;
                        case 3:
                            if ( q == 0 ) BUF_PRINTF("%-10s%s%s", handle_ez80_am(state,"inc"), handle_kc_prefix(state->kc_prefix), handle_register16(state, p, state->index));
                            else BUF_PRINTF("%-10s%s%s", handle_ez80_am(state,"dec"), handle_kc_prefix(state->kc_prefix), handle_register16(state, p, state->index));
                            break;
                        case 4:
                            BUF_PRINTF("%-10s%s", y == 6 ? handle_ez80_am(state,"inc") : "inc",  handle_register8(state, y, opbuf1, sizeof(opbuf1)));
                            break;
                        case 5:
                            BUF_PRINTF("%-10s%s", y == 6 ? handle_ez80_am(state,"dec") : "dec", handle_register8(state, y,opbuf1,sizeof(opbuf1)));
                            break;
                        case 6:
                            if ( isez80() && state->index != 0 && y == 7 ) {
                               BUF_PRINTF("%-10s%s,%s", handle_ez80_am(state, "ld"), handle_register8(state, 6, opbuf1, sizeof(opbuf1)), handle_hl(state->index == 1 ? 2 : 1));
                            }
                            else if (israbbit4k() && state->index != 0 && y == 0) {
                               BUF_PRINTF("%-10sa,(%s+a)", "ld", handle_hl(state->index));
                            } else {
                               handle_register8(state,y,opbuf1,sizeof(opbuf1));
                               handle_immed8(state, opbuf2, sizeof(opbuf2));
                               BUF_PRINTF("%-10s%s,%s", y == 6 ? handle_ez80_am(state, "ld") : "ld", opbuf1, opbuf2);
                            }
                            break;
                        case 7:
                            if ( israbbit() && y == 4 ) BUF_PRINTF("%-10ssp,%s", "add",handle_displacement(state, opbuf1, sizeof(opbuf1)));
                            else if ( isez80() && state->index != 0  ) {
                                if ( q == 0 && y < 6 ) BUF_PRINTF("%-10s%s,%s", handle_ez80_am(state, "ld"), handle_register16(state,p,0), handle_register8(state, 6, opbuf1, sizeof(opbuf1)));
                                else if ( q == 1 && y < 6 ) BUF_PRINTF("%-10s%s,%s", handle_ez80_am(state, "ld"),handle_register8(state, 6, opbuf1, sizeof(opbuf1)), handle_register16(state,p,0));
                                else if ( y == 6 ) BUF_PRINTF("%-10s%s,%s", handle_ez80_am(state, "ld"),handle_hl(state->index), handle_register8(state, 6, opbuf1, sizeof(opbuf1)));
                                else if ( y == 7 ) BUF_PRINTF("%-10s%s,%s", handle_ez80_am(state, "ld"), handle_register8(state, 6, opbuf1, sizeof(opbuf1)), handle_hl(state->index));
                            } else BUF_PRINTF("%-10s", assorted_mainpage_opcodes[y]);
                            break;
                    }
                    break;
                case 1: /* x = 1 */
                    if ( state->index && israbbit4k() && q == 1 && z == 0 ) {
                        BUF_PRINTF("%-10s1,%s", rot_table[p], r4k_32b_table[state->index-1]);
                    } else if ( state->index && israbbit4k() && q == 1 && z == 1 ) {
                        BUF_PRINTF("%-10s2,%s", rot_table[p], r4k_32b_table[state->index-1]);
                    } else if ( state->index && israbbit4k() && q == 1 && z == 3 ) {
                        BUF_PRINTF("%-10s4,%s", rot_table[p], r4k_32b_table[state->index-1]);
                    } else if ( state->index && israbbit4k() && q == 1 && z == 7 ) {
                        BUF_PRINTF("%-10s8,%s", rot_table[p], r4k_32b_table[state->index-1]);
                    } else if ( state->index && israbbit4k() && q == 1 && z == 4 && p < 2 ) {
                        BUF_PRINTF("%-10s%s","test", p == 0 ? handle_hl(state->index) : r4k_32b_table[state->index-1]);
                    } else if ( state->index && israbbit4k() && q == 1 && p == 0 && z == 5 ) {
                        BUF_PRINTF("%-10s%s","neg", r4k_32b_table[state->index-1]);
                    } else if ( z == 6 && y == 6 ) {
                        if ( israbbit() ) { BUF_PRINTF("altd "); state->prefix=0x76; continue; }
                        else BUF_PRINTF("%-10s","halt");
                    } else if ( israbbit4k() && y < 6 && state->index == 0 && z < 6) {
                        // Deal with codes 40 -> 6f
                        //printf("q=%d z=%d y=%d p=%d\n",q,z,y,p);
                        if ( q == 0 && z == 5 ) {
                            if ( p == 0 ) BUF_PRINTF("%-10shl,jk","sub");
                           else if ( p == 1 ) BUF_PRINTF("%-10shl,de","sub");
                           else  BUF_PRINTF("%-10shl,jk","add");
                        } else if ( y < 2  ) {
                            if ( y == 0 && z == 2 ) BUF_PRINTF("%-10shl","rl");
                            else if ( y == 1 && z == 0 ) BUF_PRINTF("%-10shl,%s","cp",handle_displacement(state, opbuf1, sizeof(opbuf1))); // TODO signed
                            else if ( y == 1 && z == 4 ) BUF_PRINTF("%-10shl","test");
                            else if ( y == 1 && z == 5 ) BUF_PRINTF("%-10shl","neg");
                            else BUF_PRINTF("%-10s","no2p");
                        } else if ( q == 0 && z == 0 ) BUF_PRINTF("%-10s%s","rlc", y == 2 ? "de" : "bc");
                        else if ( q == 0 && z == 1 ) BUF_PRINTF("%-10s%s","rrc", y == 2 ? "de" : "bc");
                        else if ( y == 4 && z == 2 ) BUF_PRINTF("%-10sbc","rl");
                        else if ( y == 4 && z == 3 ) BUF_PRINTF("%-10sbc","rr");
                        else if ( y == 2 && z == 4 ) BUF_PRINTF("%-10shl,de","xor");
                        else if ( y == 3 && z == 3 && (israbbit3k()|israbbit4k()) && state->prefix != 0x76) BUF_PRINTF("%-10s", "idet");
                        else if ( y == 3 && z == 3 ) BUF_PRINTF("%-10se,e","ld");
                        else if ( y == 5 && z == 5 ) {
                            // 6d page
                            READ_BYTE(state, b);

                            uint8_t x = b >> 6;
                            uint8_t y = ( b & 0x38) >> 3;
                            uint8_t z = b & 0x07;
                            uint8_t p = (y & 0x06) >> 1;
                            uint8_t q = y & 0x01;

                            if ( z == 0 && q == 0 ) BUF_PRINTF("%-10s%s,(%s%s)", "ld",r4k_16b_table[x], r4k_ps_table[p], handle_displacement(state, opbuf1,sizeof(opbuf1)));
                            else if ( z == 1 && q == 0 ) BUF_PRINTF("%-10s(%s%s),%s", "ld",r4k_ps_table[p], handle_displacement(state, opbuf1,sizeof(opbuf1)), r4k_16b_table[x]);
                            else if ( z == 2 && q == 0 ) BUF_PRINTF("%-10s%s,(%s+hl)", "ld",r4k_16b_table[x],r4k_ps_table[p]);
                            else if ( z == 3 && q == 0 ) BUF_PRINTF("%-10s(%s+hl),%s", "ld",r4k_ps_table[p], r4k_16b_table[x]);
                            else if ( z == 4 && q == 0 ) BUF_PRINTF("%-10s%s,%s+ix", "ld",r4k_ps_table[x], r4k_ps_table[p]);
                            else if ( z == 5 && q == 0 ) BUF_PRINTF("%-10s%s,%s+iy", "ld",r4k_ps_table[x], r4k_ps_table[p]);
                            else if ( z == 6 && q == 0 ) BUF_PRINTF("%-10s%s,%s+de", "ld",r4k_ps_table[x], r4k_ps_table[p]);
                            else if ( z == 7 && q == 0 ) BUF_PRINTF("%-10s%s,%s", "ld",r4k_ps_table[x], r4k_ps_table[p]);
                            else if ( z == 0 && q == 1 ) BUF_PRINTF("%-10s%s,(%s%s)", "ld",r4k_ps_table[x], r4k_ps_table[p], handle_displacement(state, opbuf1,sizeof(opbuf1)));
                            else if ( z == 1 && q == 1 ) BUF_PRINTF("%-10s(%s%s),%s", "ld", r4k_ps_table[p], handle_displacement(state, opbuf1,sizeof(opbuf1)), r4k_ps_table[x]);
                            else if ( z == 2 && q == 1 ) BUF_PRINTF("%-10s%s,(%s+hl)", "ld", r4k_ps_table[x], r4k_ps_table[p]);
                            else if ( z == 3 && q == 1 ) BUF_PRINTF("%-10s(%s+hl),%s", "ld", r4k_ps_table[p], r4k_ps_table[x]);
                            else if ( z == 4 && q == 1 ) BUF_PRINTF("%-10s%s,%s%s", "ld", r4k_ps_table[x], r4k_ps_table[p], handle_displacement(state, opbuf1,sizeof(opbuf1)));
                            else if ( z == 6 && q == 1 ) BUF_PRINTF("%-10s%s,%s+hl", "ld", r4k_ps_table[x], r4k_ps_table[p]);
                            else if ( x == 1 && y == 5 && z == 5 && q == 1 ) BUF_PRINTF("%-10sl,l","ld");
                            else if ( x == 1 && y == 7 && z == 7 && q == 1 ) BUF_PRINTF("%-10sa,a","ld");
                            else BUF_PRINTF("%-10s","nop");
                        } else BUF_PRINTF("%-10s","nop");
                    } else if ( israbbit() && z == 4 && y == 7 && state->index ) {
                        BUF_PRINTF("%-10shl,%s", "ld", handle_register16(state,2, state->index));
                    } else if ( israbbit() && z == 5 && y == 7 && state->index ) {
                        BUF_PRINTF("%-10s%s,hl", "ld", handle_register16(state,2, state->index)); 
                    } else if ( israbbit() && z == 4 && y == 4 && state->index ) {
                        BUF_PRINTF("%-10s(%s),hl", "ldp", handle_register16(state,2, state->index)); 
                    } else if ( israbbit() && z == 5 && y == 4 && state->index ) {
                        BUF_PRINTF("%-10s(%s),%s", "ldp", handle_addr16(state,opbuf1, sizeof(opbuf1)), handle_register16(state,2, state->index));
                    } else if ( israbbit() && z == 4 && y == 5 && state->index ) {
                        BUF_PRINTF("%-10shl,(%s)", "ldp", handle_register16(state,2, state->index)); 
                    } else if ( israbbit() && z == 5 && y == 5 && state->index ) {
                        BUF_PRINTF("%-10s%s,(%s)", "ldp", handle_register16(state,2, state->index),  handle_addr16(state,opbuf1, sizeof(opbuf1)));
                    } else if ( (israbbit3k()|israbbit4k()) && z == 3 && y == 3 && state->index == 0) {
                        if ( state->prefix == 0x76 ) {
                            BUF_RESET();
                            BUF_PRINTF("%-10se',e","ld");
                        } else {
                            BUF_PRINTF("%-10s","idet");
                        }
                    } else if ( israbbit4k() && z == 7 && y == 7 ) {
                        // 7f page - moved instructions
                        READ_BYTE(state, b);

                        uint8_t x = b >> 6;
                        uint8_t y = ( b & 0x38) >> 3;
                        uint8_t z = b & 0x07;
                        uint8_t p = (y & 0x06) >> 1;
                        uint8_t q = y & 0x01;
                        if ( x == 1 && z != 6 && y != 6 ) {
                            handle_register8(state, y, opbuf1, sizeof(opbuf1));
                            handle_register8(state, z, opbuf2, sizeof(opbuf2));
                            if ( y == 6) {
                                state->index = 0;
                                handle_register8(state, z, opbuf2, sizeof(opbuf2));
                            } else if ( z == 6 ) {
                                state->index = 0;
                                handle_register8(state, y, opbuf1, sizeof(opbuf1));  
                            }
                            BUF_PRINTF("%-10s%s,%s", y == 6 || z == 6 ? handle_ez80_am(state,"ld") : "ld", opbuf1, opbuf2);
                        } else if ( x == 2 ) {
                            BUF_PRINTF("%-10s%s", z == 6 ? handle_ez80_am(state,alu_table[y]) : alu_table[y], handle_register8(state, z, opbuf1, sizeof(opbuf1)));
                        } else {
                            BUF_PRINTF("%-10s", "nop");
                        }
                    } else if ( iskc160ext() && z == y ) {
                        state->kc_prefix = z; continue; 
                    } else {
                        if ( isez80() ) {
                            if ( y == z && y < 4) {
                                state->am = y + 1;
                                continue;
                            } 
                        }
                        handle_register8(state, y, opbuf1, sizeof(opbuf1));
                        handle_register8(state, z, opbuf2, sizeof(opbuf2));
                        if ( y == 6) {
                            state->index = 0;
                            handle_register8(state, z, opbuf2, sizeof(opbuf2));
                        } else if ( z == 6 ) {
                            state->index = 0;
                            handle_register8(state, y, opbuf1, sizeof(opbuf1));  
                        }
                        BUF_PRINTF("%-10s%s,%s", y == 6 || z == 6 ? handle_ez80_am(state,"ld") : "ld", opbuf1, opbuf2);
                    }
                    break;
                case 2: /* x = 2 */
                    if ( israbbit4k()) {
                        //printf("x=%d y=%d z=%d p=%d q=%d\n",x,y,z,p,q);
                        if ( state->index && q == 1 && z == 0 ) BUF_PRINTF("%-10s1,%s", rot_table[p+4], r4k_32b_table[state->index-1]);
                        else if ( state->index && q == 1 && z == 1 ) BUF_PRINTF("%-10s2,%s", rot_table[p+4], r4k_32b_table[state->index-1]);
                        else if ( state->index && q == 1 && z == 3 ) BUF_PRINTF("%-10s4,%s", rot_table[p+4], r4k_32b_table[state->index-1]);
                        else if ( state->index && q == 1 && z == 4 ) BUF_PRINTF("%-10s%s,%s", "ldl", r4k_ps_table[p], handle_hl(state->index));
                        else if ( state->index && q == 1 && z == 5 ) BUF_PRINTF("%-10s%s,%s", "ld", r4k_ps_table[p], r4k_32b_table[state->index-1]);
                        else if ( state->index && q == 1 && z == 7 ) BUF_PRINTF("%-10s%s,%s", "ldl", r4k_ps_table[p], rp2_table[state->index]);
                        else if ( state->index && z == 6 ) BUF_PRINTF("%-10s%s", alu_table[y], handle_register8(state, z, opbuf1, sizeof(opbuf1)));
                        else if ( q == 0 && z == 5 ) BUF_PRINTF("%-10shl,(%s%s)", "ld", r4k_ps_table[p], handle_displacement(state, opbuf1, sizeof(opbuf1)));
                        else if ( q == 0 && z == 6 ) BUF_PRINTF("%-10s(%s%s),hl", "ld", r4k_ps_table[p], handle_displacement(state, opbuf1, sizeof(opbuf1)));
                        else if ( q == 1 && z == 3 ) BUF_PRINTF("%-10sa,(%s+hl)", "ld", r4k_ps_table[p]);
                        else if ( q == 1 && z == 4 ) BUF_PRINTF("%-10s(%s+hl),a", "ld", r4k_ps_table[p]);
                        else if ( q == 1 && z == 5 ) BUF_PRINTF("%-10sa,(%s%s)", "ld", r4k_ps_table[p],  handle_displacement(state, opbuf1, sizeof(opbuf1)));
                        else if ( q == 1 && z == 6 ) BUF_PRINTF("%-10s(%s%s),a", "ld", r4k_ps_table[p],  handle_displacement(state, opbuf1, sizeof(opbuf1)));
                        else if ( q == 1 && z == 0 && y == 3 ) BUF_PRINTF("%-10s%s","jre", handle_rel16(state, opbuf1, sizeof(opbuf1)));
                        else if ( y > 3 && z == 0 ) BUF_PRINTF("%-10s%s,%s", "jr", r4k_cc_table[y-4], handle_rel8(state,opbuf1,sizeof(opbuf1)));
                        else if ( y > 3 && z == 2 ) BUF_PRINTF("%-10s%s,%s", "jp", r4k_cc_table[y-4], handle_addr16(state,opbuf1,sizeof(opbuf1)));
                        else if ( y == 0 && q == 0 && z == 1 ) BUF_PRINTF("%-10shl,bc","ld");
                        else if ( y == 0 && q == 0 && z == 2 ) BUF_PRINTF("%-10s(%s),hl","ldf", handle_addr24(state,opbuf1,sizeof(opbuf1)));
                        else if ( y == 2 && q == 0 && z == 1 ) BUF_PRINTF("%-10sbc,hl","ld");
                        else if ( y == 2 && q == 0 && z == 2 ) BUF_PRINTF("%-10shl,(%s)","ldf", handle_addr24(state,opbuf1,sizeof(opbuf1)));
                        else if ( y == 4 && q == 0 && z == 1 ) BUF_PRINTF("%-10shl,de","ld");
                        else if ( y == 6 && q == 0 && z == 1 ) BUF_PRINTF("%-10sde,hl","ld");
                        else if ( y == 2 && q == 0 && z == 7 ) BUF_PRINTF("%-10slxpc,hl","ld");
                        else if ( y == 4 && q == 0 && z == 7 ) BUF_PRINTF("%-10s","mulu");
                        else if ( y == 6 && q == 0 && z == 7 ) BUF_PRINTF("%-10sa","or");
                        else if ( y == 1 && q == 1 && z == 1 ) BUF_PRINTF("%-10s(%s),jk","ld", handle_addr16(state,opbuf1,sizeof(opbuf1)));
                        else if ( y == 1 && q == 1 && z == 2 ) BUF_PRINTF("%-10s(%s),a","ldf", handle_addr24(state,opbuf1,sizeof(opbuf1)));
                        else if ( y == 3 && q == 1 && z == 1 ) BUF_PRINTF("%-10sjk,(%s)","ld", handle_addr16(state,opbuf1,sizeof(opbuf1)));
                        else if ( y == 3 && q == 1 && z == 2 ) BUF_PRINTF("%-10sa,(%s)","ldf", handle_addr24(state,opbuf1,sizeof(opbuf1)));
                        else if ( y == 3 && q == 1 && z == 7 ) BUF_PRINTF("%-10shl,lxpc","ld");
                        else if ( y == 5 && q == 1 && z == 1 ) BUF_PRINTF("%-10sjk,%s","ld", handle_immed16(state,opbuf1,sizeof(opbuf1)));
                        else if ( y == 5 && q == 1 && z == 7 ) BUF_PRINTF("%-10sa","xor");
                        else if ( y == 7 && q == 1 && z == 1 ) BUF_PRINTF("%-10sjk,hl","ex");
                        else if ( y == 7 && q == 1 && z == 7 ) BUF_PRINTF("%-10shl","clr");
                        else if ( y == 0 && q == 0 && (z == 3 || z == 4) ) BUF_PRINTF("%-10s(%s),%s", "ld", handle_addr16(state,opbuf1,sizeof(opbuf1)), r4k_32b_table[z-3]);
                        else if ( y == 2 && q == 0 && (z == 3 || z == 4) ) BUF_PRINTF("%-10s%s,(%s)", "ld", r4k_32b_table[z-3], handle_addr16(state,opbuf1,sizeof(opbuf1)));
                        else if ( y == 4 && q == 0 && (z == 3 || z == 4) ) BUF_PRINTF("%-10s%s,%s", "ld", r4k_32b_table[z-3],handle_displacement(state, opbuf1, sizeof(opbuf1)));
                        else if ( y == 6 && q == 0 && z == 3 ) BUF_PRINTF("%-10sbc,hl", "ex");
                        else if ( y == 6 && q == 0 && z == 4 ) BUF_PRINTF("%-10sjkhl,bcde", "ex");
                        else if ( z == 7 && p == 0 ) {
                            handle_addr16(state, opbuf1, sizeof(opbuf1));
                            handle_immed16(state, opbuf2, sizeof(opbuf2));
                            BUF_PRINTF("%-10s%s,%s", q == 0 ? "lljp" : "llcall", opbuf2, opbuf1); 
                        }
                    } else BUF_PRINTF("%-10s%s", z == 6 ? handle_ez80_am(state,alu_table[y]) : alu_table[y], handle_register8(state, z, opbuf1, sizeof(opbuf1)));
                    break;
                case 3: /* x = 3 */
                    if ( z == 0 ) {
                        if ( !isgbz80() || y < 4 ) BUF_PRINTF("%-10s%s",handle_ez80_am(state,"ret"), israbbit()?rabbit_cc_table[y]:cc_table[y]);
                        else {
                            // gbz80 codes
                            if ( y == 4 ) BUF_PRINTF("%-10s($ff00+%s),a","ld", handle_immed8(state, opbuf1, sizeof(opbuf2)));
                            else if ( y == 5 ) BUF_PRINTF("%-10ssp,%s","add", handle_displacement(state, opbuf1, sizeof(opbuf2)));
                            else if ( y == 6 ) BUF_PRINTF("%-10sa,($ff00+%s)","ld", handle_immed8(state, opbuf1, sizeof(opbuf2)));
                            else if ( y == 7 ) BUF_PRINTF("%-10shl,sp%s","ld", handle_displacement(state, opbuf1, sizeof(opbuf2)));
                        }
                    } else if ( z == 1 ) {
                        if  ( q == 0 && p == 3 && state->index && israbbit4k() ) BUF_PRINTF("%-10s%s","pop", r4k_32b_table[state->index-1]);
                        else if  ( q == 0 ) BUF_PRINTF("%-10s%s",handle_ez80_am(state,"pop"), handle_register16_2(state,p, state->index));
                        else if ( q == 1 ) {
                            if ( p == 0 ) { BUF_PRINTF("%-10s", handle_ez80_am(state,"ret")); dolf=1; }
                            else if ( p == 1 && is8080() ) BUF_PRINTF("nop");
                            else if ( p == 1 && is8085() ) BUF_PRINTF("%-10s(de),hl","ld");
                            else if ( p == 1 && !isgbz80() ) BUF_PRINTF("exx");
                            else if ( p == 1 && isgbz80() ) { BUF_PRINTF("reti"); dolf=1; }
                            else if ( p == 2 ) BUF_PRINTF("%-10s(%s%s)",handle_ez80_am(state,"jp"),handle_kc_prefix(state->kc_prefix),handle_register16(state, 2, state->index)); 
                            else if ( p == 3 ) BUF_PRINTF("%-10ssp,%s", handle_ez80_am(state,"ld"), handle_register16(state, 2, state->index)); 
                        }
                    } else if ( z == 2 ) { 
                        if ( y == 5 && israbbit4k() && state->index ) BUF_PRINTF("%-10s(%s)", "call", handle_hl(state->index));
                        else if ( !isgbz80() || y < 4 ) BUF_PRINTF("%-10s%s,%s", handle_ez80_am(state,"jp"),israbbit()?rabbit_cc_table[y]:cc_table[y], handle_addr16(state, opbuf1, sizeof(opbuf1)));
                        else {
                            if ( y == 4 ) BUF_PRINTF("%-10s($ff00+c),a","ld");
                            else if ( y == 5 ) BUF_PRINTF("%-10s(%s),a","ld",handle_addr16(state,opbuf1,sizeof(opbuf1)));
                            else if ( y == 6 )  BUF_PRINTF("%-10sa,($ff00+c)","ld");
                            else if ( y == 7 ) BUF_PRINTF("%-10sa,(%s)","ld",handle_addr16(state,opbuf1,sizeof(opbuf1)));                        
                        }
                    } else if  ( z == 3 ) {
                        if ( y == 0 ) BUF_PRINTF("%-10s%s", handle_ez80_am(state,"jp"), handle_addr16(state, opbuf1, sizeof(opbuf1)));
                        else if ( y == 1 && is8085() ) BUF_PRINTF("%-10sv,$0040","rst");
                        else if ( y == 1 && is8080() ) BUF_PRINTF("nop");
                        else if ( y == 1 ) {
                            state->prefix = 0xcb;
                            if ( state->index ) {
                                READ_BYTE(state, state->displacement);
                            }
                            READ_BYTE(state, b);
                            uint8_t x = b >> 6;
                            uint8_t y = ( b & 0x38) >> 3;
                            uint8_t z = b & 0x07;

                            if ( x == 0 ) {
                                char *instr = handle_rot(state, y);
                                if ( state->index && z != 6 && instr ) {
                                    handle_register8(state, 6, opbuf2, sizeof(opbuf2));
                                    state->index = 0;
                                    handle_register8(state, z, opbuf1, sizeof(opbuf1));
                                    if ( cancbundoc() ) BUF_PRINTF("%-10s%s,%s %s","ld", opbuf1, instr, opbuf2);
                                    else BUF_PRINTF("nop");
                                } else if ( instr ) BUF_PRINTF("%-10s%s", z == 6 ? handle_ez80_am(state,instr) : instr, handle_register8(state, z, opbuf1, sizeof(opbuf1)));
                                else BUF_PRINTF("nop");
                            } else if ( x == 1 ) {
                                if ( cancbundoc() && state->index ) {
                                    z = 6;
                                }
                                if ( !cancbundoc() && state->index && z != 6 ) BUF_PRINTF("nop");
                                else BUF_PRINTF("%-10s%d,%s", handle_ez80_am(state,"bit"), y, handle_register8(state, z, opbuf1, sizeof(opbuf1)));                 // TODO: Undocumented
                            } else if ( x == 2 ) {
                                if ( state->index && z != 6 ) {
                                    handle_register8(state, 6, opbuf2, sizeof(opbuf2));
                                    state->index = 0;
                                    handle_register8(state, z, opbuf1, sizeof(opbuf1));
                                    if ( cancbundoc() ) BUF_PRINTF("%-10s%s,%s %d,%s","ld", opbuf1, "res",y, opbuf2);
                                    else BUF_PRINTF("nop");
                                } else BUF_PRINTF("%-10s%d,%s", handle_ez80_am(state,"res"), y, handle_register8(state, z, opbuf1, sizeof(opbuf1)));                 // TODO: Undocumented
                            } else if ( x == 3 ) {
                                if ( cancbundoc() && state->index && z != 6 ) {
                                    handle_register8(state, 6, opbuf2, sizeof(opbuf2));
                                    state->index = 0;
                                    handle_register8(state, z, opbuf1, sizeof(opbuf1));
                                    if ( cancbundoc() ) BUF_PRINTF("%-10s%s,%s %d,%s","ld", opbuf1, "set",y, opbuf2);
                                    else BUF_PRINTF("nop");
                                } else BUF_PRINTF("%-10s%d,%s", handle_ez80_am(state,"set"), y, handle_register8(state, z, opbuf1, sizeof(opbuf1)));                 // TODO: Undocumented
                            }
                            state->prefix = 0;
                        } else if ( y == 2 ) {
                            if ( israbbit() ) { BUF_PRINTF("ioi "); continue; }
                            else if ( !isgbz80() ) BUF_PRINTF("%-10s(%s),a","out", handle_immed8(state, opbuf1, sizeof(opbuf1)));
                            else BUF_PRINTF("nop");
                        } else if ( y == 3 ) {
                            if ( israbbit() ) { BUF_PRINTF("ioe "); continue; }
                            else if ( !isgbz80() ) BUF_PRINTF("%-10sa,(%s)","in", handle_immed8(state, opbuf1, sizeof(opbuf1)));
                            else BUF_PRINTF("nop");
                        } else if ( y == 4 ) {
                            if ( israbbit() && state->index == 0 ) BUF_PRINTF("%-10sde',hl","ex");
                            else if ( !isgbz80() ) BUF_PRINTF("%-10s(sp),%s",  handle_ez80_am(state,"ex"), handle_register16(state, 2, state->index)); 
                            else BUF_PRINTF("nop");
                        } else if ( y == 5 ) {
                            if ( !isgbz80() ) BUF_PRINTF("%-10s%s,%s","ex","de","hl");
                            else BUF_PRINTF("nop");
                        } else if ( y == 6 ) { if (israbbit()) BUF_PRINTF("%-10s%s","rl","de"); else BUF_PRINTF("%-10s", "di"); }
                        else if ( y == 7 ) { if (israbbit()) BUF_PRINTF("%-10s%s","rr","de"); else BUF_PRINTF("%-10s", "ei"); }
                    } else if ( z == 4 ) { 
                        if ( israbbit() ) {
                            if ( y == 0 ) BUF_PRINTF("%-10s%s,(sp+%s)","ld",handle_register16(state, 2, state->index), handle_immed8(state, opbuf1, sizeof(opbuf1)));
                            else if ( y == 1 ) BUF_PRINTF("%-10s%s","bool",handle_register16(state, 2, state->index));
                            else if ( y == 2 ) BUF_PRINTF("%-10s(sp+%s),%s","ld",handle_immed8(state, opbuf1, sizeof(opbuf1)),handle_register16(state, 2, state->index));
                            else if ( y == 3 ) BUF_PRINTF("%-10s%s,de", "and",handle_register16(state,2, state->index));
                            else if ( y == 4 ) BUF_PRINTF("%-10shl,(%s%s)","ld", handle_register16(state,2, state->index == 0 ? 1 : state->index == 1 ? 0 : 2), handle_displacement(state, opbuf1, sizeof(opbuf1)));
                            else if ( y == 5 ) BUF_PRINTF("%-10s%s,de", "or",handle_register16(state,2, state->index));
                            else if ( y == 6 ) BUF_PRINTF("%-10s(%s%s),hl","ld",handle_register16(state,2, state->index == 0 ? 1 : state->index == 1 ? 0 : 2), handle_displacement(state, opbuf1, sizeof(opbuf1)));
                            else if ( y == 7 ) BUF_PRINTF("%-10s%s", "rr",handle_register16(state,2, state->index));
                        } else if ( isgbz80() && y >= 4 ) BUF_PRINTF("nop");
                        else BUF_PRINTF("%-10s%s,%s", handle_ez80_am(state,"call"), israbbit()?rabbit_cc_table[y]:cc_table[y], handle_addr16(state, opbuf1, sizeof(opbuf1)));
                    } else if ( z == 5 ) {
                        if ( q == 0 && p == 3 && state->index && israbbit4k() ) BUF_PRINTF("%-10s%s", "push", r4k_32b_table[state->index-1]);
                        else if ( q == 0 ) BUF_PRINTF("%-10s%s",handle_ez80_am(state,"push"),handle_register16_2(state,p, state->index));
                        else if ( q == 1 ) {
                            if ( state->index && israbbit4k() ) BUF_PRINTF("%-10s%s,%s","ld",r4k_32b_table[state->index-1], r4k_ps_table[p]);
                            else if ( p == 0 ) BUF_PRINTF("%-10s%s", handle_ez80_am(state,"call"), handle_addr16(state, opbuf1, sizeof(opbuf1)));
                            else if ( p == 1 && is8085() ) BUF_PRINTF("%-10snk,%s", handle_ez80_am(state,"jp"),handle_addr16(state, opbuf1, sizeof(opbuf1))    );
                            else if ( p == 1 && canindex() ) { state->index = 1; continue; }
                            else if ( p == 2 && is8085() ) BUF_PRINTF("%-10shl,(de)","ld");
                            else if ( p == 2 && canindex() ) { // ED page
                                READ_BYTE(state, b);
                                uint8_t x = b >> 6;
                                uint8_t y = ( b & 0x38) >> 3;
                                uint8_t z = b & 0x07;
                                uint8_t p = (y & 0x06) >> 1;
                                uint8_t q = y & 0x01;
                               //printf("x=%d y=%d z=%dp=%d q=%d\n",x,y,z,p,q);
                                state->index = 0;
                                if ( x == 0 ) {
                                    if ( israbbit4k() ) {
                                        // $ed 00 -> $ed 3f
                                        if ( q == 0 && z == 0 && y == 0 ) BUF_PRINTF("%-10s%s","cbm", handle_immed8(state, opbuf1, sizeof(opbuf1)));
                                        else if ( q == 0 && z == 0 && y == 2 ) BUF_PRINTF("%-10s%s","dwjnz", handle_rel8(state, opbuf1, sizeof(opbuf1)));
                                        else if ( q == 0 && z == 2 && y == 0 ) BUF_PRINTF("%-10sa","sbox");
                                        else if ( q == 0 && z == 2 && y == 2 ) BUF_PRINTF("%-10sa","ibox");
                                        else if ( q == 0 && z == 1 ) BUF_PRINTF("%-10s%s,(htr+hl)","ld",r4k_ps_table[p]);
                                        else if ( q == 0 && z == 3 ) BUF_PRINTF("%-10s%s,(sp+%s)","ldl", r4k_ps_table[p],handle_immed8(state, opbuf1, sizeof(opbuf1)));
                                        else if ( q == 0 && z == 4 ) BUF_PRINTF("%-10s%s,(sp+%s)","ld", r4k_ps_table[p],handle_immed8(state, opbuf1, sizeof(opbuf1)));
                                        else if ( q == 0 && z == 5 ) BUF_PRINTF("%-10s(sp+%s),%s","ld", handle_immed8(state, opbuf1, sizeof(opbuf1)), r4k_ps_table[p]);
                                        else if ( q == 0 && z == 6 ) BUF_PRINTF("%-10shl,(%s+bc)","ld", r4k_ps_table[p]);
                                        else if ( q == 0 && z == 7 ) BUF_PRINTF("%-10s(%s+bc),hl","ld", r4k_ps_table[p]);
                                        else if ( q == 1 && z == 0 ) BUF_PRINTF("%-10s%s,(%s)", "ldf", r4k_ps_table[p], handle_addr24(state, opbuf1,sizeof(opbuf1))) ;
                                        else if ( q == 1 && z == 1 ) BUF_PRINTF("%-10s(%s),%s", "ldf", handle_addr24(state, opbuf1,sizeof(opbuf1)), r4k_ps_table[p]);
                                        else if ( q == 1 && z == 2 ) BUF_PRINTF("%-10s%s,(%s)", "ldf", r4k_16b_table[p], handle_addr24(state, opbuf1,sizeof(opbuf1))) ;
                                        else if ( q == 1 && z == 3 ) BUF_PRINTF("%-10s(%s),%s", "ldf", handle_addr24(state, opbuf1,sizeof(opbuf1)), r4k_16b_table[p]);
                                        else if ( q == 1 && z == 4 ) BUF_PRINTF("%-10s%s,%s", "ld", r4k_ps_table[p], handle_immed32(state, opbuf1,sizeof(opbuf1)));
                                        else if ( q == 1 && z == 5 ) BUF_PRINTF("%-10s%s,%s", "ldl", r4k_ps_table[p], handle_immed16(state, opbuf1,sizeof(opbuf1)));
                                        else if ( q == 1 && z == 6 ) BUF_PRINTF("%-10s%s", "convc", r4k_ps_table[p]);
                                        else if ( q == 1 && z == 7 ) BUF_PRINTF("%-10s%s", "convd", r4k_ps_table[p]);
                                        else BUF_PRINTF("nop");
                                    } else if ( isz180() || isez80() ) {
                                        if ( z == 4 ) BUF_PRINTF("%-10s%s",y == 6 && isez80() ? handle_ez80_am(state,"tst") : "tst",handle_register8(state,y, opbuf1, sizeof(opbuf1)));
                                        else if ( z == 0 ) BUF_PRINTF("%-10s%s,(%s)","in0",y == 6 ? "f" : handle_register8(state,y, opbuf1, sizeof(opbuf1)), handle_immed8(state, opbuf2, sizeof(opbuf2)));
                                        else if ( z == 1 && y != 6) BUF_PRINTF("%-10s(%s),%s","out0",handle_immed8(state, opbuf2, sizeof(opbuf2)),handle_register8(state,y, opbuf1, sizeof(opbuf1)));
                                        else if ( z == 1 && isez80() ) BUF_PRINTF("%-10siy,(hl)",handle_ez80_am(state,"ld"));
                                        else if ( (z == 2 || z == 3) && isez80() ) BUF_PRINTF("%-10s%s,%s%s", handle_ez80_am(state,"lea"), y == 6 ? handle_hl(z-1) : handle_register16(state, p, 0), handle_hl(z-1), handle_displacement(state, opbuf1, sizeof(opbuf1)));
                                        else if ( z == 7 && isez80() ) {
                                            if ( q == 1 ) BUF_PRINTF("%-10s(hl),%s", handle_ez80_am(state,"ld"), p == 3 ? handle_hl(1) : handle_register16(state, p, 0));
                                            else BUF_PRINTF("%-10s%s,(hl)",handle_ez80_am(state, "ld"), p == 3 ? handle_hl(1) : handle_register16(state, p, 0));
                                        } else if ( z == 6 && isez80()) {
                                            if ( q == 1 ) BUF_PRINTF("%-10s(hl),iy",handle_ez80_am(state, "ld"));
                                            else BUF_PRINTF("%-10siy,(hl)",handle_ez80_am(state, "ld"));
                                        }
                                        else BUF_PRINTF("nop");
                                    } else if ( isz80n() ) {
                                        if ( b == 0x23 ) BUF_PRINTF("swapnib");
                                        else if ( b == 0x24 ) BUF_PRINTF("mirror    a");
                                        else if ( b == 0x27 ) BUF_PRINTF("test      %s",handle_immed8(state, opbuf1, sizeof(opbuf1)));                                    
                                        else if ( b == 0x28 ) BUF_PRINTF("bsla      de,b");
                                        else if ( b == 0x29 ) BUF_PRINTF("bsra      de,b");
                                        else if ( b == 0x2a ) BUF_PRINTF("bsrl      de,b");
                                        else if ( b == 0x2b ) BUF_PRINTF("bsrf      de,b");
                                        else if ( b == 0x2c ) BUF_PRINTF("brlc      de,b");
                                        else if ( b == 0x30 ) BUF_PRINTF("mul       d,e");
                                        else if ( b == 0x31 ) BUF_PRINTF("add       hl,a");
                                        else if ( b == 0x32 ) BUF_PRINTF("add       de,a");
                                        else if ( b == 0x33 ) BUF_PRINTF("add       bc,a");
                                        else if ( b == 0x34 ) BUF_PRINTF("add       hl,%s",handle_immed16(state, opbuf1, sizeof(opbuf1)));
                                        else if ( b == 0x35 ) BUF_PRINTF("add       de,%s",handle_immed16(state, opbuf1, sizeof(opbuf1)));
                                        else if ( b == 0x36 ) BUF_PRINTF("add       bc,%s",handle_immed16(state, opbuf1, sizeof(opbuf1)));
                                        else BUF_PRINTF("nop");                              
                                    } else if (iskc160() ) {
                                        if ( q == 0 && z < 3 && p < 3 ) BUF_PRINTF("%-10s(%s%s),%s", "ld", kc160_handle_register_rel(state,z), handle_displacement(state, opbuf1,sizeof(opbuf1)), kc160_handle_register_r24(state, p));
                                        else if ( q == 1 && z < 3 && p < 3 ) BUF_PRINTF("%-10s%s,(%s%s)", "ld", kc160_handle_register_r24(state, p), kc160_handle_register_rel(state,z), handle_displacement(state, opbuf1,sizeof(opbuf1)));
                                        else if ( q == 0 && z == 7 && p < 3) BUF_PRINTF("%-10s%s","push", kc160_handle_register_r24(state, p));
                                        else if ( q == 1 && z == 7 && p < 3) BUF_PRINTF("%-10s%s","pop", kc160_handle_register_r24(state, p));
                                        else if ( q == 1 && z == 6 && p < 3) BUF_PRINTF("%-10s%s,%s","ld", kc160_handle_register_r24(state, p),handle_immed24(state, opbuf1, sizeof(opbuf1)));
                                        else if ( q == 0 && z == 3 && p < 3) BUF_PRINTF("%-10s(%s),%s", "ldf", handle_addr24(state, opbuf1, sizeof(opbuf1)), kc160_handle_register_r24(state,p));
                                        else if ( q == 1 && z == 3 && p < 3) BUF_PRINTF("%-10s%s,(%s)", "ldf", kc160_handle_register_r24(state,p), handle_addr24(state, opbuf1, sizeof(opbuf1)));
                                        else if ( q == 0 && z == 6 && p < 3) BUF_PRINTF("%-10s%s,sp", "ld", p == 0 ? "ix" : p == 1 ? "iy" : "hl");
                                        else if ( b == 0x33 ) BUF_PRINTF("%-10s(%s),a", "ldf", handle_addr24(state, opbuf1, sizeof(opbuf1)));
                                        else if ( b == 0x3b ) BUF_PRINTF("%-10sa,(%s)", "ldf", handle_addr24(state, opbuf1, sizeof(opbuf1)));
                                        else BUF_PRINTF("nop");
                                    } else BUF_PRINTF("nop");
                                } else if ( x == 1 ) {
                                    // 01 101 100                                
                                    switch ( z ) {
                                        case 0:
                                            if ( israbbit() ) {
                                                if ( q == 0 && p == 0 && israbbit4k() ) {
                                                    BUF_PRINTF("%-10shtr,a","ld");
                                                } else if ( q == 0 && p == 1 && israbbit4k() ) {
                                                    BUF_PRINTF("%-10sa,htr","ld");
                                                } else if ( q == 1 && p == 0 && israbbit4k() ) {
                                                    BUF_PRINTF("%-10shl,de","cp");
                                                } else if ( q == 1 && p == 1 && israbbit4k() ) {
                                                    BUF_PRINTF("%-10sjkhl,bcde","cp");
                                                } else BUF_PRINTF("nop");
                                            } else {
                                                if ( y != 6 ) BUF_PRINTF("%-10s%s,(%s)", "in",handle_register8(state, y, opbuf1, sizeof(opbuf1)), isez80() ? "bc" : "c");
                                                else BUF_PRINTF("%-10s(c)","in");
                                            } 
                                            break;
                                        case 1:
                                            if ( israbbit() ) {
                                                if ( y < 6 ) {
                                                    if ( q == 0 ) BUF_PRINTF("%-10s%s',de","ld",handle_register16(state, p, state->index));
                                                    else BUF_PRINTF("%-10s%s',bc","ld",handle_register16(state, p, state->index));
                                                } else BUF_PRINTF("nop");
                                            } else {
                                                if ( y != 6 ) BUF_PRINTF("%-10s(%s),%s", "out", !isez80() ? "c" : "bc", handle_register8(state, y, opbuf1, sizeof(opbuf1)));
                                                else BUF_PRINTF("%-10s(c),0","out");
                                            }
                                            break;                     
                                        case 2:
                                            if ( q == 0 ) BUF_PRINTF("%-10s%shl,%s", handle_ez80_am(state,"sbc"), handle_kc_prefix(state->kc_prefix), handle_register16(state, p, state->index));
                                            else BUF_PRINTF("%-10s%shl,%s",handle_ez80_am(state,"adc"), handle_kc_prefix(state->kc_prefix), handle_register16(state, p, state->index));
                                            break;
                                        case 3:
                                            if ( q == 0 ) BUF_PRINTF("%-10s(%s%s),%s", handle_ez80_am(state, "ld"), handle_kc_segment(state->kc_prefix), handle_addr16(state, opbuf1, sizeof(opbuf1)), handle_register16(state, p, state->index));
                                            else BUF_PRINTF("%-10s%s,(%s%s)", handle_ez80_am(state, "ld"), handle_register16(state, p, state->index), handle_kc_segment(state->kc_prefix), handle_addr16(state, opbuf1, sizeof(opbuf1)));
                                            break;
                                        case 4:
                                            if ( israbbit() ) {
                                                if ( y == 0 ) BUF_PRINTF("%-10s","neg");
                                                else if ( y == 1 && israbbit4k() ) BUF_PRINTF("%-10sbc","test");
                                                else if ( y == 2 ) BUF_PRINTF("%-10s(sp),hl","ex");
                                                else if ( y == 4 ) BUF_PRINTF("%-10s(hl),hl","ldp");
                                                else if ( y == 5 ) BUF_PRINTF("%-10shl,(hl)","ldp");
                                                else if ( y == 6 && israbbit4k() ) BUF_PRINTF("%-10sbc',hl","ex");
                                                else if ( y == 7 && israbbit4k() ) BUF_PRINTF("%-10sjk',hl","ex");
                                                else BUF_PRINTF("nop");
                                            } else if ( isz180() || isez80() ) {
                                                if ( y == 0 )  BUF_PRINTF("%-10s","neg");
                                                else if ( y == 6 ) BUF_PRINTF("%-10s%s","tstio", handle_immed8(state, opbuf1, sizeof(opbuf1)));
                                                else if ( y == 4 ) BUF_PRINTF("%-10s%s","tst", handle_immed8(state, opbuf1, sizeof(opbuf1)));
                                                else if ( y == 2 && isez80()) BUF_PRINTF("%-10six,iy%s",handle_ez80_am(state,"lea"),handle_displacement(state, opbuf1, sizeof(opbuf1)));
                                                else if ( (y % 2 )&& p >= 0 && p <= 3 ) BUF_PRINTF("%-10s%s",p == 3 ? handle_ez80_am(state,"mlt") : "mlt", handle_register16(state,p,0));
                                                else BUF_PRINTF("nop");
                                            } else if ( iskc160() ) {
                                                if ( y == 0 ) BUF_PRINTF("%-10s","neg");
                                                else if ( y == 1 ) BUF_PRINTF("%-10s%s", "call3", handle_addr24(state, opbuf1, sizeof(opbuf1)));
                                                else if ( y == 2 ) BUF_PRINTF("%-10s","tra");
                                                else if ( y == 3 ) BUF_PRINTF("%-10s","ret3");
                                                else if ( y == 6 ) BUF_PRINTF("%-10shl,a","div");
                                                else if ( y == 7 ) BUF_PRINTF("%-10shl,a","divs");
                                                else BUF_PRINTF("nop");
                                            } else {
                                                BUF_PRINTF("neg");
                                            }
                                            break;
                                        case 5:
                                            if ( israbbit() && y == 0 ) BUF_PRINTF("lret");
                                            if ( y == 1 ) { BUF_PRINTF("%-10s", handle_ez80_am(state, "reti"));; dolf=1; }
                                            else if ( israbbit4k() && y == 2 ) BUF_PRINTF("fsyscall");
                                            else if ( israbbit() && y == 3 ) BUF_PRINTF("ipres");
                                            else if ( israbbit() && y == 4 ) BUF_PRINTF("%-10s(%s),hl","ldp", handle_addr16(state, opbuf1, sizeof(opbuf1)));
                                            else if ( israbbit() && y == 5 ) BUF_PRINTF("%-10shl,(%s)","ldp", handle_addr16(state, opbuf1, sizeof(opbuf1)));
                                            else if ( israbbit() && y == 6 ) BUF_PRINTF("%-10s", c_cpu & (CPU_R3K|CPU_R4K) ? "syscall" : "nop");
                                            else if ( israbbit() && y == 7 ) BUF_PRINTF("%-10s", c_cpu & (CPU_R3K|CPU_R4K) ? "sures" : "nop");
                                            else if ( (isz180() || isez80()) && y == 0 ) { BUF_PRINTF("%10s", handle_ez80_am(state,"retn")); dolf=1; }
                                            else if ( isez80() && y == 2 ) BUF_PRINTF("%-10siy,ix%s",handle_ez80_am(state,"lea"),handle_displacement(state, opbuf1, sizeof(opbuf1)));                                        
                                            else if ( isez80() && y == 4 ) BUF_PRINTF("%-10six%s",handle_ez80_am(state,"pea"),handle_displacement(state, opbuf1, sizeof(opbuf1)));                                        
                                            else if ( isez80() && y == 5 ) BUF_PRINTF("%-10smb,a","ld");                                        
                                            else if ( isez80() && y == 7 ) BUF_PRINTF("%-10s","stmix");     
                                            else if ( iskc160() && y == 2 ) BUF_PRINTF("%-10s","retn3");                                   
                                            else if ( iskc160() && y == 6 ) BUF_PRINTF("%-10sdehl,bc","div");                                   
                                            else if ( iskc160() && y == 7 ) BUF_PRINTF("%-10sdehl,bc","divs");                                   
                                            else if ( (isz180() || isez80() || iskc160()) && y != 0 ) BUF_PRINTF("nop");
                                            else if ( !israbbit() ) { BUF_PRINTF("%-10s", handle_ez80_am(state,"retn")); dolf=1; }
                                            break;
                                        case 6:
                                            if ( isez80() && y == 4 ) BUF_PRINTF("%-10siy%s",handle_ez80_am(state,"pea"),handle_displacement(state, opbuf1, sizeof(opbuf1)));                                        
                                            else BUF_PRINTF("%s",handle_im_instructions(state,y));
                                            break;
                                        case 7:
                                            BUF_PRINTF("%s", handle_ed_assorted_instructions(state,y));
                                            break;
                                    }
                                } else if ( x == 2 ) {
                                    // LDISR = 98 = 10 011 000
                                    //printf("x=%d y=%d z=%d p=%d q=%d\n",x,y,z,p,q);
                                    if ( isez80() && y < 4 && z >=2 && z <= 4 ) {
                                        static char *instrs[4][3] = {
                                            { "inim", "otim", "ini2" },
                                            { "indm", "otdm", "ind2" },
                                            { "inimr", "otimr", "ini2r" },
                                            { "indmr", "otdmr", "ind2r" }
                                        };
                                        BUF_PRINTF("%-10s",handle_ez80_am(state,instrs[y][z-2]));
                                    } else if ( (isz180() ) && z == 3 && y < 4 ) {
                                        char *instr[] = { "otim", "otdm", "otimr", "otdmr"};
                                        BUF_PRINTF("%s", instr[y]);
                                    } else if ( y < 2 && z == 0 && israbbit4k() ) {
                                        BUF_PRINTF("%-10s",y == 0 ? "copy" : "copyr");
                                    } else if ( y < 2 && z == 3 && israbbit4k() ) {
                                        BUF_PRINTF("%-10s",y == 0 ? "sret" : "llret");
                                    } else if ( z == 2 && y > 3 && israbbit4k() ) {
                                        handle_addr16(state, opbuf1, sizeof(opbuf1));
                                        handle_immed16(state, opbuf2, sizeof(opbuf2));
                                        BUF_PRINTF("%-10s%s,%s,%s","lljp", r4k_cc_table[y-4], opbuf2, opbuf1);
                                    } else if ( z == 3 && y > 3 && israbbit4k() ) {
                                        BUF_PRINTF("%-10s%s,%s","jre", r4k_cc_table[y-4], handle_rel16(state,opbuf1,sizeof(opbuf1)));
                                    } else if ( y > 3 && z == 4 && israbbit4k() ) {
                                        BUF_PRINTF("%-10s%s,hl","flag", r4k_cc_table[y-4]);
                                    } else if ( q == 0 && y == 6 && z == 1  &&  israbbit4k() ) {
                                        BUF_PRINTF("%-10s%s", "setsysp", handle_immed16(state,opbuf1,sizeof(opbuf1)));
                                    } else if ( q == 0 && p >= 2 && z == 5 && israbbit4k() ) {
                                        BUF_PRINTF("%-10s%s", p == 2 ? "push" : "setusrp", handle_immed16(state,opbuf1,sizeof(opbuf1)));
                                    } else if ( (israbbit3k()||israbbit4k()) && z == 0 && (y == 2 || y == 3)) {
                                        if ( y == 2 ) BUF_PRINTF("ldisr");
                                        else if ( y == 3 ) BUF_PRINTF("lddsr");
                                    } else if ( ((isez80() && z <= 4) || z <= 3) && y >= 4 ) {
                                        BUF_PRINTF("%s", handle_ez80_am(state, handle_block_instruction(state, z, y)));
                                    } else if ( iskc160()) {
                                        // KC160, 0x80 - 0xbf page
                                        if ( q == 0 && z >=4 && z < 7 ) BUF_PRINTF("%-10s(%s%s),%s","ld",kc160_handle_register_rel(state, z - 4),handle_displacement(state, opbuf1, sizeof(opbuf1)), handle_register16(state, p, 0));
                                        else if ( q == 1 && z >=4 && z < 7 ) BUF_PRINTF("%-10s%s,(%s%s)","ld", handle_register16(state, p, 0), kc160_handle_register_rel(state, z - 4),handle_displacement(state, opbuf1, sizeof(opbuf1)));
                                        else if ( q == 0 && z < 3 ) BUF_PRINTF("%-10s(%s%s),%s","ld",kc160_handle_register_rel(state, z),handle_displacement(state, opbuf1, sizeof(opbuf1)), p == 0 ? "ix" : "iy");
                                        else if ( q == 1 && z < 3 ) BUF_PRINTF("%-10s%s,(%s%s)","ld", p == 0 ? "ix" : "iy", kc160_handle_register_rel(state, z),handle_displacement(state, opbuf1, sizeof(opbuf1)));
                                        else if ( q == 0 && z == 7 ) BUF_PRINTF("%-10s(%s),%s","ldf", handle_addr24(state, opbuf1, sizeof(opbuf1)),handle_register16(state, p, 0) );
                                        else if ( q == 1 && z == 7 ) BUF_PRINTF("%-10s%s,(%s)","ldf", handle_register16(state, p, 0),handle_addr24(state, opbuf1, sizeof(opbuf1)) );
                                        else if ( q == 0 && z == 3 ) BUF_PRINTF("%-10s(%s),%s","ldf", handle_addr24(state, opbuf1, sizeof(opbuf1)), p == 0 ? "ix" : "iy");
                                        else if ( q == 1 && z == 3 ) BUF_PRINTF("%-10s%s,(%s)","ldf", p == 0 ? "ix" : "iy", handle_addr24(state, opbuf1, sizeof(opbuf1)));
                                    } else if ( isz80n() ) {
                                        if ( b == 0x8a ) BUF_PRINTF("push    %s", handle_immed16_be(state, opbuf1, sizeof(opbuf1)));
                                        else if ( b == 0x90 ) BUF_PRINTF("outinb  ");
                                        else if ( b == 0x91 ) {
                                            // Ensure nextreg regNum,value immediates are processed in the correct order
                                            handle_immed8(state, opbuf1, sizeof(opbuf1));
                                            handle_immed8(state, opbuf2, sizeof(opbuf2));
                                            BUF_PRINTF("nextreg %s,%s",opbuf1, opbuf2);
                                        } else if ( b == 0x92 ) BUF_PRINTF("nextreg %s,a",handle_immed8(state, opbuf1, sizeof(opbuf1)));
                                        else if ( b == 0x93 ) BUF_PRINTF("pixeldn");
                                        else if ( b == 0x94 ) BUF_PRINTF("pixelad");
                                        else if ( b == 0x95 ) BUF_PRINTF("setae");
                                        else if ( b == 0x98 ) BUF_PRINTF("jp        (c)");
                                        else if ( b == 0x98 ) BUF_PRINTF("setae");
                                        else if ( b == 0xa4 ) BUF_PRINTF("ldix");
                                        else if ( b == 0xa5 ) BUF_PRINTF("ldws");
                                        else if ( b == 0xac ) BUF_PRINTF("lddx");
                                        else if ( b == 0xb4 ) BUF_PRINTF("ldirx");
                                        else if ( b == 0xb7 ) BUF_PRINTF("ldpirx");
                                        else if ( b == 0xbc ) BUF_PRINTF("lddrx");
                                        else BUF_PRINTF("nop");
                                    } else {
                                        BUF_PRINTF("nop");
                                    }
                                    break;
                                } else if ( x == 3 ) {
                                    if ( z == 0 && (israbbit3k()||israbbit4k()) ) {
                                        char *r3k_instrs[] = { "uma", "ums", "lsidr", "lsddr", "nop", "nop", "lsir", "lsdr"};
                                        BUF_PRINTF("%s",r3k_instrs[y]);
                                    } else if ( z == 1 && q == 0 && israbbit4k() ) {
                                        BUF_PRINTF("%-10s%s","pop", r4k_ps_table[p]);
                                    } else if ( z == 1 && y != 6 && isr800() ) {
                                        BUF_PRINTF("%-10sa,%s","mulub", handle_register8(state, y, opbuf1, sizeof(opbuf1)));
                                    } else if ( z == 2 && y < 4 && israbbit4k() ) {
                                        handle_addr16(state, opbuf1, sizeof(opbuf1));
                                        handle_immed16(state, opbuf2, sizeof(opbuf2));
                                        BUF_PRINTF("%-10s%s,%s,%s","lljp", rabbit_cc_table[y], opbuf2, opbuf1);
                                    } else if ( z == 3 && y < 4 && israbbit4k() ) {
                                        BUF_PRINTF("%-10s%s,%s","jre", rabbit_cc_table[y], handle_rel16(state,opbuf1,sizeof(opbuf1)));
                                    } else if ( z == 3 && isr800() ) {
                                        BUF_PRINTF("%-10shl,%s","muluw", handle_register16(state, p, state->index));
                                    } else if ( z == 4 && y < 4 && israbbit4k() ) {
                                        BUF_PRINTF("%-10s%s,hl","flag", rabbit_cc_table[y]);
                                    } else if ( z == 5 && q == 0 && israbbit4k() ) {
                                        BUF_PRINTF("%-10s%s","push", r4k_ps_table[p]);
                                    } else if ( z == 6 && q == 0 && israbbit4k() ) {
                                        char *ops[] = { "add", "sub", "and", "or" };
                                        BUF_PRINTF("%-10sjkhl,bcde", ops[p]);
                                    } else if ( ( y <= 1 ) && (z == 2 || z == 3 ) && isez80() ) {
                                        char *instrs[2][2] = { { "inirx", "otirx" }, { "indrx", "otdrx"} };
                                        BUF_PRINTF("%s",handle_ez80_am(state,instrs[y][z-2]));
                                    } else if ( z == 7 && y <= 2 &&  isez80() ) {
                                        char *instrs[] = { "ld        i,hl", "nop", "ld        hl,i"};
                                        BUF_PRINTF("%s",instrs[y]);
                                    } else if ( iskc160() && y >= 4 && z < 4) BUF_PRINTF("%-10s%s", handle_ez80_am(state, handle_block_instruction(state, z, y)), z == 0 ? "xy" : "x");                       
                                    else if( iskc160() && z == 2 ) BUF_PRINTF("%-10s%s,%s", "jp3", cc_table[y], handle_addr24(state,opbuf1,sizeof(opbuf1)));
                                    else if ( iskc160() && b == 0xc3 ) BUF_PRINTF("%-10s%s", "jp3", handle_addr24(state,opbuf1,sizeof(opbuf1)));
                                    else if ( iskc160() && q == 0 && z == 4 ) BUF_PRINTF("%-10s%s,%s","ld", kc160_p_table[p], kc160_p_table[3-p]);
                                    else if ( iskc160() && q == 0 && z == 5 ) BUF_PRINTF("%-10s%s,%s","ld", kc160_p_table[p], kc160_p_table[(3-p+2)%4]);
                                    else if ( iskc160() && q == 1 && z == 4 ) BUF_PRINTF("%-10s%s,%s","ld", kc160_p_table[p], kc160_p_table[(p+2)%4]);
                                    else if ( q == 1 && z == 1 && y == 3 && israbbit4k()) BUF_PRINTF("%-10s","exp");
                                    else if ( q == 1 && z == 2 && y == 5 && israbbit4k()) BUF_PRINTF("%-10s(hl)","call");
                                    else if ( q == 1 && z == 2 && y == 7 && israbbit4k()) BUF_PRINTF("%-10s(jkhl)","llcall");
                                    else if ( q == 1 && z == 6 && y == 5 && israbbit4k()) BUF_PRINTF("%-10sjkhl,bcde","xor");
                                    else if ( q == 1 && z == 6 && y == 7 && israbbit4k()) BUF_PRINTF("%-10shl,(sp+hl)","ld");
                                    else if ( b == 0xfe ) BUF_PRINTF("trap");
                                    else BUF_PRINTF("nop");
                                }
                            } else if ( p == 3 && canindex()  ) { state->index = 2; continue; }
                            else if ( p == 3 && is8085() ) BUF_PRINTF("%-10sk,%s", "jp",handle_addr16(state, opbuf1, sizeof(opbuf1)));
                            else BUF_PRINTF("nop");                            
                        }
                    } else if ( z == 6 ) {
                        if ( q == 1 && state->index && israbbit4k() ) {
                            if ( p == 0 ) BUF_PRINTF("%-10s%s,(ix%s)", "ld", r4k_32b_table[state->index-1], handle_displacement(state,opbuf1,sizeof(opbuf1)));
                            else if ( p == 1 ) BUF_PRINTF("%-10s%s,(iy%s)", "ld", r4k_32b_table[state->index-1], handle_displacement(state,opbuf1,sizeof(opbuf1)));
                            else if ( p == 2 ) BUF_PRINTF("%-10s%s,(sp+%s)", "ld", r4k_32b_table[state->index-1], handle_immed8(state,opbuf1,sizeof(opbuf1)));
                            else if ( p == 3 ) BUF_PRINTF("%-10s%s,(sp+hl)", "ld", r4k_32b_table[state->index-1]);
                        } else  BUF_PRINTF("%-10s%s", alu_table[y], handle_immed8(state, opbuf1, sizeof(opbuf1)));                    
                    } else if ( z == 7 ) {
                        if ( q == 1 && state->index && israbbit4k() ) {
                            if ( p == 0 ) BUF_PRINTF("%-10s(ix%s),%s", "ld", handle_displacement(state,opbuf1,sizeof(opbuf1)), r4k_32b_table[state->index-1]);
                            else if ( p == 1 ) BUF_PRINTF("%-10s(iy%s),%s", "ld", handle_displacement(state,opbuf1,sizeof(opbuf1)),r4k_32b_table[state->index-1]);
                            else if ( p == 2 ) BUF_PRINTF("%-10s(sp+%s),%s", "ld", handle_immed8(state,opbuf1,sizeof(opbuf1)),r4k_32b_table[state->index-1]);
                            else if ( p == 3 ) BUF_PRINTF("%-10s(sp+hl),%s", "ld", r4k_32b_table[state->index-1]);
                        } else if ( israbbit() && y == 0 ) { handle_immed16(state, opbuf1, sizeof(opbuf1)); handle_immed8(state, opbuf2, sizeof(opbuf2)); BUF_PRINTF("%-10s%s,%s","ljp", opbuf2, opbuf1); }
                        else if ( israbbit() && y == 1 ) { handle_immed16(state, opbuf1, sizeof(opbuf1)); handle_immed8(state, opbuf2, sizeof(opbuf2)); BUF_PRINTF("%-10s%s,%s","lcall", opbuf2, opbuf1); }
                        else if ( israbbit() && y == 6 ) BUF_PRINTF("mul");
                        else BUF_PRINTF("%-10s$%02x", handle_ez80_am(state,"rst"), y * 8);
                    }
                    break;
            }
            break;
        } while (1);
    }

    if (compact <= 1) {
        while ( offs < 60 ) {
            buf[offs++] = ' ';
            buf[offs] = 0;
        }

        offs += snprintf(buf + offs, buflen - offs, ";[%04x] ", start_pc & 0xffff);
    } else {
        offs += snprintf(buf + offs, buflen - offs, ";");
    }

    for ( i = state->skip; i < state->len; i++ ) {
        offs += snprintf(buf + offs, buflen - offs,"%s%02x", i ? " " : "", state->instr_bytes[i]);
    }
    if (compact <= 1) {
        if ( dolf ) {
            offs += snprintf(buf + offs, buflen - offs,"\n");
        }
    }

    return state->len;
}
