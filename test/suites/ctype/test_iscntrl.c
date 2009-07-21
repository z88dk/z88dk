
#include "ctype_test.h"
void t_iscntrl_0x00()
{
    Assert(iscntrl(0) ,"iscntrl should be 1 for 0x00");
}

void t_iscntrl_0x01()
{
    Assert(iscntrl(1) ,"iscntrl should be 1 for 0x01");
}

void t_iscntrl_0x02()
{
    Assert(iscntrl(2) ,"iscntrl should be 1 for 0x02");
}

void t_iscntrl_0x03()
{
    Assert(iscntrl(3) ,"iscntrl should be 1 for 0x03");
}

void t_iscntrl_0x04()
{
    Assert(iscntrl(4) ,"iscntrl should be 1 for 0x04");
}

void t_iscntrl_0x05()
{
    Assert(iscntrl(5) ,"iscntrl should be 1 for 0x05");
}

void t_iscntrl_0x06()
{
    Assert(iscntrl(6) ,"iscntrl should be 1 for 0x06");
}

void t_iscntrl_0x07()
{
    Assert(iscntrl(7) ,"iscntrl should be 1 for 0x07");
}

void t_iscntrl_0x08()
{
    Assert(iscntrl(8) ,"iscntrl should be 1 for 0x08");
}

void t_iscntrl_0x09()
{
    Assert(iscntrl(9) ,"iscntrl should be 1 for 0x09");
}

void t_iscntrl_0x0a()
{
    Assert(iscntrl(10) ,"iscntrl should be 1 for 0x0a");
}

void t_iscntrl_0x0b()
{
    Assert(iscntrl(11) ,"iscntrl should be 1 for 0x0b");
}

void t_iscntrl_0x0c()
{
    Assert(iscntrl(12) ,"iscntrl should be 1 for 0x0c");
}

void t_iscntrl_0x0d()
{
    Assert(iscntrl(13) ,"iscntrl should be 1 for 0x0d");
}

void t_iscntrl_0x0e()
{
    Assert(iscntrl(14) ,"iscntrl should be 1 for 0x0e");
}

void t_iscntrl_0x0f()
{
    Assert(iscntrl(15) ,"iscntrl should be 1 for 0x0f");
}

void t_iscntrl_0x10()
{
    Assert(iscntrl(16) ,"iscntrl should be 1 for 0x10");
}

void t_iscntrl_0x11()
{
    Assert(iscntrl(17) ,"iscntrl should be 1 for 0x11");
}

void t_iscntrl_0x12()
{
    Assert(iscntrl(18) ,"iscntrl should be 1 for 0x12");
}

void t_iscntrl_0x13()
{
    Assert(iscntrl(19) ,"iscntrl should be 1 for 0x13");
}

void t_iscntrl_0x14()
{
    Assert(iscntrl(20) ,"iscntrl should be 1 for 0x14");
}

void t_iscntrl_0x15()
{
    Assert(iscntrl(21) ,"iscntrl should be 1 for 0x15");
}

void t_iscntrl_0x16()
{
    Assert(iscntrl(22) ,"iscntrl should be 1 for 0x16");
}

void t_iscntrl_0x17()
{
    Assert(iscntrl(23) ,"iscntrl should be 1 for 0x17");
}

void t_iscntrl_0x18()
{
    Assert(iscntrl(24) ,"iscntrl should be 1 for 0x18");
}

void t_iscntrl_0x19()
{
    Assert(iscntrl(25) ,"iscntrl should be 1 for 0x19");
}

void t_iscntrl_0x1a()
{
    Assert(iscntrl(26) ,"iscntrl should be 1 for 0x1a");
}

void t_iscntrl_0x1b()
{
    Assert(iscntrl(27) ,"iscntrl should be 1 for 0x1b");
}

void t_iscntrl_0x1c()
{
    Assert(iscntrl(28) ,"iscntrl should be 1 for 0x1c");
}

void t_iscntrl_0x1d()
{
    Assert(iscntrl(29) ,"iscntrl should be 1 for 0x1d");
}

void t_iscntrl_0x1e()
{
    Assert(iscntrl(30) ,"iscntrl should be 1 for 0x1e");
}

void t_iscntrl_0x1f()
{
    Assert(iscntrl(31) ,"iscntrl should be 1 for 0x1f");
}

void t_iscntrl_0x20()
{
    Assert(iscntrl(32)  == 0 ,"iscntrl should be 0 for  ");
}

void t_iscntrl_0x21()
{
    Assert(iscntrl(33)  == 0 ,"iscntrl should be 0 for !");
}

void t_iscntrl_0x22()
{
    Assert(iscntrl(34)  == 0 ,"iscntrl should be 0 for 0x22");
}

void t_iscntrl_0x23()
{
    Assert(iscntrl(35)  == 0 ,"iscntrl should be 0 for #");
}

void t_iscntrl_0x24()
{
    Assert(iscntrl(36)  == 0 ,"iscntrl should be 0 for $");
}

void t_iscntrl_0x25()
{
    Assert(iscntrl(37)  == 0 ,"iscntrl should be 0 for %");
}

void t_iscntrl_0x26()
{
    Assert(iscntrl(38)  == 0 ,"iscntrl should be 0 for &");
}

void t_iscntrl_0x27()
{
    Assert(iscntrl(39)  == 0 ,"iscntrl should be 0 for '");
}

void t_iscntrl_0x28()
{
    Assert(iscntrl(40)  == 0 ,"iscntrl should be 0 for (");
}

void t_iscntrl_0x29()
{
    Assert(iscntrl(41)  == 0 ,"iscntrl should be 0 for )");
}

void t_iscntrl_0x2a()
{
    Assert(iscntrl(42)  == 0 ,"iscntrl should be 0 for *");
}

void t_iscntrl_0x2b()
{
    Assert(iscntrl(43)  == 0 ,"iscntrl should be 0 for +");
}

void t_iscntrl_0x2c()
{
    Assert(iscntrl(44)  == 0 ,"iscntrl should be 0 for ,");
}

void t_iscntrl_0x2d()
{
    Assert(iscntrl(45)  == 0 ,"iscntrl should be 0 for -");
}

void t_iscntrl_0x2e()
{
    Assert(iscntrl(46)  == 0 ,"iscntrl should be 0 for .");
}

void t_iscntrl_0x2f()
{
    Assert(iscntrl(47)  == 0 ,"iscntrl should be 0 for /");
}

void t_iscntrl_0x30()
{
    Assert(iscntrl(48)  == 0 ,"iscntrl should be 0 for 0");
}

void t_iscntrl_0x31()
{
    Assert(iscntrl(49)  == 0 ,"iscntrl should be 0 for 1");
}

void t_iscntrl_0x32()
{
    Assert(iscntrl(50)  == 0 ,"iscntrl should be 0 for 2");
}

void t_iscntrl_0x33()
{
    Assert(iscntrl(51)  == 0 ,"iscntrl should be 0 for 3");
}

void t_iscntrl_0x34()
{
    Assert(iscntrl(52)  == 0 ,"iscntrl should be 0 for 4");
}

void t_iscntrl_0x35()
{
    Assert(iscntrl(53)  == 0 ,"iscntrl should be 0 for 5");
}

void t_iscntrl_0x36()
{
    Assert(iscntrl(54)  == 0 ,"iscntrl should be 0 for 6");
}

void t_iscntrl_0x37()
{
    Assert(iscntrl(55)  == 0 ,"iscntrl should be 0 for 7");
}

void t_iscntrl_0x38()
{
    Assert(iscntrl(56)  == 0 ,"iscntrl should be 0 for 8");
}

void t_iscntrl_0x39()
{
    Assert(iscntrl(57)  == 0 ,"iscntrl should be 0 for 9");
}

void t_iscntrl_0x3a()
{
    Assert(iscntrl(58)  == 0 ,"iscntrl should be 0 for :");
}

void t_iscntrl_0x3b()
{
    Assert(iscntrl(59)  == 0 ,"iscntrl should be 0 for ;");
}

void t_iscntrl_0x3c()
{
    Assert(iscntrl(60)  == 0 ,"iscntrl should be 0 for <");
}

void t_iscntrl_0x3d()
{
    Assert(iscntrl(61)  == 0 ,"iscntrl should be 0 for =");
}

void t_iscntrl_0x3e()
{
    Assert(iscntrl(62)  == 0 ,"iscntrl should be 0 for >");
}

void t_iscntrl_0x3f()
{
    Assert(iscntrl(63)  == 0 ,"iscntrl should be 0 for ?");
}

void t_iscntrl_0x40()
{
    Assert(iscntrl(64)  == 0 ,"iscntrl should be 0 for @");
}

void t_iscntrl_0x41()
{
    Assert(iscntrl(65)  == 0 ,"iscntrl should be 0 for A");
}

void t_iscntrl_0x42()
{
    Assert(iscntrl(66)  == 0 ,"iscntrl should be 0 for B");
}

void t_iscntrl_0x43()
{
    Assert(iscntrl(67)  == 0 ,"iscntrl should be 0 for C");
}

void t_iscntrl_0x44()
{
    Assert(iscntrl(68)  == 0 ,"iscntrl should be 0 for D");
}

void t_iscntrl_0x45()
{
    Assert(iscntrl(69)  == 0 ,"iscntrl should be 0 for E");
}

void t_iscntrl_0x46()
{
    Assert(iscntrl(70)  == 0 ,"iscntrl should be 0 for F");
}

void t_iscntrl_0x47()
{
    Assert(iscntrl(71)  == 0 ,"iscntrl should be 0 for G");
}

void t_iscntrl_0x48()
{
    Assert(iscntrl(72)  == 0 ,"iscntrl should be 0 for H");
}

void t_iscntrl_0x49()
{
    Assert(iscntrl(73)  == 0 ,"iscntrl should be 0 for I");
}

void t_iscntrl_0x4a()
{
    Assert(iscntrl(74)  == 0 ,"iscntrl should be 0 for J");
}

void t_iscntrl_0x4b()
{
    Assert(iscntrl(75)  == 0 ,"iscntrl should be 0 for K");
}

void t_iscntrl_0x4c()
{
    Assert(iscntrl(76)  == 0 ,"iscntrl should be 0 for L");
}

void t_iscntrl_0x4d()
{
    Assert(iscntrl(77)  == 0 ,"iscntrl should be 0 for M");
}

void t_iscntrl_0x4e()
{
    Assert(iscntrl(78)  == 0 ,"iscntrl should be 0 for N");
}

void t_iscntrl_0x4f()
{
    Assert(iscntrl(79)  == 0 ,"iscntrl should be 0 for O");
}

void t_iscntrl_0x50()
{
    Assert(iscntrl(80)  == 0 ,"iscntrl should be 0 for P");
}

void t_iscntrl_0x51()
{
    Assert(iscntrl(81)  == 0 ,"iscntrl should be 0 for Q");
}

void t_iscntrl_0x52()
{
    Assert(iscntrl(82)  == 0 ,"iscntrl should be 0 for R");
}

void t_iscntrl_0x53()
{
    Assert(iscntrl(83)  == 0 ,"iscntrl should be 0 for S");
}

void t_iscntrl_0x54()
{
    Assert(iscntrl(84)  == 0 ,"iscntrl should be 0 for T");
}

void t_iscntrl_0x55()
{
    Assert(iscntrl(85)  == 0 ,"iscntrl should be 0 for U");
}

void t_iscntrl_0x56()
{
    Assert(iscntrl(86)  == 0 ,"iscntrl should be 0 for V");
}

void t_iscntrl_0x57()
{
    Assert(iscntrl(87)  == 0 ,"iscntrl should be 0 for W");
}

void t_iscntrl_0x58()
{
    Assert(iscntrl(88)  == 0 ,"iscntrl should be 0 for X");
}

void t_iscntrl_0x59()
{
    Assert(iscntrl(89)  == 0 ,"iscntrl should be 0 for Y");
}

void t_iscntrl_0x5a()
{
    Assert(iscntrl(90)  == 0 ,"iscntrl should be 0 for Z");
}

void t_iscntrl_0x5b()
{
    Assert(iscntrl(91)  == 0 ,"iscntrl should be 0 for [");
}

void t_iscntrl_0x5c()
{
    Assert(iscntrl(92)  == 0 ,"iscntrl should be 0 for 0x5c");
}

void t_iscntrl_0x5d()
{
    Assert(iscntrl(93)  == 0 ,"iscntrl should be 0 for ]");
}

void t_iscntrl_0x5e()
{
    Assert(iscntrl(94)  == 0 ,"iscntrl should be 0 for ^");
}

void t_iscntrl_0x5f()
{
    Assert(iscntrl(95)  == 0 ,"iscntrl should be 0 for _");
}

void t_iscntrl_0x60()
{
    Assert(iscntrl(96)  == 0 ,"iscntrl should be 0 for `");
}

void t_iscntrl_0x61()
{
    Assert(iscntrl(97)  == 0 ,"iscntrl should be 0 for a");
}

void t_iscntrl_0x62()
{
    Assert(iscntrl(98)  == 0 ,"iscntrl should be 0 for b");
}

void t_iscntrl_0x63()
{
    Assert(iscntrl(99)  == 0 ,"iscntrl should be 0 for c");
}

void t_iscntrl_0x64()
{
    Assert(iscntrl(100)  == 0 ,"iscntrl should be 0 for d");
}

void t_iscntrl_0x65()
{
    Assert(iscntrl(101)  == 0 ,"iscntrl should be 0 for e");
}

void t_iscntrl_0x66()
{
    Assert(iscntrl(102)  == 0 ,"iscntrl should be 0 for f");
}

void t_iscntrl_0x67()
{
    Assert(iscntrl(103)  == 0 ,"iscntrl should be 0 for g");
}

void t_iscntrl_0x68()
{
    Assert(iscntrl(104)  == 0 ,"iscntrl should be 0 for h");
}

void t_iscntrl_0x69()
{
    Assert(iscntrl(105)  == 0 ,"iscntrl should be 0 for i");
}

void t_iscntrl_0x6a()
{
    Assert(iscntrl(106)  == 0 ,"iscntrl should be 0 for j");
}

void t_iscntrl_0x6b()
{
    Assert(iscntrl(107)  == 0 ,"iscntrl should be 0 for k");
}

void t_iscntrl_0x6c()
{
    Assert(iscntrl(108)  == 0 ,"iscntrl should be 0 for l");
}

void t_iscntrl_0x6d()
{
    Assert(iscntrl(109)  == 0 ,"iscntrl should be 0 for m");
}

void t_iscntrl_0x6e()
{
    Assert(iscntrl(110)  == 0 ,"iscntrl should be 0 for n");
}

void t_iscntrl_0x6f()
{
    Assert(iscntrl(111)  == 0 ,"iscntrl should be 0 for o");
}

void t_iscntrl_0x70()
{
    Assert(iscntrl(112)  == 0 ,"iscntrl should be 0 for p");
}

void t_iscntrl_0x71()
{
    Assert(iscntrl(113)  == 0 ,"iscntrl should be 0 for q");
}

void t_iscntrl_0x72()
{
    Assert(iscntrl(114)  == 0 ,"iscntrl should be 0 for r");
}

void t_iscntrl_0x73()
{
    Assert(iscntrl(115)  == 0 ,"iscntrl should be 0 for s");
}

void t_iscntrl_0x74()
{
    Assert(iscntrl(116)  == 0 ,"iscntrl should be 0 for t");
}

void t_iscntrl_0x75()
{
    Assert(iscntrl(117)  == 0 ,"iscntrl should be 0 for u");
}

void t_iscntrl_0x76()
{
    Assert(iscntrl(118)  == 0 ,"iscntrl should be 0 for v");
}

void t_iscntrl_0x77()
{
    Assert(iscntrl(119)  == 0 ,"iscntrl should be 0 for w");
}

void t_iscntrl_0x78()
{
    Assert(iscntrl(120)  == 0 ,"iscntrl should be 0 for x");
}

void t_iscntrl_0x79()
{
    Assert(iscntrl(121)  == 0 ,"iscntrl should be 0 for y");
}

void t_iscntrl_0x7a()
{
    Assert(iscntrl(122)  == 0 ,"iscntrl should be 0 for z");
}

void t_iscntrl_0x7b()
{
    Assert(iscntrl(123)  == 0 ,"iscntrl should be 0 for {");
}

void t_iscntrl_0x7c()
{
    Assert(iscntrl(124)  == 0 ,"iscntrl should be 0 for |");
}

void t_iscntrl_0x7d()
{
    Assert(iscntrl(125)  == 0 ,"iscntrl should be 0 for }");
}

void t_iscntrl_0x7e()
{
    Assert(iscntrl(126)  == 0 ,"iscntrl should be 0 for ~");
}

void t_iscntrl_0x7f()
{
    Assert(iscntrl(127) ,"iscntrl should be 1 for 0x7f");
}

void t_iscntrl_0x80()
{
    Assert(iscntrl(128)  == 0 ,"iscntrl should be 0 for 0x80");
}

void t_iscntrl_0x81()
{
    Assert(iscntrl(129)  == 0 ,"iscntrl should be 0 for 0x81");
}

void t_iscntrl_0x82()
{
    Assert(iscntrl(130)  == 0 ,"iscntrl should be 0 for 0x82");
}

void t_iscntrl_0x83()
{
    Assert(iscntrl(131)  == 0 ,"iscntrl should be 0 for 0x83");
}

void t_iscntrl_0x84()
{
    Assert(iscntrl(132)  == 0 ,"iscntrl should be 0 for 0x84");
}

void t_iscntrl_0x85()
{
    Assert(iscntrl(133)  == 0 ,"iscntrl should be 0 for 0x85");
}

void t_iscntrl_0x86()
{
    Assert(iscntrl(134)  == 0 ,"iscntrl should be 0 for 0x86");
}

void t_iscntrl_0x87()
{
    Assert(iscntrl(135)  == 0 ,"iscntrl should be 0 for 0x87");
}

void t_iscntrl_0x88()
{
    Assert(iscntrl(136)  == 0 ,"iscntrl should be 0 for 0x88");
}

void t_iscntrl_0x89()
{
    Assert(iscntrl(137)  == 0 ,"iscntrl should be 0 for 0x89");
}

void t_iscntrl_0x8a()
{
    Assert(iscntrl(138)  == 0 ,"iscntrl should be 0 for 0x8a");
}

void t_iscntrl_0x8b()
{
    Assert(iscntrl(139)  == 0 ,"iscntrl should be 0 for 0x8b");
}

void t_iscntrl_0x8c()
{
    Assert(iscntrl(140)  == 0 ,"iscntrl should be 0 for 0x8c");
}

void t_iscntrl_0x8d()
{
    Assert(iscntrl(141)  == 0 ,"iscntrl should be 0 for 0x8d");
}

void t_iscntrl_0x8e()
{
    Assert(iscntrl(142)  == 0 ,"iscntrl should be 0 for 0x8e");
}

void t_iscntrl_0x8f()
{
    Assert(iscntrl(143)  == 0 ,"iscntrl should be 0 for 0x8f");
}

void t_iscntrl_0x90()
{
    Assert(iscntrl(144)  == 0 ,"iscntrl should be 0 for 0x90");
}

void t_iscntrl_0x91()
{
    Assert(iscntrl(145)  == 0 ,"iscntrl should be 0 for 0x91");
}

void t_iscntrl_0x92()
{
    Assert(iscntrl(146)  == 0 ,"iscntrl should be 0 for 0x92");
}

void t_iscntrl_0x93()
{
    Assert(iscntrl(147)  == 0 ,"iscntrl should be 0 for 0x93");
}

void t_iscntrl_0x94()
{
    Assert(iscntrl(148)  == 0 ,"iscntrl should be 0 for 0x94");
}

void t_iscntrl_0x95()
{
    Assert(iscntrl(149)  == 0 ,"iscntrl should be 0 for 0x95");
}

void t_iscntrl_0x96()
{
    Assert(iscntrl(150)  == 0 ,"iscntrl should be 0 for 0x96");
}

void t_iscntrl_0x97()
{
    Assert(iscntrl(151)  == 0 ,"iscntrl should be 0 for 0x97");
}

void t_iscntrl_0x98()
{
    Assert(iscntrl(152)  == 0 ,"iscntrl should be 0 for 0x98");
}

void t_iscntrl_0x99()
{
    Assert(iscntrl(153)  == 0 ,"iscntrl should be 0 for 0x99");
}

void t_iscntrl_0x9a()
{
    Assert(iscntrl(154)  == 0 ,"iscntrl should be 0 for 0x9a");
}

void t_iscntrl_0x9b()
{
    Assert(iscntrl(155)  == 0 ,"iscntrl should be 0 for 0x9b");
}

void t_iscntrl_0x9c()
{
    Assert(iscntrl(156)  == 0 ,"iscntrl should be 0 for 0x9c");
}

void t_iscntrl_0x9d()
{
    Assert(iscntrl(157)  == 0 ,"iscntrl should be 0 for 0x9d");
}

void t_iscntrl_0x9e()
{
    Assert(iscntrl(158)  == 0 ,"iscntrl should be 0 for 0x9e");
}

void t_iscntrl_0x9f()
{
    Assert(iscntrl(159)  == 0 ,"iscntrl should be 0 for 0x9f");
}

void t_iscntrl_0xa0()
{
    Assert(iscntrl(160)  == 0 ,"iscntrl should be 0 for 0xa0");
}

void t_iscntrl_0xa1()
{
    Assert(iscntrl(161)  == 0 ,"iscntrl should be 0 for 0xa1");
}

void t_iscntrl_0xa2()
{
    Assert(iscntrl(162)  == 0 ,"iscntrl should be 0 for 0xa2");
}

void t_iscntrl_0xa3()
{
    Assert(iscntrl(163)  == 0 ,"iscntrl should be 0 for 0xa3");
}

void t_iscntrl_0xa4()
{
    Assert(iscntrl(164)  == 0 ,"iscntrl should be 0 for 0xa4");
}

void t_iscntrl_0xa5()
{
    Assert(iscntrl(165)  == 0 ,"iscntrl should be 0 for 0xa5");
}

void t_iscntrl_0xa6()
{
    Assert(iscntrl(166)  == 0 ,"iscntrl should be 0 for 0xa6");
}

void t_iscntrl_0xa7()
{
    Assert(iscntrl(167)  == 0 ,"iscntrl should be 0 for 0xa7");
}

void t_iscntrl_0xa8()
{
    Assert(iscntrl(168)  == 0 ,"iscntrl should be 0 for 0xa8");
}

void t_iscntrl_0xa9()
{
    Assert(iscntrl(169)  == 0 ,"iscntrl should be 0 for 0xa9");
}

void t_iscntrl_0xaa()
{
    Assert(iscntrl(170)  == 0 ,"iscntrl should be 0 for 0xaa");
}

void t_iscntrl_0xab()
{
    Assert(iscntrl(171)  == 0 ,"iscntrl should be 0 for 0xab");
}

void t_iscntrl_0xac()
{
    Assert(iscntrl(172)  == 0 ,"iscntrl should be 0 for 0xac");
}

void t_iscntrl_0xad()
{
    Assert(iscntrl(173)  == 0 ,"iscntrl should be 0 for 0xad");
}

void t_iscntrl_0xae()
{
    Assert(iscntrl(174)  == 0 ,"iscntrl should be 0 for 0xae");
}

void t_iscntrl_0xaf()
{
    Assert(iscntrl(175)  == 0 ,"iscntrl should be 0 for 0xaf");
}

void t_iscntrl_0xb0()
{
    Assert(iscntrl(176)  == 0 ,"iscntrl should be 0 for 0xb0");
}

void t_iscntrl_0xb1()
{
    Assert(iscntrl(177)  == 0 ,"iscntrl should be 0 for 0xb1");
}

void t_iscntrl_0xb2()
{
    Assert(iscntrl(178)  == 0 ,"iscntrl should be 0 for 0xb2");
}

void t_iscntrl_0xb3()
{
    Assert(iscntrl(179)  == 0 ,"iscntrl should be 0 for 0xb3");
}

void t_iscntrl_0xb4()
{
    Assert(iscntrl(180)  == 0 ,"iscntrl should be 0 for 0xb4");
}

void t_iscntrl_0xb5()
{
    Assert(iscntrl(181)  == 0 ,"iscntrl should be 0 for 0xb5");
}

void t_iscntrl_0xb6()
{
    Assert(iscntrl(182)  == 0 ,"iscntrl should be 0 for 0xb6");
}

void t_iscntrl_0xb7()
{
    Assert(iscntrl(183)  == 0 ,"iscntrl should be 0 for 0xb7");
}

void t_iscntrl_0xb8()
{
    Assert(iscntrl(184)  == 0 ,"iscntrl should be 0 for 0xb8");
}

void t_iscntrl_0xb9()
{
    Assert(iscntrl(185)  == 0 ,"iscntrl should be 0 for 0xb9");
}

void t_iscntrl_0xba()
{
    Assert(iscntrl(186)  == 0 ,"iscntrl should be 0 for 0xba");
}

void t_iscntrl_0xbb()
{
    Assert(iscntrl(187)  == 0 ,"iscntrl should be 0 for 0xbb");
}

void t_iscntrl_0xbc()
{
    Assert(iscntrl(188)  == 0 ,"iscntrl should be 0 for 0xbc");
}

void t_iscntrl_0xbd()
{
    Assert(iscntrl(189)  == 0 ,"iscntrl should be 0 for 0xbd");
}

void t_iscntrl_0xbe()
{
    Assert(iscntrl(190)  == 0 ,"iscntrl should be 0 for 0xbe");
}

void t_iscntrl_0xbf()
{
    Assert(iscntrl(191)  == 0 ,"iscntrl should be 0 for 0xbf");
}

void t_iscntrl_0xc0()
{
    Assert(iscntrl(192)  == 0 ,"iscntrl should be 0 for 0xc0");
}

void t_iscntrl_0xc1()
{
    Assert(iscntrl(193)  == 0 ,"iscntrl should be 0 for 0xc1");
}

void t_iscntrl_0xc2()
{
    Assert(iscntrl(194)  == 0 ,"iscntrl should be 0 for 0xc2");
}

void t_iscntrl_0xc3()
{
    Assert(iscntrl(195)  == 0 ,"iscntrl should be 0 for 0xc3");
}

void t_iscntrl_0xc4()
{
    Assert(iscntrl(196)  == 0 ,"iscntrl should be 0 for 0xc4");
}

void t_iscntrl_0xc5()
{
    Assert(iscntrl(197)  == 0 ,"iscntrl should be 0 for 0xc5");
}

void t_iscntrl_0xc6()
{
    Assert(iscntrl(198)  == 0 ,"iscntrl should be 0 for 0xc6");
}

void t_iscntrl_0xc7()
{
    Assert(iscntrl(199)  == 0 ,"iscntrl should be 0 for 0xc7");
}

void t_iscntrl_0xc8()
{
    Assert(iscntrl(200)  == 0 ,"iscntrl should be 0 for 0xc8");
}

void t_iscntrl_0xc9()
{
    Assert(iscntrl(201)  == 0 ,"iscntrl should be 0 for 0xc9");
}

void t_iscntrl_0xca()
{
    Assert(iscntrl(202)  == 0 ,"iscntrl should be 0 for 0xca");
}

void t_iscntrl_0xcb()
{
    Assert(iscntrl(203)  == 0 ,"iscntrl should be 0 for 0xcb");
}

void t_iscntrl_0xcc()
{
    Assert(iscntrl(204)  == 0 ,"iscntrl should be 0 for 0xcc");
}

void t_iscntrl_0xcd()
{
    Assert(iscntrl(205)  == 0 ,"iscntrl should be 0 for 0xcd");
}

void t_iscntrl_0xce()
{
    Assert(iscntrl(206)  == 0 ,"iscntrl should be 0 for 0xce");
}

void t_iscntrl_0xcf()
{
    Assert(iscntrl(207)  == 0 ,"iscntrl should be 0 for 0xcf");
}

void t_iscntrl_0xd0()
{
    Assert(iscntrl(208)  == 0 ,"iscntrl should be 0 for 0xd0");
}

void t_iscntrl_0xd1()
{
    Assert(iscntrl(209)  == 0 ,"iscntrl should be 0 for 0xd1");
}

void t_iscntrl_0xd2()
{
    Assert(iscntrl(210)  == 0 ,"iscntrl should be 0 for 0xd2");
}

void t_iscntrl_0xd3()
{
    Assert(iscntrl(211)  == 0 ,"iscntrl should be 0 for 0xd3");
}

void t_iscntrl_0xd4()
{
    Assert(iscntrl(212)  == 0 ,"iscntrl should be 0 for 0xd4");
}

void t_iscntrl_0xd5()
{
    Assert(iscntrl(213)  == 0 ,"iscntrl should be 0 for 0xd5");
}

void t_iscntrl_0xd6()
{
    Assert(iscntrl(214)  == 0 ,"iscntrl should be 0 for 0xd6");
}

void t_iscntrl_0xd7()
{
    Assert(iscntrl(215)  == 0 ,"iscntrl should be 0 for 0xd7");
}

void t_iscntrl_0xd8()
{
    Assert(iscntrl(216)  == 0 ,"iscntrl should be 0 for 0xd8");
}

void t_iscntrl_0xd9()
{
    Assert(iscntrl(217)  == 0 ,"iscntrl should be 0 for 0xd9");
}

void t_iscntrl_0xda()
{
    Assert(iscntrl(218)  == 0 ,"iscntrl should be 0 for 0xda");
}

void t_iscntrl_0xdb()
{
    Assert(iscntrl(219)  == 0 ,"iscntrl should be 0 for 0xdb");
}

void t_iscntrl_0xdc()
{
    Assert(iscntrl(220)  == 0 ,"iscntrl should be 0 for 0xdc");
}

void t_iscntrl_0xdd()
{
    Assert(iscntrl(221)  == 0 ,"iscntrl should be 0 for 0xdd");
}

void t_iscntrl_0xde()
{
    Assert(iscntrl(222)  == 0 ,"iscntrl should be 0 for 0xde");
}

void t_iscntrl_0xdf()
{
    Assert(iscntrl(223)  == 0 ,"iscntrl should be 0 for 0xdf");
}

void t_iscntrl_0xe0()
{
    Assert(iscntrl(224)  == 0 ,"iscntrl should be 0 for 0xe0");
}

void t_iscntrl_0xe1()
{
    Assert(iscntrl(225)  == 0 ,"iscntrl should be 0 for 0xe1");
}

void t_iscntrl_0xe2()
{
    Assert(iscntrl(226)  == 0 ,"iscntrl should be 0 for 0xe2");
}

void t_iscntrl_0xe3()
{
    Assert(iscntrl(227)  == 0 ,"iscntrl should be 0 for 0xe3");
}

void t_iscntrl_0xe4()
{
    Assert(iscntrl(228)  == 0 ,"iscntrl should be 0 for 0xe4");
}

void t_iscntrl_0xe5()
{
    Assert(iscntrl(229)  == 0 ,"iscntrl should be 0 for 0xe5");
}

void t_iscntrl_0xe6()
{
    Assert(iscntrl(230)  == 0 ,"iscntrl should be 0 for 0xe6");
}

void t_iscntrl_0xe7()
{
    Assert(iscntrl(231)  == 0 ,"iscntrl should be 0 for 0xe7");
}

void t_iscntrl_0xe8()
{
    Assert(iscntrl(232)  == 0 ,"iscntrl should be 0 for 0xe8");
}

void t_iscntrl_0xe9()
{
    Assert(iscntrl(233)  == 0 ,"iscntrl should be 0 for 0xe9");
}

void t_iscntrl_0xea()
{
    Assert(iscntrl(234)  == 0 ,"iscntrl should be 0 for 0xea");
}

void t_iscntrl_0xeb()
{
    Assert(iscntrl(235)  == 0 ,"iscntrl should be 0 for 0xeb");
}

void t_iscntrl_0xec()
{
    Assert(iscntrl(236)  == 0 ,"iscntrl should be 0 for 0xec");
}

void t_iscntrl_0xed()
{
    Assert(iscntrl(237)  == 0 ,"iscntrl should be 0 for 0xed");
}

void t_iscntrl_0xee()
{
    Assert(iscntrl(238)  == 0 ,"iscntrl should be 0 for 0xee");
}

void t_iscntrl_0xef()
{
    Assert(iscntrl(239)  == 0 ,"iscntrl should be 0 for 0xef");
}

void t_iscntrl_0xf0()
{
    Assert(iscntrl(240)  == 0 ,"iscntrl should be 0 for 0xf0");
}

void t_iscntrl_0xf1()
{
    Assert(iscntrl(241)  == 0 ,"iscntrl should be 0 for 0xf1");
}

void t_iscntrl_0xf2()
{
    Assert(iscntrl(242)  == 0 ,"iscntrl should be 0 for 0xf2");
}

void t_iscntrl_0xf3()
{
    Assert(iscntrl(243)  == 0 ,"iscntrl should be 0 for 0xf3");
}

void t_iscntrl_0xf4()
{
    Assert(iscntrl(244)  == 0 ,"iscntrl should be 0 for 0xf4");
}

void t_iscntrl_0xf5()
{
    Assert(iscntrl(245)  == 0 ,"iscntrl should be 0 for 0xf5");
}

void t_iscntrl_0xf6()
{
    Assert(iscntrl(246)  == 0 ,"iscntrl should be 0 for 0xf6");
}

void t_iscntrl_0xf7()
{
    Assert(iscntrl(247)  == 0 ,"iscntrl should be 0 for 0xf7");
}

void t_iscntrl_0xf8()
{
    Assert(iscntrl(248)  == 0 ,"iscntrl should be 0 for 0xf8");
}

void t_iscntrl_0xf9()
{
    Assert(iscntrl(249)  == 0 ,"iscntrl should be 0 for 0xf9");
}

void t_iscntrl_0xfa()
{
    Assert(iscntrl(250)  == 0 ,"iscntrl should be 0 for 0xfa");
}

void t_iscntrl_0xfb()
{
    Assert(iscntrl(251)  == 0 ,"iscntrl should be 0 for 0xfb");
}

void t_iscntrl_0xfc()
{
    Assert(iscntrl(252)  == 0 ,"iscntrl should be 0 for 0xfc");
}

void t_iscntrl_0xfd()
{
    Assert(iscntrl(253)  == 0 ,"iscntrl should be 0 for 0xfd");
}

void t_iscntrl_0xfe()
{
    Assert(iscntrl(254)  == 0 ,"iscntrl should be 0 for 0xfe");
}

void t_iscntrl_0xff()
{
    Assert(iscntrl(255)  == 0 ,"iscntrl should be 0 for 0xff");
}



int test_iscntrl()
{
    suite_setup("iscntrl");
    suite_add_test(t_iscntrl_0x00);
    suite_add_test(t_iscntrl_0x01);
    suite_add_test(t_iscntrl_0x02);
    suite_add_test(t_iscntrl_0x03);
    suite_add_test(t_iscntrl_0x04);
    suite_add_test(t_iscntrl_0x05);
    suite_add_test(t_iscntrl_0x06);
    suite_add_test(t_iscntrl_0x07);
    suite_add_test(t_iscntrl_0x08);
    suite_add_test(t_iscntrl_0x09);
    suite_add_test(t_iscntrl_0x0a);
    suite_add_test(t_iscntrl_0x0b);
    suite_add_test(t_iscntrl_0x0c);
    suite_add_test(t_iscntrl_0x0d);
    suite_add_test(t_iscntrl_0x0e);
    suite_add_test(t_iscntrl_0x0f);
    suite_add_test(t_iscntrl_0x10);
    suite_add_test(t_iscntrl_0x11);
    suite_add_test(t_iscntrl_0x12);
    suite_add_test(t_iscntrl_0x13);
    suite_add_test(t_iscntrl_0x14);
    suite_add_test(t_iscntrl_0x15);
    suite_add_test(t_iscntrl_0x16);
    suite_add_test(t_iscntrl_0x17);
    suite_add_test(t_iscntrl_0x18);
    suite_add_test(t_iscntrl_0x19);
    suite_add_test(t_iscntrl_0x1a);
    suite_add_test(t_iscntrl_0x1b);
    suite_add_test(t_iscntrl_0x1c);
    suite_add_test(t_iscntrl_0x1d);
    suite_add_test(t_iscntrl_0x1e);
    suite_add_test(t_iscntrl_0x1f);
    suite_add_test(t_iscntrl_0x20);
    suite_add_test(t_iscntrl_0x21);
    suite_add_test(t_iscntrl_0x22);
    suite_add_test(t_iscntrl_0x23);
    suite_add_test(t_iscntrl_0x24);
    suite_add_test(t_iscntrl_0x25);
    suite_add_test(t_iscntrl_0x26);
    suite_add_test(t_iscntrl_0x27);
    suite_add_test(t_iscntrl_0x28);
    suite_add_test(t_iscntrl_0x29);
    suite_add_test(t_iscntrl_0x2a);
    suite_add_test(t_iscntrl_0x2b);
    suite_add_test(t_iscntrl_0x2c);
    suite_add_test(t_iscntrl_0x2d);
    suite_add_test(t_iscntrl_0x2e);
    suite_add_test(t_iscntrl_0x2f);
    suite_add_test(t_iscntrl_0x30);
    suite_add_test(t_iscntrl_0x31);
    suite_add_test(t_iscntrl_0x32);
    suite_add_test(t_iscntrl_0x33);
    suite_add_test(t_iscntrl_0x34);
    suite_add_test(t_iscntrl_0x35);
    suite_add_test(t_iscntrl_0x36);
    suite_add_test(t_iscntrl_0x37);
    suite_add_test(t_iscntrl_0x38);
    suite_add_test(t_iscntrl_0x39);
    suite_add_test(t_iscntrl_0x3a);
    suite_add_test(t_iscntrl_0x3b);
    suite_add_test(t_iscntrl_0x3c);
    suite_add_test(t_iscntrl_0x3d);
    suite_add_test(t_iscntrl_0x3e);
    suite_add_test(t_iscntrl_0x3f);
    suite_add_test(t_iscntrl_0x40);
    suite_add_test(t_iscntrl_0x41);
    suite_add_test(t_iscntrl_0x42);
    suite_add_test(t_iscntrl_0x43);
    suite_add_test(t_iscntrl_0x44);
    suite_add_test(t_iscntrl_0x45);
    suite_add_test(t_iscntrl_0x46);
    suite_add_test(t_iscntrl_0x47);
    suite_add_test(t_iscntrl_0x48);
    suite_add_test(t_iscntrl_0x49);
    suite_add_test(t_iscntrl_0x4a);
    suite_add_test(t_iscntrl_0x4b);
    suite_add_test(t_iscntrl_0x4c);
    suite_add_test(t_iscntrl_0x4d);
    suite_add_test(t_iscntrl_0x4e);
    suite_add_test(t_iscntrl_0x4f);
    suite_add_test(t_iscntrl_0x50);
    suite_add_test(t_iscntrl_0x51);
    suite_add_test(t_iscntrl_0x52);
    suite_add_test(t_iscntrl_0x53);
    suite_add_test(t_iscntrl_0x54);
    suite_add_test(t_iscntrl_0x55);
    suite_add_test(t_iscntrl_0x56);
    suite_add_test(t_iscntrl_0x57);
    suite_add_test(t_iscntrl_0x58);
    suite_add_test(t_iscntrl_0x59);
    suite_add_test(t_iscntrl_0x5a);
    suite_add_test(t_iscntrl_0x5b);
    suite_add_test(t_iscntrl_0x5c);
    suite_add_test(t_iscntrl_0x5d);
    suite_add_test(t_iscntrl_0x5e);
    suite_add_test(t_iscntrl_0x5f);
    suite_add_test(t_iscntrl_0x60);
    suite_add_test(t_iscntrl_0x61);
    suite_add_test(t_iscntrl_0x62);
    suite_add_test(t_iscntrl_0x63);
    suite_add_test(t_iscntrl_0x64);
    suite_add_test(t_iscntrl_0x65);
    suite_add_test(t_iscntrl_0x66);
    suite_add_test(t_iscntrl_0x67);
    suite_add_test(t_iscntrl_0x68);
    suite_add_test(t_iscntrl_0x69);
    suite_add_test(t_iscntrl_0x6a);
    suite_add_test(t_iscntrl_0x6b);
    suite_add_test(t_iscntrl_0x6c);
    suite_add_test(t_iscntrl_0x6d);
    suite_add_test(t_iscntrl_0x6e);
    suite_add_test(t_iscntrl_0x6f);
    suite_add_test(t_iscntrl_0x70);
    suite_add_test(t_iscntrl_0x71);
    suite_add_test(t_iscntrl_0x72);
    suite_add_test(t_iscntrl_0x73);
    suite_add_test(t_iscntrl_0x74);
    suite_add_test(t_iscntrl_0x75);
    suite_add_test(t_iscntrl_0x76);
    suite_add_test(t_iscntrl_0x77);
    suite_add_test(t_iscntrl_0x78);
    suite_add_test(t_iscntrl_0x79);
    suite_add_test(t_iscntrl_0x7a);
    suite_add_test(t_iscntrl_0x7b);
    suite_add_test(t_iscntrl_0x7c);
    suite_add_test(t_iscntrl_0x7d);
    suite_add_test(t_iscntrl_0x7e);
    suite_add_test(t_iscntrl_0x7f);
    suite_add_test(t_iscntrl_0x80);
    suite_add_test(t_iscntrl_0x81);
    suite_add_test(t_iscntrl_0x82);
    suite_add_test(t_iscntrl_0x83);
    suite_add_test(t_iscntrl_0x84);
    suite_add_test(t_iscntrl_0x85);
    suite_add_test(t_iscntrl_0x86);
    suite_add_test(t_iscntrl_0x87);
    suite_add_test(t_iscntrl_0x88);
    suite_add_test(t_iscntrl_0x89);
    suite_add_test(t_iscntrl_0x8a);
    suite_add_test(t_iscntrl_0x8b);
    suite_add_test(t_iscntrl_0x8c);
    suite_add_test(t_iscntrl_0x8d);
    suite_add_test(t_iscntrl_0x8e);
    suite_add_test(t_iscntrl_0x8f);
    suite_add_test(t_iscntrl_0x90);
    suite_add_test(t_iscntrl_0x91);
    suite_add_test(t_iscntrl_0x92);
    suite_add_test(t_iscntrl_0x93);
    suite_add_test(t_iscntrl_0x94);
    suite_add_test(t_iscntrl_0x95);
    suite_add_test(t_iscntrl_0x96);
    suite_add_test(t_iscntrl_0x97);
    suite_add_test(t_iscntrl_0x98);
    suite_add_test(t_iscntrl_0x99);
    suite_add_test(t_iscntrl_0x9a);
    suite_add_test(t_iscntrl_0x9b);
    suite_add_test(t_iscntrl_0x9c);
    suite_add_test(t_iscntrl_0x9d);
    suite_add_test(t_iscntrl_0x9e);
    suite_add_test(t_iscntrl_0x9f);
    suite_add_test(t_iscntrl_0xa0);
    suite_add_test(t_iscntrl_0xa1);
    suite_add_test(t_iscntrl_0xa2);
    suite_add_test(t_iscntrl_0xa3);
    suite_add_test(t_iscntrl_0xa4);
    suite_add_test(t_iscntrl_0xa5);
    suite_add_test(t_iscntrl_0xa6);
    suite_add_test(t_iscntrl_0xa7);
    suite_add_test(t_iscntrl_0xa8);
    suite_add_test(t_iscntrl_0xa9);
    suite_add_test(t_iscntrl_0xaa);
    suite_add_test(t_iscntrl_0xab);
    suite_add_test(t_iscntrl_0xac);
    suite_add_test(t_iscntrl_0xad);
    suite_add_test(t_iscntrl_0xae);
    suite_add_test(t_iscntrl_0xaf);
    suite_add_test(t_iscntrl_0xb0);
    suite_add_test(t_iscntrl_0xb1);
    suite_add_test(t_iscntrl_0xb2);
    suite_add_test(t_iscntrl_0xb3);
    suite_add_test(t_iscntrl_0xb4);
    suite_add_test(t_iscntrl_0xb5);
    suite_add_test(t_iscntrl_0xb6);
    suite_add_test(t_iscntrl_0xb7);
    suite_add_test(t_iscntrl_0xb8);
    suite_add_test(t_iscntrl_0xb9);
    suite_add_test(t_iscntrl_0xba);
    suite_add_test(t_iscntrl_0xbb);
    suite_add_test(t_iscntrl_0xbc);
    suite_add_test(t_iscntrl_0xbd);
    suite_add_test(t_iscntrl_0xbe);
    suite_add_test(t_iscntrl_0xbf);
    suite_add_test(t_iscntrl_0xc0);
    suite_add_test(t_iscntrl_0xc1);
    suite_add_test(t_iscntrl_0xc2);
    suite_add_test(t_iscntrl_0xc3);
    suite_add_test(t_iscntrl_0xc4);
    suite_add_test(t_iscntrl_0xc5);
    suite_add_test(t_iscntrl_0xc6);
    suite_add_test(t_iscntrl_0xc7);
    suite_add_test(t_iscntrl_0xc8);
    suite_add_test(t_iscntrl_0xc9);
    suite_add_test(t_iscntrl_0xca);
    suite_add_test(t_iscntrl_0xcb);
    suite_add_test(t_iscntrl_0xcc);
    suite_add_test(t_iscntrl_0xcd);
    suite_add_test(t_iscntrl_0xce);
    suite_add_test(t_iscntrl_0xcf);
    suite_add_test(t_iscntrl_0xd0);
    suite_add_test(t_iscntrl_0xd1);
    suite_add_test(t_iscntrl_0xd2);
    suite_add_test(t_iscntrl_0xd3);
    suite_add_test(t_iscntrl_0xd4);
    suite_add_test(t_iscntrl_0xd5);
    suite_add_test(t_iscntrl_0xd6);
    suite_add_test(t_iscntrl_0xd7);
    suite_add_test(t_iscntrl_0xd8);
    suite_add_test(t_iscntrl_0xd9);
    suite_add_test(t_iscntrl_0xda);
    suite_add_test(t_iscntrl_0xdb);
    suite_add_test(t_iscntrl_0xdc);
    suite_add_test(t_iscntrl_0xdd);
    suite_add_test(t_iscntrl_0xde);
    suite_add_test(t_iscntrl_0xdf);
    suite_add_test(t_iscntrl_0xe0);
    suite_add_test(t_iscntrl_0xe1);
    suite_add_test(t_iscntrl_0xe2);
    suite_add_test(t_iscntrl_0xe3);
    suite_add_test(t_iscntrl_0xe4);
    suite_add_test(t_iscntrl_0xe5);
    suite_add_test(t_iscntrl_0xe6);
    suite_add_test(t_iscntrl_0xe7);
    suite_add_test(t_iscntrl_0xe8);
    suite_add_test(t_iscntrl_0xe9);
    suite_add_test(t_iscntrl_0xea);
    suite_add_test(t_iscntrl_0xeb);
    suite_add_test(t_iscntrl_0xec);
    suite_add_test(t_iscntrl_0xed);
    suite_add_test(t_iscntrl_0xee);
    suite_add_test(t_iscntrl_0xef);
    suite_add_test(t_iscntrl_0xf0);
    suite_add_test(t_iscntrl_0xf1);
    suite_add_test(t_iscntrl_0xf2);
    suite_add_test(t_iscntrl_0xf3);
    suite_add_test(t_iscntrl_0xf4);
    suite_add_test(t_iscntrl_0xf5);
    suite_add_test(t_iscntrl_0xf6);
    suite_add_test(t_iscntrl_0xf7);
    suite_add_test(t_iscntrl_0xf8);
    suite_add_test(t_iscntrl_0xf9);
    suite_add_test(t_iscntrl_0xfa);
    suite_add_test(t_iscntrl_0xfb);
    suite_add_test(t_iscntrl_0xfc);
    suite_add_test(t_iscntrl_0xfd);
    suite_add_test(t_iscntrl_0xfe);
    suite_add_test(t_iscntrl_0xff);
     return suite_run();
}
