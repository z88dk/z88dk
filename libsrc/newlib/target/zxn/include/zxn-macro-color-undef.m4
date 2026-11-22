pushdef(`Z88DK_DIVNUM', divnum)
divert(-1)

# Local Macros

popdef(`M4_AND_LSHIFT')
popdef(`M4_RSHIFT_AND')

popdef(`M4_CLAMP')
popdef(`M4_CLAMP2')
popdef(`M4_CLAMP3')
popdef(`M4_CLAMP8')

popdef(`M4_ROUND8')
popdef(`M4_ROUNDP')

# Macros for Defining Colour

popdef(`RGB332_FROM_RGB332C')
popdef(`RGB332_FROM_RGB333')
popdef(`RGB332_FROM_RGB333C')
popdef(`RGB332_FROM_RGB888')
popdef(`RGB332_FROM_RGB888C')
popdef(`RGB332_FROM_RGB888T')
popdef(`RGB332_FROM_RGB888TC')
popdef(`RGB332_FROM_ULAP')
popdef(`RGB332_FROM_GRB332')
popdef(`RGB332_FROM_GRB332C')
popdef(`RGB332_FROM_BGR233')
popdef(`RGB332_FROM_BGR233C')
popdef(`RGB332_FROM_RGBPPPC')

popdef(`RGB333_FROM_RGB332')
popdef(`RGB333_FROM_RGB332C')
popdef(`RGB333_FROM_RGB333C')
popdef(`RGB333_FROM_RGB888')
popdef(`RGB333_FROM_RGB888C')
popdef(`RGB333_FROM_RGB888T')
popdef(`RGB333_FROM_RGB888TC')
popdef(`RGB333_FROM_ULAP')
popdef(`RGB333_FROM_GRB332')
popdef(`RGB333_FROM_GRB332C')
popdef(`RGB333_FROM_BGR233')
popdef(`RGB333_FROM_BGR233C')
popdef(`RGB333_FROM_RGBPPPC')

divert(Z88DK_DIVNUM)
dnl`'popdef(`Z88DK_DIVNUM')
