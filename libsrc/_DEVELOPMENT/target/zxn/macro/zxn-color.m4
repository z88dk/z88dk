pushdef(`Z88DK_DIVNUM', divnum)
divert(-1)

# Local Macros

pushdef(`M4_AND_LSHIFT', `eval((($1)&($2))<<($3))')
pushdef(`M4_RSHIFT_AND', `eval((($1)>>($2))&($3))')

pushdef(`M4_CLAMP', `ifelse(eval(($1)>($2)),1,$2,$1)')
pushdef(`M4_CLAMP2', `M4_CLAMP($1,0x3)')
pushdef(`M4_CLAMP3', `M4_CLAMP($1,0x7)')
pushdef(`M4_CLAMP8', `M4_CLAMP($1,0xff)')

pushdef(`M4_ROUND8', `M4_CLAMP8(eval(($1)+($2)))')
pushdef(`M4_ROUNDP', `eval((($1)*($2)+50)/100)')

# Macros for Defining Colour

# Generated Colours:
#
#   RGB332_FROM_*   = generates eight-bit RGB332 colour for the zx next
#   RGB333_FROM_*   = generates nine-bit RGB333 colour for the zx next

# Source Colours:
#
#   *_FROM_RGB332   = source colour is an eight-bit RGB332 colour
#   *_FROM_RGB332C  = source colour is three components in order 3-bit red, 3-bit green, 2-bit blue
#   *_FROM_RGB333   = source colour is a nine-bit RGB333 colour
#   *_FROM_RGB333C  = source colour is three components in order 3-bit red, 3-bit green, 3-bit blue
#   *_FROM_ULAP     = source colour is a ula+ colour (GRB332)
#   *_FROM_GRB332   = source colour is an eight-bit GRB332 colour
#   *_FROM_GRB332C  = source colour is three components in order 3-bit green, 3-bit red, 2-bit blue
#   *_FROM_BGR233   = source colour is an eight-bit BGR233 colour
#   *_FROM_BGR233C  = source colour is three components in order 2-bit blue, 3-bit green, 3-bit red
#   *_FROM_RGB888   = source colour is a 24-bit RGB888 colour (conversion will round to the nearest)
#   *_FROM_RGB888C  = source colour is three components in order 8-bit red, 8-bit green, 8-bit blue (conversion will round to nearest)
#   *_FROM_RGB888T  = source colour is a 24-bit RGB888 colour (conversion will truncate)
#   *_FROM_RGB888TC = source colour is three components in order 8-bit red, 8-bit green, 8-bit blue (conversion will truncate)
#   *_FROM_RGBPPPC  = source colour is three components as percentage in order 0-100 red, 0-100 green, 0-100 blue (conversion will round to nearest)
#   *_FROM_RGBPPPTC = source colour is three components as percentage in order 0-100 red, 0-100 green, 0-100 blue (conversion will truncate)

pushdef(`RGB332_FROM_RGB332C', `0x`'eval(M4_AND_LSHIFT($1,0x7,5)+M4_AND_LSHIFT($2,0x7,2)+(($3)&0x3),16,2)')
pushdef(`RGB332_FROM_RGB333', `0x`'eval(M4_RSHIFT_AND($1,1,0xff),16,2)')
pushdef(`RGB332_FROM_RGB333C', `0x`'eval(M4_AND_LSHIFT($1,0x7,5)+M4_AND_LSHIFT($2,0x7,2)+M4_RSHIFT_AND($3,1,0x3),16,2)')
pushdef(`RGB332_FROM_RGB888', `0x`'eval(((M4_ROUND8(M4_RSHIFT_AND($1,16,0xff),0x10))&0xe0)+M4_RSHIFT_AND(M4_ROUND8(M4_RSHIFT_AND($1,8,0xff),0x10),3,0x1c)+M4_RSHIFT_AND(M4_ROUND8(eval(($1)&0xff),0x20),6,0x3),16,2)')
pushdef(`RGB332_FROM_RGB888C', `0x`'eval(((M4_ROUND8(eval(($1)&0xff),0x10))&0xe0)+M4_RSHIFT_AND(M4_ROUND8(eval(($2)&0xff),0x10),3,0x1c)+M4_RSHIFT_AND(M4_ROUND8(eval(($3)&0xff),0x20),6,0x3),16,2)')
pushdef(`RGB332_FROM_RGB888T', `0x`'eval(M4_RSHIFT_AND($1,16,0xe0)+M4_RSHIFT_AND($1,11,0x1c)+M4_RSHIFT_AND($1,6,0x3),16,2)')
pushdef(`RGB332_FROM_RGB888TC', `0x`'eval((($1)&0xe0)+M4_RSHIFT_AND($2,3,0x1c)+M4_RSHIFT_AND($3,6,0x3),16,2)')
pushdef(`RGB332_FROM_ULAP', `0x`'eval(M4_RSHIFT_AND($1,3,0x1c)+M4_AND_LSHIFT($1,0x1c,3)+(($1)&0x3),16,2)')
pushdef(`RGB332_FROM_GRB332', `RGB332_FROM_ULAP($1)')
pushdef(`RGB332_FROM_GRB332C', `0x`'eval(M4_AND_LSHIFT($1,0x7,2)+M4_AND_LSHIFT($2,0x7,5)+(($3)&0x3),16,2)')
pushdef(`RGB332_FROM_BGR233', `0x`'eval(M4_RSHIFT_AND($1,6,0x3)+M4_RSHIFT_AND($1,1,0x1c)+M4_AND_LSHIFT($1,0x7,5),16,2)')
pushdef(`RGB332_FROM_BGR233C', `0x`'eval((($1)&0x3)+M4_AND_LSHIFT($2,0x7,2)+M4_AND_LSHIFT($3,0x7,5),16,2)')
pushdef(`RGB332_FROM_RGBPPPC', `0x`'eval((M4_ROUNDP($1,0x7)<<5)+(M4_ROUNDP($2,0x7)<<2)+M4_ROUNDP($3,0x3),16,2)')

pushdef(`RGB333_FROM_RGB332', `0x`'eval(M4_AND_LSHIFT($1,0xe0,1)+M4_AND_LSHIFT($1,0x1c,1)+((($1)&0x3)<<1)+(($1)&0x1),16,3)')
pushdef(`RGB333_FROM_RGB332C', `0x`'eval(M4_AND_LSHIFT($1,0x7,6)+M4_AND_LSHIFT($2,0x7,3)+((($3)&0x3)<<1)+(($3)&0x1),16,3)')
pushdef(`RGB333_FROM_RGB333C', `0x`'eval(M4_AND_LSHIFT($1,0x7,6)+M4_AND_LSHIFT($2,0x7,3)+(($3)&0x7),16,3)')
pushdef(`RGB333_FROM_RGB888', `0x`'eval((((M4_ROUND8(M4_RSHIFT_AND($1,16,0xff),0x10))&0xe0)<<1)+M4_RSHIFT_AND(M4_ROUND8(M4_RSHIFT_AND($1,8,0xff),0x10),2,0x38)+M4_RSHIFT_AND(M4_ROUND8(eval(($1)&0xff),0x10),5,0x7),16,3)')
pushdef(`RGB333_FROM_RGB888C', `0x`'eval((((M4_ROUND8(eval(($1)&0xff),0x10))&0xe0)<<1)+M4_RSHIFT_AND(M4_ROUND8(eval(($2)&0xff),0x10),2,0x38)+M4_RSHIFT_AND(M4_ROUND8(eval(($3)&0xff),0x10),5,0x7),16,3)')
pushdef(`RGB333_FROM_RGB888T', `0x`'eval(M4_RSHIFT_AND($1,15,0x1c0)+M4_RSHIFT_AND($1,10,0x38)+M4_RSHIFT_AND($1,5,0x7),16,3)')
pushdef(`RGB333_FROM_RGB888TC', `0x`'eval(((($1)&0xe0)<<1)+M4_RSHIFT_AND($2,2,0x38)+M4_RSHIFT_AND($3,5,0x7),16,2)')
pushdef(`RGB333_FROM_ULAP', `0x`'eval(M4_RSHIFT_AND($1,2,0x38)+M4_AND_LSHIFT($1,0x1c,4)+(($1)&0x1)+((($1)&0x3)<<1),16,3)')
pushdef(`RGB333_FROM_GRB332', `RGB332_FROM_ULAP($1)')
pushdef(`RGB333_FROM_GRB332C', `0x`'eval(M4_AND_LSHIFT($1,0x7,3)+M4_AND_LSHIFT($2,0x7,6)+(($3)&0x1)+((($3)&0x3)<<1),16,3)')
pushdef(`RGB333_FROM_BGR233', `0x`'eval(M4_RSHIFT_AND($1,5,0x6)+((($1)&0x40)==1)+(($1)&0x38)+M4_AND_LSHIFT($1,0x7,6),16,3)')
pushdef(`RGB333_FROM_BGR233C', `0x`'eval(((($1)&0x3)<<1)+(($1)&0x1)+M4_AND_LSHIFT($2,0x7,3)+M4_AND_LSHIFT($3,0x7,6),16,3)')
pushdef(`RGB333_FROM_RGBPPPC', `0x`'eval((M4_ROUNDP($1,0x7)<<6)+(M4_ROUNDP($2,0x7)<<3)+M4_ROUNDP($3,0x7),16,3)')

divert(Z88DK_DIVNUM)
dnl`'popdef(`Z88DK_DIVNUM')
