#!/usr/bin/env perl

# dump a .P file

use Modern::Perl;
use Path::Tiny;
use Data::HexDump;

my %sysvars = (
    ERR_NO     => 0x4000,
    FLAGS      => 0x4001,
    ERR_SP     => 0x4002,
    RAMTOP     => 0x4004,
    MODE       => 0x4006,
    PPC        => 0x4007,
    VERSN      => 0x4009,
    E_PPC      => 0x400a,
    D_FILE     => 0x400c,
    DF_CC      => 0x400e,
    VARS       => 0x4010,
    DEST       => 0x4012,
    E_LINE     => 0x4014,
    CH_ADD     => 0x4016,
    X_PTR      => 0x4018,
    STKBOT     => 0x401a,
    STKEND     => 0x401c,
    BREG       => 0x401e,
    MEM        => 0x401f,
    FREE1      => 0x4021,
    DF_SZ      => 0x4022,
    S_TOP      => 0x4023,
    LAST_K     => 0x4025,
    DEBOUNCE   => 0x4027,
    MARGIN     => 0x4028,
    NXTLIN     => 0x4029,
    OLDPPC     => 0x402b,
    FLAGX      => 0x402d,
    STRLEN     => 0x402e,
    T_ADDR     => 0x4030,
    SEED       => 0x4032,
    FRAMES     => 0x4034,
    COORDS_X   => 0x4036,
    COORDS_Y   => 0x4037,
    PR_CC      => 0x4038,
    S_POSN_COL => 0x4039,
    S_POSN_ROW => 0x403a,
    CDFLAG     => 0x403b,
    PRBUFF     => 0x403c,
    MEMBOT     => 0x405d,
    FREE2      => 0x407b,
    PROG       => 0x407d,
);

my %zx81chars = (
    0x00 => 'CH_SPACE',
    0x0b => 'CH_QUOTE',
    0x0c => 'CH_POUND',
    0x0d => 'CH_DOLLAR',
    0x0e => 'CH_COLON',
    0x0f => 'CH_QUESTION',
    0x10 => 'CH_OPEN_PAREN',
    0x11 => 'CH_CLOSE_PAREN',
    0x12 => 'CH_GREATER_THAN',
    0x13 => 'CH_LESS_THAN',
    0x14 => 'CH_EQUAL',
    0x15 => 'CH_PLUS',
    0x16 => 'CH_MINUS',
    0x17 => 'CH_MULTIPLY',
    0x18 => 'CH_DIVIDE',
    0x19 => 'CH_SEMICOLON',
    0x1a => 'CH_COMMA',
    0x1b => 'CH_DOT',
    0x1c => 'CH_0',
    0x1d => 'CH_1',
    0x1e => 'CH_2',
    0x1f => 'CH_3',
    0x20 => 'CH_4',
    0x21 => 'CH_5',
    0x22 => 'CH_6',
    0x23 => 'CH_7',
    0x24 => 'CH_8',
    0x25 => 'CH_9',
    0x26 => 'CH_A',
    0x27 => 'CH_B',
    0x28 => 'CH_C',
    0x29 => 'CH_D',
    0x2a => 'CH_E',
    0x2b => 'CH_F',
    0x2c => 'CH_G',
    0x2d => 'CH_H',
    0x2e => 'CH_I',
    0x2f => 'CH_J',
    0x30 => 'CH_K',
    0x31 => 'CH_L',
    0x32 => 'CH_M',
    0x33 => 'CH_N',
    0x34 => 'CH_O',
    0x35 => 'CH_P',
    0x36 => 'CH_Q',
    0x37 => 'CH_R',
    0x38 => 'CH_S',
    0x39 => 'CH_T',
    0x3a => 'CH_U',
    0x3b => 'CH_V',
    0x3c => 'CH_W',
    0x3d => 'CH_X',
    0x3e => 'CH_Y',
    0x3f => 'CH_Z',
    0x40 => 'CH_RND',
    0x41 => 'CH_INKEY_DOLLAR',
    0x42 => 'CH_PI',
    0x76 => 'CH_NEWLINE',
    0x7e => 'CH_NUMBER',
    0x80 => 'CH_INV_SPACE',
    0x8b => 'CH_INV_QUOTE',
    0x8c => 'CH_INV_POUND',
    0x8d => 'CH_INV__DOLLAR',
    0x8e => 'CH_INV_COLON',
    0x8f => 'CH_INV_QUESTION',
    0x90 => 'CH_INV_OPEN_PAREN',
    0x91 => 'CH_INV_CLOSE_PAREN',
    0x92 => 'CH_INV_GREATER_THAN',
    0x93 => 'CH_INV_LESS_THAN',
    0x94 => 'CH_INV_EQUAL',
    0x95 => 'CH_INV_PLUS',
    0x96 => 'CH_INV_MINUS',
    0x97 => 'CH_INV_MULTIPLY',
    0x98 => 'CH_INV_DIVIDE',
    0x99 => 'CH_INV_SEMICOLON',
    0x9a => 'CH_INV_COMMA',
    0x9b => 'CH_INV_DOT',
    0x9c => 'CH_INV_0',
    0x9d => 'CH_INV_1',
    0x9e => 'CH_INV_2',
    0x9f => 'CH_INV_3',
    0xa0 => 'CH_INV_4',
    0xa1 => 'CH_INV_5',
    0xa2 => 'CH_INV_6',
    0xa3 => 'CH_INV_7',
    0xa4 => 'CH_INV_8',
    0xa5 => 'CH_INV_9',
    0xa6 => 'CH_INV_A',
    0xa7 => 'CH_INV_B',
    0xa8 => 'CH_INV_C',
    0xa9 => 'CH_INV_D',
    0xaa => 'CH_INV_E',
    0xab => 'CH_INV_F',
    0xac => 'CH_INV_G',
    0xad => 'CH_INV_H',
    0xae => 'CH_INV_I',
    0xaf => 'CH_INV_J',
    0xb0 => 'CH_INV_K',
    0xb1 => 'CH_INV_L',
    0xb2 => 'CH_INV_M',
    0xb3 => 'CH_INV_N',
    0xb4 => 'CH_INV_O',
    0xb5 => 'CH_INV_P',
    0xb6 => 'CH_INV_Q',
    0xb7 => 'CH_INV_R',
    0xb8 => 'CH_INV_S',
    0xb9 => 'CH_INV_T',
    0xba => 'CH_INV_U',
    0xbb => 'CH_INV_V',
    0xbc => 'CH_INV_W',
    0xbd => 'CH_INV_X',
    0xbe => 'CH_INV_Y',
    0xbf => 'CH_INV_Z',
    0xc0 => 'CH_DOUBLE_QUOTE',
    0xc1 => 'CH_AT',
    0xc2 => 'CH_TAB',
    0xc4 => 'CH_CODE',
    0xc5 => 'CH_VAL',
    0xc6 => 'CH_LEN',
    0xc7 => 'CH_SIN',
    0xc8 => 'CH_COS',
    0xc9 => 'CH_TAN',
    0xca => 'CH_ASN',
    0xcb => 'CH_ACS',
    0xcc => 'CH_ATN',
    0xcd => 'CH_LN',
    0xce => 'CH_EXP',
    0xcf => 'CH_INT',
    0xd0 => 'CH_SQR',
    0xd1 => 'CH_SGN',
    0xd2 => 'CH_ABS',
    0xd3 => 'CH_PEEK',
    0xd4 => 'CH_USR',
    0xd5 => 'CH_STR_DOLLAR',
    0xd6 => 'CH_CHR_DOLLAR',
    0xd7 => 'CH_NOT',
    0xd8 => 'CH_POWER',
    0xd9 => 'CH_OR',
    0xda => 'CH_AND',
    0xdb => 'CH_LESS_EQUAL',
    0xdc => 'CH_GREATER_EQUAL',
    0xdd => 'CH_NOT_EQUAL',
    0xde => 'CH_THEN',
    0xdf => 'CH_TO',
    0xe0 => 'CH_STEP',
    0xe1 => 'CH_LPRINT',
    0xe2 => 'CH_LLIST',
    0xe3 => 'CH_STOP',
    0xe4 => 'CH_SLOW',
    0xe5 => 'CH_FAST',
    0xe6 => 'CH_NEW',
    0xe7 => 'CH_SCROLL',
    0xe8 => 'CH_CONT',
    0xe9 => 'CH_DIM',
    0xea => 'CH_REM',
    0xeb => 'CH_FOR',
    0xec => 'CH_GOTO',
    0xed => 'CH_GOSUB',
    0xee => 'CH_INPUT',
    0xef => 'CH_LOAD',
    0xf0 => 'CH_LIST',
    0xf1 => 'CH_LET',
    0xf2 => 'CH_PAUSE',
    0xf3 => 'CH_NEXT',
    0xf4 => 'CH_POKE',
    0xf5 => 'CH_PRINT',
    0xf6 => 'CH_PLOT',
    0xf7 => 'CH_RUN',
    0xf8 => 'CH_SAVE',
    0xf9 => 'CH_RAND',
    0xfa => 'CH_IF',
    0xfb => 'CH_CLS',
    0xfc => 'CH_UNPLOT',
    0xfd => 'CH_CLEAR',
    0xfe => 'CH_RETURN',
    0xff => 'CH_COPY',
);

# main
@ARGV == 1 or die "Usage: $0 file.p\n";
my $input_p = shift;

# load memory
my @mem = ( map { ord } split //, path($input_p)->slurp_raw );

# labels
my %labels;
while ( my ( $name, $addr ) = each %sysvars ) {
    $labels{$addr}{$name} = 1;
}
$labels{0x407D}{PROG} = 1;

# pointers
my %pointers;
for my $var (
    qw( E_PPC D_FILE DF_CC VARS DEST E_LINE
    CH_ADD X_PTR STKBOT STKEND MEM S_TOP
    NXTLIN )
    )
{
    my $addr = $sysvars{$var};
    $pointers{$addr} = 1;
    my $pointed_addr =
        $mem[ $addr - 0x4009 ] | ( $mem[ $addr + 1 - 0x4009 ] << 8 );
    $labels{$pointed_addr}{ $var . "_ADDR" } = 1;
}
for my $var (qw( LAST_K OLDPPC STRLEN T_ADDR SEED FRAMES )) {
    my $addr = $sysvars{$var};
    $pointers{$addr} = 1;
}

# dump
for ( my $i = 0 ; $i < @mem ; $i++ ) {
    my $addr  = 0x4009 + $i;
    my $size  = exists $pointers{$addr} ? 2 : 1;
    my $value = $size == 1 ? $mem[$i] : $mem[$i] | ( $mem[ $i + 1 ] << 8 );
    my @addr_labels = sort keys %{ $labels{$addr} || {} };
    my $addr_labels = join( ",", @addr_labels );

    printf "%04X  ", $addr;
    if ( $size == 1 ) {
        printf "  %02X  ", $value;
    }
    else {
        printf "%04X  ", $value;
    }
    printf "%-32s  ", $addr_labels                        || "";
    printf "%-16s  ", $size == 1 ? $zx81chars{ $mem[$i] } || "" : "";
    print "\n";

    $i += $size - 1;
}
