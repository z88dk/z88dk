#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
# Directives parser input
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

org expr $
	/*set_origin(expr);*/

. ident equ expr $
	/*add_equ();*/

ident : equ expr $
	/*add_equ();*/

ident equ expr $
	/*add_equ();*/
