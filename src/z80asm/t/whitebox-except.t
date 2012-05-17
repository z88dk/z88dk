#!/usr/bin/perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Paulo Custodio, 2011

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/whitebox-except.t,v 1.1 2012-05-17 15:04:47 pauloscustodio Exp $
# $Log: whitebox-except.t,v $
# Revision 1.1  2012-05-17 15:04:47  pauloscustodio
# white box test of new modules
#
# Revision 1.1  2012/04/22 20:32:20  pauloscustodio
# Test new ASMTAIL and ASMSIZE keywords
#
# Test exceptions

use Modern::Perl;
use Test::More;
require 't/test_utils.pl';

my $compile = "-DEXCEPT_DEBUG except.c die.c";

# compile
t_compile_module('', <<'END', $compile);
	int x = 0;

	init_except();
		
	try
	{
		x += 2;
		throw(FatalErrorException, "Error");
		x += 4;
	}
	catch (FatalErrorException)
	{
		x += 8;
	}
	finally 
	{
		x += 16;
	}
	
	x += 32;
	
	if (x != 2+8+16+32)				return 2;
	
	return 0;
END


# run, init not called
t_run_module([], "", <<ERR, 0);
except: init
except: cleanup
ERR


unlink_testfiles();
done_testing;
