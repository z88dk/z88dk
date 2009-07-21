
#include "ctype_test.h"
void t_isalnum_0x00()
{
    Assert(isalnum(0)  == 0 ,"isalnum should be 0 for 0x00");
}

void t_isalnum_0x01()
{
    Assert(isalnum(1)  == 0 ,"isalnum should be 0 for 0x01");
}

void t_isalnum_0x02()
{
    Assert(isalnum(2)  == 0 ,"isalnum should be 0 for 0x02");
}

void t_isalnum_0x03()
{
    Assert(isalnum(3)  == 0 ,"isalnum should be 0 for 0x03");
}

void t_isalnum_0x04()
{
    Assert(isalnum(4)  == 0 ,"isalnum should be 0 for 0x04");
}

void t_isalnum_0x05()
{
    Assert(isalnum(5)  == 0 ,"isalnum should be 0 for 0x05");
}

void t_isalnum_0x06()
{
    Assert(isalnum(6)  == 0 ,"isalnum should be 0 for 0x06");
}

void t_isalnum_0x07()
{
    Assert(isalnum(7)  == 0 ,"isalnum should be 0 for 0x07");
}

void t_isalnum_0x08()
{
    Assert(isalnum(8)  == 0 ,"isalnum should be 0 for 0x08");
}

void t_isalnum_0x09()
{
    Assert(isalnum(9)  == 0 ,"isalnum should be 0 for 0x09");
}

void t_isalnum_0x0a()
{
    Assert(isalnum(10)  == 0 ,"isalnum should be 0 for 0x0a");
}

void t_isalnum_0x0b()
{
    Assert(isalnum(11)  == 0 ,"isalnum should be 0 for 0x0b");
}

void t_isalnum_0x0c()
{
    Assert(isalnum(12)  == 0 ,"isalnum should be 0 for 0x0c");
}

void t_isalnum_0x0d()
{
    Assert(isalnum(13)  == 0 ,"isalnum should be 0 for 0x0d");
}

void t_isalnum_0x0e()
{
    Assert(isalnum(14)  == 0 ,"isalnum should be 0 for 0x0e");
}

void t_isalnum_0x0f()
{
    Assert(isalnum(15)  == 0 ,"isalnum should be 0 for 0x0f");
}

void t_isalnum_0x10()
{
    Assert(isalnum(16)  == 0 ,"isalnum should be 0 for 0x10");
}

void t_isalnum_0x11()
{
    Assert(isalnum(17)  == 0 ,"isalnum should be 0 for 0x11");
}

void t_isalnum_0x12()
{
    Assert(isalnum(18)  == 0 ,"isalnum should be 0 for 0x12");
}

void t_isalnum_0x13()
{
    Assert(isalnum(19)  == 0 ,"isalnum should be 0 for 0x13");
}

void t_isalnum_0x14()
{
    Assert(isalnum(20)  == 0 ,"isalnum should be 0 for 0x14");
}

void t_isalnum_0x15()
{
    Assert(isalnum(21)  == 0 ,"isalnum should be 0 for 0x15");
}

void t_isalnum_0x16()
{
    Assert(isalnum(22)  == 0 ,"isalnum should be 0 for 0x16");
}

void t_isalnum_0x17()
{
    Assert(isalnum(23)  == 0 ,"isalnum should be 0 for 0x17");
}

void t_isalnum_0x18()
{
    Assert(isalnum(24)  == 0 ,"isalnum should be 0 for 0x18");
}

void t_isalnum_0x19()
{
    Assert(isalnum(25)  == 0 ,"isalnum should be 0 for 0x19");
}

void t_isalnum_0x1a()
{
    Assert(isalnum(26)  == 0 ,"isalnum should be 0 for 0x1a");
}

void t_isalnum_0x1b()
{
    Assert(isalnum(27)  == 0 ,"isalnum should be 0 for 0x1b");
}

void t_isalnum_0x1c()
{
    Assert(isalnum(28)  == 0 ,"isalnum should be 0 for 0x1c");
}

void t_isalnum_0x1d()
{
    Assert(isalnum(29)  == 0 ,"isalnum should be 0 for 0x1d");
}

void t_isalnum_0x1e()
{
    Assert(isalnum(30)  == 0 ,"isalnum should be 0 for 0x1e");
}

void t_isalnum_0x1f()
{
    Assert(isalnum(31)  == 0 ,"isalnum should be 0 for 0x1f");
}

void t_isalnum_0x20()
{
    Assert(isalnum(32)  == 0 ,"isalnum should be 0 for  ");
}

void t_isalnum_0x21()
{
    Assert(isalnum(33)  == 0 ,"isalnum should be 0 for !");
}

void t_isalnum_0x22()
{
    Assert(isalnum(34)  == 0 ,"isalnum should be 0 for 0x22");
}

void t_isalnum_0x23()
{
    Assert(isalnum(35)  == 0 ,"isalnum should be 0 for #");
}

void t_isalnum_0x24()
{
    Assert(isalnum(36)  == 0 ,"isalnum should be 0 for $");
}

void t_isalnum_0x25()
{
    Assert(isalnum(37)  == 0 ,"isalnum should be 0 for %");
}

void t_isalnum_0x26()
{
    Assert(isalnum(38)  == 0 ,"isalnum should be 0 for &");
}

void t_isalnum_0x27()
{
    Assert(isalnum(39)  == 0 ,"isalnum should be 0 for '");
}

void t_isalnum_0x28()
{
    Assert(isalnum(40)  == 0 ,"isalnum should be 0 for (");
}

void t_isalnum_0x29()
{
    Assert(isalnum(41)  == 0 ,"isalnum should be 0 for )");
}

void t_isalnum_0x2a()
{
    Assert(isalnum(42)  == 0 ,"isalnum should be 0 for *");
}

void t_isalnum_0x2b()
{
    Assert(isalnum(43)  == 0 ,"isalnum should be 0 for +");
}

void t_isalnum_0x2c()
{
    Assert(isalnum(44)  == 0 ,"isalnum should be 0 for ,");
}

void t_isalnum_0x2d()
{
    Assert(isalnum(45)  == 0 ,"isalnum should be 0 for -");
}

void t_isalnum_0x2e()
{
    Assert(isalnum(46)  == 0 ,"isalnum should be 0 for .");
}

void t_isalnum_0x2f()
{
    Assert(isalnum(47)  == 0 ,"isalnum should be 0 for /");
}

void t_isalnum_0x30()
{
    Assert(isalnum(48) ,"isalnum should be 1 for 0");
}

void t_isalnum_0x31()
{
    Assert(isalnum(49) ,"isalnum should be 1 for 1");
}

void t_isalnum_0x32()
{
    Assert(isalnum(50) ,"isalnum should be 1 for 2");
}

void t_isalnum_0x33()
{
    Assert(isalnum(51) ,"isalnum should be 1 for 3");
}

void t_isalnum_0x34()
{
    Assert(isalnum(52) ,"isalnum should be 1 for 4");
}

void t_isalnum_0x35()
{
    Assert(isalnum(53) ,"isalnum should be 1 for 5");
}

void t_isalnum_0x36()
{
    Assert(isalnum(54) ,"isalnum should be 1 for 6");
}

void t_isalnum_0x37()
{
    Assert(isalnum(55) ,"isalnum should be 1 for 7");
}

void t_isalnum_0x38()
{
    Assert(isalnum(56) ,"isalnum should be 1 for 8");
}

void t_isalnum_0x39()
{
    Assert(isalnum(57) ,"isalnum should be 1 for 9");
}

void t_isalnum_0x3a()
{
    Assert(isalnum(58)  == 0 ,"isalnum should be 0 for :");
}

void t_isalnum_0x3b()
{
    Assert(isalnum(59)  == 0 ,"isalnum should be 0 for ;");
}

void t_isalnum_0x3c()
{
    Assert(isalnum(60)  == 0 ,"isalnum should be 0 for <");
}

void t_isalnum_0x3d()
{
    Assert(isalnum(61)  == 0 ,"isalnum should be 0 for =");
}

void t_isalnum_0x3e()
{
    Assert(isalnum(62)  == 0 ,"isalnum should be 0 for >");
}

void t_isalnum_0x3f()
{
    Assert(isalnum(63)  == 0 ,"isalnum should be 0 for ?");
}

void t_isalnum_0x40()
{
    Assert(isalnum(64)  == 0 ,"isalnum should be 0 for @");
}

void t_isalnum_0x41()
{
    Assert(isalnum(65) ,"isalnum should be 1 for A");
}

void t_isalnum_0x42()
{
    Assert(isalnum(66) ,"isalnum should be 1 for B");
}

void t_isalnum_0x43()
{
    Assert(isalnum(67) ,"isalnum should be 1 for C");
}

void t_isalnum_0x44()
{
    Assert(isalnum(68) ,"isalnum should be 1 for D");
}

void t_isalnum_0x45()
{
    Assert(isalnum(69) ,"isalnum should be 1 for E");
}

void t_isalnum_0x46()
{
    Assert(isalnum(70) ,"isalnum should be 1 for F");
}

void t_isalnum_0x47()
{
    Assert(isalnum(71) ,"isalnum should be 1 for G");
}

void t_isalnum_0x48()
{
    Assert(isalnum(72) ,"isalnum should be 1 for H");
}

void t_isalnum_0x49()
{
    Assert(isalnum(73) ,"isalnum should be 1 for I");
}

void t_isalnum_0x4a()
{
    Assert(isalnum(74) ,"isalnum should be 1 for J");
}

void t_isalnum_0x4b()
{
    Assert(isalnum(75) ,"isalnum should be 1 for K");
}

void t_isalnum_0x4c()
{
    Assert(isalnum(76) ,"isalnum should be 1 for L");
}

void t_isalnum_0x4d()
{
    Assert(isalnum(77) ,"isalnum should be 1 for M");
}

void t_isalnum_0x4e()
{
    Assert(isalnum(78) ,"isalnum should be 1 for N");
}

void t_isalnum_0x4f()
{
    Assert(isalnum(79) ,"isalnum should be 1 for O");
}

void t_isalnum_0x50()
{
    Assert(isalnum(80) ,"isalnum should be 1 for P");
}

void t_isalnum_0x51()
{
    Assert(isalnum(81) ,"isalnum should be 1 for Q");
}

void t_isalnum_0x52()
{
    Assert(isalnum(82) ,"isalnum should be 1 for R");
}

void t_isalnum_0x53()
{
    Assert(isalnum(83) ,"isalnum should be 1 for S");
}

void t_isalnum_0x54()
{
    Assert(isalnum(84) ,"isalnum should be 1 for T");
}

void t_isalnum_0x55()
{
    Assert(isalnum(85) ,"isalnum should be 1 for U");
}

void t_isalnum_0x56()
{
    Assert(isalnum(86) ,"isalnum should be 1 for V");
}

void t_isalnum_0x57()
{
    Assert(isalnum(87) ,"isalnum should be 1 for W");
}

void t_isalnum_0x58()
{
    Assert(isalnum(88) ,"isalnum should be 1 for X");
}

void t_isalnum_0x59()
{
    Assert(isalnum(89) ,"isalnum should be 1 for Y");
}

void t_isalnum_0x5a()
{
    Assert(isalnum(90) ,"isalnum should be 1 for Z");
}

void t_isalnum_0x5b()
{
    Assert(isalnum(91)  == 0 ,"isalnum should be 0 for [");
}

void t_isalnum_0x5c()
{
    Assert(isalnum(92)  == 0 ,"isalnum should be 0 for 0x5c");
}

void t_isalnum_0x5d()
{
    Assert(isalnum(93)  == 0 ,"isalnum should be 0 for ]");
}

void t_isalnum_0x5e()
{
    Assert(isalnum(94)  == 0 ,"isalnum should be 0 for ^");
}

void t_isalnum_0x5f()
{
    Assert(isalnum(95)  == 0 ,"isalnum should be 0 for _");
}

void t_isalnum_0x60()
{
    Assert(isalnum(96)  == 0 ,"isalnum should be 0 for `");
}

void t_isalnum_0x61()
{
    Assert(isalnum(97) ,"isalnum should be 1 for a");
}

void t_isalnum_0x62()
{
    Assert(isalnum(98) ,"isalnum should be 1 for b");
}

void t_isalnum_0x63()
{
    Assert(isalnum(99) ,"isalnum should be 1 for c");
}

void t_isalnum_0x64()
{
    Assert(isalnum(100) ,"isalnum should be 1 for d");
}

void t_isalnum_0x65()
{
    Assert(isalnum(101) ,"isalnum should be 1 for e");
}

void t_isalnum_0x66()
{
    Assert(isalnum(102) ,"isalnum should be 1 for f");
}

void t_isalnum_0x67()
{
    Assert(isalnum(103) ,"isalnum should be 1 for g");
}

void t_isalnum_0x68()
{
    Assert(isalnum(104) ,"isalnum should be 1 for h");
}

void t_isalnum_0x69()
{
    Assert(isalnum(105) ,"isalnum should be 1 for i");
}

void t_isalnum_0x6a()
{
    Assert(isalnum(106) ,"isalnum should be 1 for j");
}

void t_isalnum_0x6b()
{
    Assert(isalnum(107) ,"isalnum should be 1 for k");
}

void t_isalnum_0x6c()
{
    Assert(isalnum(108) ,"isalnum should be 1 for l");
}

void t_isalnum_0x6d()
{
    Assert(isalnum(109) ,"isalnum should be 1 for m");
}

void t_isalnum_0x6e()
{
    Assert(isalnum(110) ,"isalnum should be 1 for n");
}

void t_isalnum_0x6f()
{
    Assert(isalnum(111) ,"isalnum should be 1 for o");
}

void t_isalnum_0x70()
{
    Assert(isalnum(112) ,"isalnum should be 1 for p");
}

void t_isalnum_0x71()
{
    Assert(isalnum(113) ,"isalnum should be 1 for q");
}

void t_isalnum_0x72()
{
    Assert(isalnum(114) ,"isalnum should be 1 for r");
}

void t_isalnum_0x73()
{
    Assert(isalnum(115) ,"isalnum should be 1 for s");
}

void t_isalnum_0x74()
{
    Assert(isalnum(116) ,"isalnum should be 1 for t");
}

void t_isalnum_0x75()
{
    Assert(isalnum(117) ,"isalnum should be 1 for u");
}

void t_isalnum_0x76()
{
    Assert(isalnum(118) ,"isalnum should be 1 for v");
}

void t_isalnum_0x77()
{
    Assert(isalnum(119) ,"isalnum should be 1 for w");
}

void t_isalnum_0x78()
{
    Assert(isalnum(120) ,"isalnum should be 1 for x");
}

void t_isalnum_0x79()
{
    Assert(isalnum(121) ,"isalnum should be 1 for y");
}

void t_isalnum_0x7a()
{
    Assert(isalnum(122) ,"isalnum should be 1 for z");
}

void t_isalnum_0x7b()
{
    Assert(isalnum(123)  == 0 ,"isalnum should be 0 for {");
}

void t_isalnum_0x7c()
{
    Assert(isalnum(124)  == 0 ,"isalnum should be 0 for |");
}

void t_isalnum_0x7d()
{
    Assert(isalnum(125)  == 0 ,"isalnum should be 0 for }");
}

void t_isalnum_0x7e()
{
    Assert(isalnum(126)  == 0 ,"isalnum should be 0 for ~");
}

void t_isalnum_0x7f()
{
    Assert(isalnum(127)  == 0 ,"isalnum should be 0 for 0x7f");
}

void t_isalnum_0x80()
{
    Assert(isalnum(128)  == 0 ,"isalnum should be 0 for 0x80");
}

void t_isalnum_0x81()
{
    Assert(isalnum(129)  == 0 ,"isalnum should be 0 for 0x81");
}

void t_isalnum_0x82()
{
    Assert(isalnum(130)  == 0 ,"isalnum should be 0 for 0x82");
}

void t_isalnum_0x83()
{
    Assert(isalnum(131)  == 0 ,"isalnum should be 0 for 0x83");
}

void t_isalnum_0x84()
{
    Assert(isalnum(132)  == 0 ,"isalnum should be 0 for 0x84");
}

void t_isalnum_0x85()
{
    Assert(isalnum(133)  == 0 ,"isalnum should be 0 for 0x85");
}

void t_isalnum_0x86()
{
    Assert(isalnum(134)  == 0 ,"isalnum should be 0 for 0x86");
}

void t_isalnum_0x87()
{
    Assert(isalnum(135)  == 0 ,"isalnum should be 0 for 0x87");
}

void t_isalnum_0x88()
{
    Assert(isalnum(136)  == 0 ,"isalnum should be 0 for 0x88");
}

void t_isalnum_0x89()
{
    Assert(isalnum(137)  == 0 ,"isalnum should be 0 for 0x89");
}

void t_isalnum_0x8a()
{
    Assert(isalnum(138)  == 0 ,"isalnum should be 0 for 0x8a");
}

void t_isalnum_0x8b()
{
    Assert(isalnum(139)  == 0 ,"isalnum should be 0 for 0x8b");
}

void t_isalnum_0x8c()
{
    Assert(isalnum(140)  == 0 ,"isalnum should be 0 for 0x8c");
}

void t_isalnum_0x8d()
{
    Assert(isalnum(141)  == 0 ,"isalnum should be 0 for 0x8d");
}

void t_isalnum_0x8e()
{
    Assert(isalnum(142)  == 0 ,"isalnum should be 0 for 0x8e");
}

void t_isalnum_0x8f()
{
    Assert(isalnum(143)  == 0 ,"isalnum should be 0 for 0x8f");
}

void t_isalnum_0x90()
{
    Assert(isalnum(144)  == 0 ,"isalnum should be 0 for 0x90");
}

void t_isalnum_0x91()
{
    Assert(isalnum(145)  == 0 ,"isalnum should be 0 for 0x91");
}

void t_isalnum_0x92()
{
    Assert(isalnum(146)  == 0 ,"isalnum should be 0 for 0x92");
}

void t_isalnum_0x93()
{
    Assert(isalnum(147)  == 0 ,"isalnum should be 0 for 0x93");
}

void t_isalnum_0x94()
{
    Assert(isalnum(148)  == 0 ,"isalnum should be 0 for 0x94");
}

void t_isalnum_0x95()
{
    Assert(isalnum(149)  == 0 ,"isalnum should be 0 for 0x95");
}

void t_isalnum_0x96()
{
    Assert(isalnum(150)  == 0 ,"isalnum should be 0 for 0x96");
}

void t_isalnum_0x97()
{
    Assert(isalnum(151)  == 0 ,"isalnum should be 0 for 0x97");
}

void t_isalnum_0x98()
{
    Assert(isalnum(152)  == 0 ,"isalnum should be 0 for 0x98");
}

void t_isalnum_0x99()
{
    Assert(isalnum(153)  == 0 ,"isalnum should be 0 for 0x99");
}

void t_isalnum_0x9a()
{
    Assert(isalnum(154)  == 0 ,"isalnum should be 0 for 0x9a");
}

void t_isalnum_0x9b()
{
    Assert(isalnum(155)  == 0 ,"isalnum should be 0 for 0x9b");
}

void t_isalnum_0x9c()
{
    Assert(isalnum(156)  == 0 ,"isalnum should be 0 for 0x9c");
}

void t_isalnum_0x9d()
{
    Assert(isalnum(157)  == 0 ,"isalnum should be 0 for 0x9d");
}

void t_isalnum_0x9e()
{
    Assert(isalnum(158)  == 0 ,"isalnum should be 0 for 0x9e");
}

void t_isalnum_0x9f()
{
    Assert(isalnum(159)  == 0 ,"isalnum should be 0 for 0x9f");
}

void t_isalnum_0xa0()
{
    Assert(isalnum(160)  == 0 ,"isalnum should be 0 for 0xa0");
}

void t_isalnum_0xa1()
{
    Assert(isalnum(161)  == 0 ,"isalnum should be 0 for 0xa1");
}

void t_isalnum_0xa2()
{
    Assert(isalnum(162)  == 0 ,"isalnum should be 0 for 0xa2");
}

void t_isalnum_0xa3()
{
    Assert(isalnum(163)  == 0 ,"isalnum should be 0 for 0xa3");
}

void t_isalnum_0xa4()
{
    Assert(isalnum(164)  == 0 ,"isalnum should be 0 for 0xa4");
}

void t_isalnum_0xa5()
{
    Assert(isalnum(165)  == 0 ,"isalnum should be 0 for 0xa5");
}

void t_isalnum_0xa6()
{
    Assert(isalnum(166)  == 0 ,"isalnum should be 0 for 0xa6");
}

void t_isalnum_0xa7()
{
    Assert(isalnum(167)  == 0 ,"isalnum should be 0 for 0xa7");
}

void t_isalnum_0xa8()
{
    Assert(isalnum(168)  == 0 ,"isalnum should be 0 for 0xa8");
}

void t_isalnum_0xa9()
{
    Assert(isalnum(169)  == 0 ,"isalnum should be 0 for 0xa9");
}

void t_isalnum_0xaa()
{
    Assert(isalnum(170)  == 0 ,"isalnum should be 0 for 0xaa");
}

void t_isalnum_0xab()
{
    Assert(isalnum(171)  == 0 ,"isalnum should be 0 for 0xab");
}

void t_isalnum_0xac()
{
    Assert(isalnum(172)  == 0 ,"isalnum should be 0 for 0xac");
}

void t_isalnum_0xad()
{
    Assert(isalnum(173)  == 0 ,"isalnum should be 0 for 0xad");
}

void t_isalnum_0xae()
{
    Assert(isalnum(174)  == 0 ,"isalnum should be 0 for 0xae");
}

void t_isalnum_0xaf()
{
    Assert(isalnum(175)  == 0 ,"isalnum should be 0 for 0xaf");
}

void t_isalnum_0xb0()
{
    Assert(isalnum(176)  == 0 ,"isalnum should be 0 for 0xb0");
}

void t_isalnum_0xb1()
{
    Assert(isalnum(177)  == 0 ,"isalnum should be 0 for 0xb1");
}

void t_isalnum_0xb2()
{
    Assert(isalnum(178)  == 0 ,"isalnum should be 0 for 0xb2");
}

void t_isalnum_0xb3()
{
    Assert(isalnum(179)  == 0 ,"isalnum should be 0 for 0xb3");
}

void t_isalnum_0xb4()
{
    Assert(isalnum(180)  == 0 ,"isalnum should be 0 for 0xb4");
}

void t_isalnum_0xb5()
{
    Assert(isalnum(181)  == 0 ,"isalnum should be 0 for 0xb5");
}

void t_isalnum_0xb6()
{
    Assert(isalnum(182)  == 0 ,"isalnum should be 0 for 0xb6");
}

void t_isalnum_0xb7()
{
    Assert(isalnum(183)  == 0 ,"isalnum should be 0 for 0xb7");
}

void t_isalnum_0xb8()
{
    Assert(isalnum(184)  == 0 ,"isalnum should be 0 for 0xb8");
}

void t_isalnum_0xb9()
{
    Assert(isalnum(185)  == 0 ,"isalnum should be 0 for 0xb9");
}

void t_isalnum_0xba()
{
    Assert(isalnum(186)  == 0 ,"isalnum should be 0 for 0xba");
}

void t_isalnum_0xbb()
{
    Assert(isalnum(187)  == 0 ,"isalnum should be 0 for 0xbb");
}

void t_isalnum_0xbc()
{
    Assert(isalnum(188)  == 0 ,"isalnum should be 0 for 0xbc");
}

void t_isalnum_0xbd()
{
    Assert(isalnum(189)  == 0 ,"isalnum should be 0 for 0xbd");
}

void t_isalnum_0xbe()
{
    Assert(isalnum(190)  == 0 ,"isalnum should be 0 for 0xbe");
}

void t_isalnum_0xbf()
{
    Assert(isalnum(191)  == 0 ,"isalnum should be 0 for 0xbf");
}

void t_isalnum_0xc0()
{
    Assert(isalnum(192)  == 0 ,"isalnum should be 0 for 0xc0");
}

void t_isalnum_0xc1()
{
    Assert(isalnum(193)  == 0 ,"isalnum should be 0 for 0xc1");
}

void t_isalnum_0xc2()
{
    Assert(isalnum(194)  == 0 ,"isalnum should be 0 for 0xc2");
}

void t_isalnum_0xc3()
{
    Assert(isalnum(195)  == 0 ,"isalnum should be 0 for 0xc3");
}

void t_isalnum_0xc4()
{
    Assert(isalnum(196)  == 0 ,"isalnum should be 0 for 0xc4");
}

void t_isalnum_0xc5()
{
    Assert(isalnum(197)  == 0 ,"isalnum should be 0 for 0xc5");
}

void t_isalnum_0xc6()
{
    Assert(isalnum(198)  == 0 ,"isalnum should be 0 for 0xc6");
}

void t_isalnum_0xc7()
{
    Assert(isalnum(199)  == 0 ,"isalnum should be 0 for 0xc7");
}

void t_isalnum_0xc8()
{
    Assert(isalnum(200)  == 0 ,"isalnum should be 0 for 0xc8");
}

void t_isalnum_0xc9()
{
    Assert(isalnum(201)  == 0 ,"isalnum should be 0 for 0xc9");
}

void t_isalnum_0xca()
{
    Assert(isalnum(202)  == 0 ,"isalnum should be 0 for 0xca");
}

void t_isalnum_0xcb()
{
    Assert(isalnum(203)  == 0 ,"isalnum should be 0 for 0xcb");
}

void t_isalnum_0xcc()
{
    Assert(isalnum(204)  == 0 ,"isalnum should be 0 for 0xcc");
}

void t_isalnum_0xcd()
{
    Assert(isalnum(205)  == 0 ,"isalnum should be 0 for 0xcd");
}

void t_isalnum_0xce()
{
    Assert(isalnum(206)  == 0 ,"isalnum should be 0 for 0xce");
}

void t_isalnum_0xcf()
{
    Assert(isalnum(207)  == 0 ,"isalnum should be 0 for 0xcf");
}

void t_isalnum_0xd0()
{
    Assert(isalnum(208)  == 0 ,"isalnum should be 0 for 0xd0");
}

void t_isalnum_0xd1()
{
    Assert(isalnum(209)  == 0 ,"isalnum should be 0 for 0xd1");
}

void t_isalnum_0xd2()
{
    Assert(isalnum(210)  == 0 ,"isalnum should be 0 for 0xd2");
}

void t_isalnum_0xd3()
{
    Assert(isalnum(211)  == 0 ,"isalnum should be 0 for 0xd3");
}

void t_isalnum_0xd4()
{
    Assert(isalnum(212)  == 0 ,"isalnum should be 0 for 0xd4");
}

void t_isalnum_0xd5()
{
    Assert(isalnum(213)  == 0 ,"isalnum should be 0 for 0xd5");
}

void t_isalnum_0xd6()
{
    Assert(isalnum(214)  == 0 ,"isalnum should be 0 for 0xd6");
}

void t_isalnum_0xd7()
{
    Assert(isalnum(215)  == 0 ,"isalnum should be 0 for 0xd7");
}

void t_isalnum_0xd8()
{
    Assert(isalnum(216)  == 0 ,"isalnum should be 0 for 0xd8");
}

void t_isalnum_0xd9()
{
    Assert(isalnum(217)  == 0 ,"isalnum should be 0 for 0xd9");
}

void t_isalnum_0xda()
{
    Assert(isalnum(218)  == 0 ,"isalnum should be 0 for 0xda");
}

void t_isalnum_0xdb()
{
    Assert(isalnum(219)  == 0 ,"isalnum should be 0 for 0xdb");
}

void t_isalnum_0xdc()
{
    Assert(isalnum(220)  == 0 ,"isalnum should be 0 for 0xdc");
}

void t_isalnum_0xdd()
{
    Assert(isalnum(221)  == 0 ,"isalnum should be 0 for 0xdd");
}

void t_isalnum_0xde()
{
    Assert(isalnum(222)  == 0 ,"isalnum should be 0 for 0xde");
}

void t_isalnum_0xdf()
{
    Assert(isalnum(223)  == 0 ,"isalnum should be 0 for 0xdf");
}

void t_isalnum_0xe0()
{
    Assert(isalnum(224)  == 0 ,"isalnum should be 0 for 0xe0");
}

void t_isalnum_0xe1()
{
    Assert(isalnum(225)  == 0 ,"isalnum should be 0 for 0xe1");
}

void t_isalnum_0xe2()
{
    Assert(isalnum(226)  == 0 ,"isalnum should be 0 for 0xe2");
}

void t_isalnum_0xe3()
{
    Assert(isalnum(227)  == 0 ,"isalnum should be 0 for 0xe3");
}

void t_isalnum_0xe4()
{
    Assert(isalnum(228)  == 0 ,"isalnum should be 0 for 0xe4");
}

void t_isalnum_0xe5()
{
    Assert(isalnum(229)  == 0 ,"isalnum should be 0 for 0xe5");
}

void t_isalnum_0xe6()
{
    Assert(isalnum(230)  == 0 ,"isalnum should be 0 for 0xe6");
}

void t_isalnum_0xe7()
{
    Assert(isalnum(231)  == 0 ,"isalnum should be 0 for 0xe7");
}

void t_isalnum_0xe8()
{
    Assert(isalnum(232)  == 0 ,"isalnum should be 0 for 0xe8");
}

void t_isalnum_0xe9()
{
    Assert(isalnum(233)  == 0 ,"isalnum should be 0 for 0xe9");
}

void t_isalnum_0xea()
{
    Assert(isalnum(234)  == 0 ,"isalnum should be 0 for 0xea");
}

void t_isalnum_0xeb()
{
    Assert(isalnum(235)  == 0 ,"isalnum should be 0 for 0xeb");
}

void t_isalnum_0xec()
{
    Assert(isalnum(236)  == 0 ,"isalnum should be 0 for 0xec");
}

void t_isalnum_0xed()
{
    Assert(isalnum(237)  == 0 ,"isalnum should be 0 for 0xed");
}

void t_isalnum_0xee()
{
    Assert(isalnum(238)  == 0 ,"isalnum should be 0 for 0xee");
}

void t_isalnum_0xef()
{
    Assert(isalnum(239)  == 0 ,"isalnum should be 0 for 0xef");
}

void t_isalnum_0xf0()
{
    Assert(isalnum(240)  == 0 ,"isalnum should be 0 for 0xf0");
}

void t_isalnum_0xf1()
{
    Assert(isalnum(241)  == 0 ,"isalnum should be 0 for 0xf1");
}

void t_isalnum_0xf2()
{
    Assert(isalnum(242)  == 0 ,"isalnum should be 0 for 0xf2");
}

void t_isalnum_0xf3()
{
    Assert(isalnum(243)  == 0 ,"isalnum should be 0 for 0xf3");
}

void t_isalnum_0xf4()
{
    Assert(isalnum(244)  == 0 ,"isalnum should be 0 for 0xf4");
}

void t_isalnum_0xf5()
{
    Assert(isalnum(245)  == 0 ,"isalnum should be 0 for 0xf5");
}

void t_isalnum_0xf6()
{
    Assert(isalnum(246)  == 0 ,"isalnum should be 0 for 0xf6");
}

void t_isalnum_0xf7()
{
    Assert(isalnum(247)  == 0 ,"isalnum should be 0 for 0xf7");
}

void t_isalnum_0xf8()
{
    Assert(isalnum(248)  == 0 ,"isalnum should be 0 for 0xf8");
}

void t_isalnum_0xf9()
{
    Assert(isalnum(249)  == 0 ,"isalnum should be 0 for 0xf9");
}

void t_isalnum_0xfa()
{
    Assert(isalnum(250)  == 0 ,"isalnum should be 0 for 0xfa");
}

void t_isalnum_0xfb()
{
    Assert(isalnum(251)  == 0 ,"isalnum should be 0 for 0xfb");
}

void t_isalnum_0xfc()
{
    Assert(isalnum(252)  == 0 ,"isalnum should be 0 for 0xfc");
}

void t_isalnum_0xfd()
{
    Assert(isalnum(253)  == 0 ,"isalnum should be 0 for 0xfd");
}

void t_isalnum_0xfe()
{
    Assert(isalnum(254)  == 0 ,"isalnum should be 0 for 0xfe");
}

void t_isalnum_0xff()
{
    Assert(isalnum(255)  == 0 ,"isalnum should be 0 for 0xff");
}



int test_isalnum()
{
    suite_setup("isalnum");
    suite_add_test(t_isalnum_0x00);
    suite_add_test(t_isalnum_0x01);
    suite_add_test(t_isalnum_0x02);
    suite_add_test(t_isalnum_0x03);
    suite_add_test(t_isalnum_0x04);
    suite_add_test(t_isalnum_0x05);
    suite_add_test(t_isalnum_0x06);
    suite_add_test(t_isalnum_0x07);
    suite_add_test(t_isalnum_0x08);
    suite_add_test(t_isalnum_0x09);
    suite_add_test(t_isalnum_0x0a);
    suite_add_test(t_isalnum_0x0b);
    suite_add_test(t_isalnum_0x0c);
    suite_add_test(t_isalnum_0x0d);
    suite_add_test(t_isalnum_0x0e);
    suite_add_test(t_isalnum_0x0f);
    suite_add_test(t_isalnum_0x10);
    suite_add_test(t_isalnum_0x11);
    suite_add_test(t_isalnum_0x12);
    suite_add_test(t_isalnum_0x13);
    suite_add_test(t_isalnum_0x14);
    suite_add_test(t_isalnum_0x15);
    suite_add_test(t_isalnum_0x16);
    suite_add_test(t_isalnum_0x17);
    suite_add_test(t_isalnum_0x18);
    suite_add_test(t_isalnum_0x19);
    suite_add_test(t_isalnum_0x1a);
    suite_add_test(t_isalnum_0x1b);
    suite_add_test(t_isalnum_0x1c);
    suite_add_test(t_isalnum_0x1d);
    suite_add_test(t_isalnum_0x1e);
    suite_add_test(t_isalnum_0x1f);
    suite_add_test(t_isalnum_0x20);
    suite_add_test(t_isalnum_0x21);
    suite_add_test(t_isalnum_0x22);
    suite_add_test(t_isalnum_0x23);
    suite_add_test(t_isalnum_0x24);
    suite_add_test(t_isalnum_0x25);
    suite_add_test(t_isalnum_0x26);
    suite_add_test(t_isalnum_0x27);
    suite_add_test(t_isalnum_0x28);
    suite_add_test(t_isalnum_0x29);
    suite_add_test(t_isalnum_0x2a);
    suite_add_test(t_isalnum_0x2b);
    suite_add_test(t_isalnum_0x2c);
    suite_add_test(t_isalnum_0x2d);
    suite_add_test(t_isalnum_0x2e);
    suite_add_test(t_isalnum_0x2f);
    suite_add_test(t_isalnum_0x30);
    suite_add_test(t_isalnum_0x31);
    suite_add_test(t_isalnum_0x32);
    suite_add_test(t_isalnum_0x33);
    suite_add_test(t_isalnum_0x34);
    suite_add_test(t_isalnum_0x35);
    suite_add_test(t_isalnum_0x36);
    suite_add_test(t_isalnum_0x37);
    suite_add_test(t_isalnum_0x38);
    suite_add_test(t_isalnum_0x39);
    suite_add_test(t_isalnum_0x3a);
    suite_add_test(t_isalnum_0x3b);
    suite_add_test(t_isalnum_0x3c);
    suite_add_test(t_isalnum_0x3d);
    suite_add_test(t_isalnum_0x3e);
    suite_add_test(t_isalnum_0x3f);
    suite_add_test(t_isalnum_0x40);
    suite_add_test(t_isalnum_0x41);
    suite_add_test(t_isalnum_0x42);
    suite_add_test(t_isalnum_0x43);
    suite_add_test(t_isalnum_0x44);
    suite_add_test(t_isalnum_0x45);
    suite_add_test(t_isalnum_0x46);
    suite_add_test(t_isalnum_0x47);
    suite_add_test(t_isalnum_0x48);
    suite_add_test(t_isalnum_0x49);
    suite_add_test(t_isalnum_0x4a);
    suite_add_test(t_isalnum_0x4b);
    suite_add_test(t_isalnum_0x4c);
    suite_add_test(t_isalnum_0x4d);
    suite_add_test(t_isalnum_0x4e);
    suite_add_test(t_isalnum_0x4f);
    suite_add_test(t_isalnum_0x50);
    suite_add_test(t_isalnum_0x51);
    suite_add_test(t_isalnum_0x52);
    suite_add_test(t_isalnum_0x53);
    suite_add_test(t_isalnum_0x54);
    suite_add_test(t_isalnum_0x55);
    suite_add_test(t_isalnum_0x56);
    suite_add_test(t_isalnum_0x57);
    suite_add_test(t_isalnum_0x58);
    suite_add_test(t_isalnum_0x59);
    suite_add_test(t_isalnum_0x5a);
    suite_add_test(t_isalnum_0x5b);
    suite_add_test(t_isalnum_0x5c);
    suite_add_test(t_isalnum_0x5d);
    suite_add_test(t_isalnum_0x5e);
    suite_add_test(t_isalnum_0x5f);
    suite_add_test(t_isalnum_0x60);
    suite_add_test(t_isalnum_0x61);
    suite_add_test(t_isalnum_0x62);
    suite_add_test(t_isalnum_0x63);
    suite_add_test(t_isalnum_0x64);
    suite_add_test(t_isalnum_0x65);
    suite_add_test(t_isalnum_0x66);
    suite_add_test(t_isalnum_0x67);
    suite_add_test(t_isalnum_0x68);
    suite_add_test(t_isalnum_0x69);
    suite_add_test(t_isalnum_0x6a);
    suite_add_test(t_isalnum_0x6b);
    suite_add_test(t_isalnum_0x6c);
    suite_add_test(t_isalnum_0x6d);
    suite_add_test(t_isalnum_0x6e);
    suite_add_test(t_isalnum_0x6f);
    suite_add_test(t_isalnum_0x70);
    suite_add_test(t_isalnum_0x71);
    suite_add_test(t_isalnum_0x72);
    suite_add_test(t_isalnum_0x73);
    suite_add_test(t_isalnum_0x74);
    suite_add_test(t_isalnum_0x75);
    suite_add_test(t_isalnum_0x76);
    suite_add_test(t_isalnum_0x77);
    suite_add_test(t_isalnum_0x78);
    suite_add_test(t_isalnum_0x79);
    suite_add_test(t_isalnum_0x7a);
    suite_add_test(t_isalnum_0x7b);
    suite_add_test(t_isalnum_0x7c);
    suite_add_test(t_isalnum_0x7d);
    suite_add_test(t_isalnum_0x7e);
    suite_add_test(t_isalnum_0x7f);
    suite_add_test(t_isalnum_0x80);
    suite_add_test(t_isalnum_0x81);
    suite_add_test(t_isalnum_0x82);
    suite_add_test(t_isalnum_0x83);
    suite_add_test(t_isalnum_0x84);
    suite_add_test(t_isalnum_0x85);
    suite_add_test(t_isalnum_0x86);
    suite_add_test(t_isalnum_0x87);
    suite_add_test(t_isalnum_0x88);
    suite_add_test(t_isalnum_0x89);
    suite_add_test(t_isalnum_0x8a);
    suite_add_test(t_isalnum_0x8b);
    suite_add_test(t_isalnum_0x8c);
    suite_add_test(t_isalnum_0x8d);
    suite_add_test(t_isalnum_0x8e);
    suite_add_test(t_isalnum_0x8f);
    suite_add_test(t_isalnum_0x90);
    suite_add_test(t_isalnum_0x91);
    suite_add_test(t_isalnum_0x92);
    suite_add_test(t_isalnum_0x93);
    suite_add_test(t_isalnum_0x94);
    suite_add_test(t_isalnum_0x95);
    suite_add_test(t_isalnum_0x96);
    suite_add_test(t_isalnum_0x97);
    suite_add_test(t_isalnum_0x98);
    suite_add_test(t_isalnum_0x99);
    suite_add_test(t_isalnum_0x9a);
    suite_add_test(t_isalnum_0x9b);
    suite_add_test(t_isalnum_0x9c);
    suite_add_test(t_isalnum_0x9d);
    suite_add_test(t_isalnum_0x9e);
    suite_add_test(t_isalnum_0x9f);
    suite_add_test(t_isalnum_0xa0);
    suite_add_test(t_isalnum_0xa1);
    suite_add_test(t_isalnum_0xa2);
    suite_add_test(t_isalnum_0xa3);
    suite_add_test(t_isalnum_0xa4);
    suite_add_test(t_isalnum_0xa5);
    suite_add_test(t_isalnum_0xa6);
    suite_add_test(t_isalnum_0xa7);
    suite_add_test(t_isalnum_0xa8);
    suite_add_test(t_isalnum_0xa9);
    suite_add_test(t_isalnum_0xaa);
    suite_add_test(t_isalnum_0xab);
    suite_add_test(t_isalnum_0xac);
    suite_add_test(t_isalnum_0xad);
    suite_add_test(t_isalnum_0xae);
    suite_add_test(t_isalnum_0xaf);
    suite_add_test(t_isalnum_0xb0);
    suite_add_test(t_isalnum_0xb1);
    suite_add_test(t_isalnum_0xb2);
    suite_add_test(t_isalnum_0xb3);
    suite_add_test(t_isalnum_0xb4);
    suite_add_test(t_isalnum_0xb5);
    suite_add_test(t_isalnum_0xb6);
    suite_add_test(t_isalnum_0xb7);
    suite_add_test(t_isalnum_0xb8);
    suite_add_test(t_isalnum_0xb9);
    suite_add_test(t_isalnum_0xba);
    suite_add_test(t_isalnum_0xbb);
    suite_add_test(t_isalnum_0xbc);
    suite_add_test(t_isalnum_0xbd);
    suite_add_test(t_isalnum_0xbe);
    suite_add_test(t_isalnum_0xbf);
    suite_add_test(t_isalnum_0xc0);
    suite_add_test(t_isalnum_0xc1);
    suite_add_test(t_isalnum_0xc2);
    suite_add_test(t_isalnum_0xc3);
    suite_add_test(t_isalnum_0xc4);
    suite_add_test(t_isalnum_0xc5);
    suite_add_test(t_isalnum_0xc6);
    suite_add_test(t_isalnum_0xc7);
    suite_add_test(t_isalnum_0xc8);
    suite_add_test(t_isalnum_0xc9);
    suite_add_test(t_isalnum_0xca);
    suite_add_test(t_isalnum_0xcb);
    suite_add_test(t_isalnum_0xcc);
    suite_add_test(t_isalnum_0xcd);
    suite_add_test(t_isalnum_0xce);
    suite_add_test(t_isalnum_0xcf);
    suite_add_test(t_isalnum_0xd0);
    suite_add_test(t_isalnum_0xd1);
    suite_add_test(t_isalnum_0xd2);
    suite_add_test(t_isalnum_0xd3);
    suite_add_test(t_isalnum_0xd4);
    suite_add_test(t_isalnum_0xd5);
    suite_add_test(t_isalnum_0xd6);
    suite_add_test(t_isalnum_0xd7);
    suite_add_test(t_isalnum_0xd8);
    suite_add_test(t_isalnum_0xd9);
    suite_add_test(t_isalnum_0xda);
    suite_add_test(t_isalnum_0xdb);
    suite_add_test(t_isalnum_0xdc);
    suite_add_test(t_isalnum_0xdd);
    suite_add_test(t_isalnum_0xde);
    suite_add_test(t_isalnum_0xdf);
    suite_add_test(t_isalnum_0xe0);
    suite_add_test(t_isalnum_0xe1);
    suite_add_test(t_isalnum_0xe2);
    suite_add_test(t_isalnum_0xe3);
    suite_add_test(t_isalnum_0xe4);
    suite_add_test(t_isalnum_0xe5);
    suite_add_test(t_isalnum_0xe6);
    suite_add_test(t_isalnum_0xe7);
    suite_add_test(t_isalnum_0xe8);
    suite_add_test(t_isalnum_0xe9);
    suite_add_test(t_isalnum_0xea);
    suite_add_test(t_isalnum_0xeb);
    suite_add_test(t_isalnum_0xec);
    suite_add_test(t_isalnum_0xed);
    suite_add_test(t_isalnum_0xee);
    suite_add_test(t_isalnum_0xef);
    suite_add_test(t_isalnum_0xf0);
    suite_add_test(t_isalnum_0xf1);
    suite_add_test(t_isalnum_0xf2);
    suite_add_test(t_isalnum_0xf3);
    suite_add_test(t_isalnum_0xf4);
    suite_add_test(t_isalnum_0xf5);
    suite_add_test(t_isalnum_0xf6);
    suite_add_test(t_isalnum_0xf7);
    suite_add_test(t_isalnum_0xf8);
    suite_add_test(t_isalnum_0xf9);
    suite_add_test(t_isalnum_0xfa);
    suite_add_test(t_isalnum_0xfb);
    suite_add_test(t_isalnum_0xfc);
    suite_add_test(t_isalnum_0xfd);
    suite_add_test(t_isalnum_0xfe);
    suite_add_test(t_isalnum_0xff);
     return suite_run();
}
