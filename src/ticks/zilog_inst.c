

// Lengthy Zilog instructions
#include "ticks.h"


// Note 8080 has a different implementation which we don't cover
void zilog_daa(uint8_t opcode)
{
    uint16_t t, u;

    st+= isez80() ? 1 : isr800() ? 1 : iskc160() ? 1 : 4;
    t= (fr^fa^fb^fb>>8) & 16;  // H flag
    u= 0;		// incr
    if ( isz180() ) {
    if ( t || (!(fb&512) && (a&0x0f) > 0x9) )
        u |= 6;
    if ( (ff & 256) || (!(fb&512) && a > 0x99) )
        u |= 0x160;
    } else {
    (a |ff&256)>0x99 && (u= 0x160);
    (a&15 | t)>9 && (u+= 6);
    }
    fa= a|256;
    if( fb&512) // N (subtract) flag set
    a-= u,
    fb= ~u;
    else
    a+= fb= u;
    ff= (fr= a)
    | u&256;
}

void zilog_rld(uint8_t opcode)
{
    uint16_t t;

    st+= isr800() ? 5 : iskc160() ? 7 : 18;
    t= get_memory_data(mp= l|h<<8)<<4
    | (a&15);
    a= (a &240)
    | t>>8;
    ff=  ff&-256
    | (fr= a);
    fa= a|256;
    fb= 0;
    put_memory(mp++,t);
}


void zilog_rrd(uint8_t opcode)
{
    uint16_t t;
    st+= isr800() ? 5 : iskc160() ? 7 : 18;
    t= get_memory_data(mp= l|h<<8)
    | a<<8;
    a= (a &240)
    | (t & 15);
    ff=  ff&-256
    | (fr= a);
    fa= a|256;
    fb= 0;
    put_memory(mp++,t>>4); 
}


void zilog_cpi(uint8_t opcode)
{
    uint8_t w;
    uint16_t t;

    st+=  isr800() ? 4 : 16;
    w= a-(t= get_memory_data(l|h<<8));
    ++l || h++;
    c-- || b--;
    ++mp;
    fr=  w & 127
    | w>>7;
    fb= ~(t|128);
    fa= a&127;
    b|c && ( fa|= 128,
            fb|= 128);
    ff=  ff  & -256
        | w   &  -41;
    (w^t^a) & 16 && w--;
    ff|= w<<4 & 32
        | w    &  8; 
}

void zilog_cpd(uint8_t opcode)
{
    uint8_t w;
    uint16_t t;

    st+=  isr800() ? 4 : 16;
    w= a-(t= get_memory_data(l|h<<8));
    l-- || h--;
    c-- || b--;
    --mp;
    fr=  w & 127
    | w>>7;
    fb= ~(t|128);
    fa= a&127;
    b|c && ( fa|= 128,
            fb|= 128);
    ff=  ff  & -256
        | w   &  -41;
    (w^t^a) & 16 && w--;
    ff|= w<<4 & 32
        | w    &  8; 
}

void zilog_cpir(uint8_t opcode)
{
    uint8_t w;
    uint16_t t;

    st+=  isr800() ? 4 : 16; 
    w= a-(t= get_memory_data(l|h<<8));
    ++l || h++;
    c-- || b--;
    ++mp;
    fr=  w & 127
        | w>>7;
    fb= ~(t|128);
    fa= a&127;
    b|c && ( fa|= 128,
        fb|= 128,
        w && (st+= 5, mp=--pc, --pc));
    ff=  ff  & -256
        | w   &  -41;
    (w^t^a) & 16 && w--;
    ff|= w<<4 & 32
        | w    &  8; 
}


void zilog_cpdr(uint8_t opcode)
{
    uint8_t w;
    uint16_t t;

    st+=  isr800() ? 4 : 16;
    w= a-(t= get_memory_data(l|h<<8));
    l-- || h--;
    c-- || b--;
    --mp;
    fr=  w & 127
        | w>>7;
    fb= ~(t|128);
    fa= a&127;
    b|c && ( fa|= 128,
            fb|= 128,
            w && (st+= 5, mp=--pc, --pc));
    ff=  ff  & -256
        | w   &  -41;
    (w^t^a) & 16 && w--;
    ff|= w<<4 & 32
        | w    &  8; 
}

void zilog_ini(uint8_t opcode)
{
    uint16_t t,u;
    st+=  isr800() ? 4 : 16;

    put_memory(l | h<<8,t= in(mp= c | b<<8));
    ++l || h++;
    ++mp;
    u= t+(c+1&255);
    --b;
    fb= u&7^b;
    ff= b | (u&= 256);
    fa= (fr= b)^128;
    fb=  (4928640>>((fb^fb>>4)&15)^b)&128
        | u>>4
        | (t&128)<<2;
}

void zilog_ind(uint8_t opcode)
{
    uint16_t t,u;

    st+=  isr800() ? 4 : 16;
    put_memory(l | h<<8, t= in(mp= c | b<<8));
    l-- || h--;
    --mp;
    u= t+(c-1&255);
    --b;
    fb= u&7^b;
    ff= b | (u&= 256);
    fa= (fr= b)^128;
    fb=  (4928640>>((fb^fb>>4)&15)^b)&128
        | u>>4
        | (t&128)<<2; 
}

void zilog_inir(uint8_t opcode)
{
    uint16_t t,u;

    st+=  isr800() ? 4 : 16;
    put_memory(l | h<<8, t= in(mp= c | b<<8));
    ++l || h++;
    ++mp;
    u= t+(c+1&255);
    --b && (st+= 5, mp= --pc, --pc);
    fb= u&7^b;
    ff= b | (u&= 256);
    fa= (fr= b)^128;
    fb=  (4928640>>((fb^fb>>4)&15)^b)&128
        | u>>4
        | (t&128)<<2;
}

void zilog_indr(uint8_t opcode)
{
    uint16_t t,u;
    
    st+=  isr800() ? 4 : 16;
    put_memory(l | h<<8, t= in(mp= c | b<<8));
    l-- || h--;
    --mp;
    u= t+(c-1&255);
    --b && (st+= 5, mp= --pc, --pc);
    fb= u&7^b;
    ff= b | (u&= 256);
    fa= (fr= b)^128;
    fb=  (4928640>>((fb^fb>>4)&15)^b)&128
        | u>>4
        | (t&128)<<2;
}

void zilog_outi(uint8_t opcode)
{
    uint16_t t,u;

    st+=  isr800() ? 4 : 16;
    --b;
    out( mp= c | b<<8,
        t = get_memory_data(l | h<<8));
    ++mp;
    ++l || h++;
    u= t+l;
    fb= u&7^b;
    ff= b | (u&= 256);
    fa= (fr= b)^128;
    fb=  (4928640>>((fb^fb>>4)&15)^b)&128
        | u>>4
        | (t&128)<<2;
}


void zilog_outd(uint8_t opcode)
{
    uint16_t t,u;

    st+=  isr800() ? 4 : 16;
    --b;
    out( mp= c | b<<8,
        t = get_memory_data(l | h<<8));
    --mp;
    l-- || h--;
    u= t+l;
    fb= u&7^b;
    ff= b | (u&= 256);
    fa= (fr= b)^128;
    fb=  (4928640>>((fb^fb>>4)&15)^b)&128
        | u>>4
        | (t&128)<<2;
}

void zilog_otir(uint8_t opcode)
{
    uint16_t t,u;

    st+=  isr800() ? 4 : 16;                                // OTIR
    --b;
    out( mp= c | b<<8,
        t = get_memory_data(l | h<<8));
    ++mp;
    ++l || h++;
    u= t+l;
    b && (st+= 5, mp= --pc, --pc);
    fb= u&7^b;
    ff= b | (u&= 256);
    fa= (fr= b)^128;
    fb=  (4928640>>((fb^fb>>4)&15)^b)&128
        | u>>4
        | (t&128)<<2;
}


void zilog_otdr(uint8_t opcode)
{
    uint16_t t,u;

    st+=  isr800() ? 4 : 16;
    --b;
    out( mp= c | b<<8,
        t = get_memory_data(l | h<<8));
    --mp;
    l-- || h--;
    u= t+l;
    b && (st+= 5, mp= --pc, --pc);
    fb= u&7^b;
    ff= b | (u&= 256);
    fa= (fr= b)^128;
    fb=  (4928640>>((fb^fb>>4)&15)^b)&128
        | u>>4
        | (t&128)<<2;
}


