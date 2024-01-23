//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../z80asm.h"
#include "test.h"

void create_f1_asm() {
    test_file_spew("f1.asm", "");
    test_file_write("x1.lib", (const byte_t*)"Z80LMF18\0\0\0\0", 12);
    test_file_write("x2.lib", (const byte_t*)"Z80LMF18\0\0\0\0", 12);
}

void remove_f1_asm() {
    remove("f1.asm");
    remove("x1.lib");
    remove("x2.lib");
}

void test_cpu_lookup_int() {
    CpuId cpu;

    cpu = cpu_lookup(-1); IS(cpu, CpuId::undef);
	cpu = cpu_lookup(0); IS(cpu, CpuId::undef);
	cpu = cpu_lookup(1); IS(cpu, CpuId::z80);
	cpu = cpu_lookup(2); IS(cpu, CpuId::z80_strict);
	cpu = cpu_lookup(3); IS(cpu, CpuId::z180);
	cpu = cpu_lookup(4); IS(cpu, CpuId::ez80_z80);
	cpu = cpu_lookup(5); IS(cpu, CpuId::ez80);
	cpu = cpu_lookup(6); IS(cpu, CpuId::z80n);
	cpu = cpu_lookup(7); IS(cpu, CpuId::r2ka);
	cpu = cpu_lookup(8); IS(cpu, CpuId::r3k);
	cpu = cpu_lookup(9); IS(cpu, CpuId::gbz80);
	cpu = cpu_lookup(10); IS(cpu, CpuId::i8080);
	cpu = cpu_lookup(11); IS(cpu, CpuId::i8085);
	cpu = cpu_lookup(12); IS(cpu, CpuId::r800);
	cpu = cpu_lookup(13); IS(cpu, CpuId::r4k);
	cpu = cpu_lookup(14); IS(cpu, CpuId::r5k);
	cpu = cpu_lookup(15); IS(cpu, CpuId::kc160);
	cpu = cpu_lookup(16); IS(cpu, CpuId::kc160_z80);
    cpu = cpu_lookup(17); IS(cpu, CpuId::undef);
}

void test_cpu_lookup_string() {
    CpuId cpu;

    cpu = cpu_lookup(""); IS(cpu, CpuId::undef);
    cpu = cpu_lookup("xpto"); IS(cpu, CpuId::undef);
    cpu = cpu_lookup("z80"); IS(cpu, CpuId::z80);
    cpu = cpu_lookup("z80_strict"); IS(cpu, CpuId::z80_strict);
    cpu = cpu_lookup("z180"); IS(cpu, CpuId::z180);
    cpu = cpu_lookup("ez80_z80"); IS(cpu, CpuId::ez80_z80);
    cpu = cpu_lookup("ez80"); IS(cpu, CpuId::ez80);
    cpu = cpu_lookup("z80n"); IS(cpu, CpuId::z80n);
    cpu = cpu_lookup("r2ka"); IS(cpu, CpuId::r2ka);
    cpu = cpu_lookup("r3k"); IS(cpu, CpuId::r3k);
    cpu = cpu_lookup("gbz80"); IS(cpu, CpuId::gbz80);
    cpu = cpu_lookup("8080"); IS(cpu, CpuId::i8080);
    cpu = cpu_lookup("8085"); IS(cpu, CpuId::i8085);
    cpu = cpu_lookup("r800"); IS(cpu, CpuId::r800);
    cpu = cpu_lookup("r4k"); IS(cpu, CpuId::r4k);
    cpu = cpu_lookup("r5k"); IS(cpu, CpuId::r5k);
    cpu = cpu_lookup("kc160"); IS(cpu, CpuId::kc160);
    cpu = cpu_lookup("kc160_z80"); IS(cpu, CpuId::kc160_z80);
}

void test_cpu_name() {
    STR_IS(cpu_name(CpuId::undef), "");
    STR_IS(cpu_name(CpuId::z80), "z80");
    STR_IS(cpu_name(CpuId::z80_strict), "z80_strict");
    STR_IS(cpu_name(CpuId::z180), "z180");
    STR_IS(cpu_name(CpuId::ez80_z80), "ez80_z80");
    STR_IS(cpu_name(CpuId::ez80), "ez80");
    STR_IS(cpu_name(CpuId::z80n), "z80n");
    STR_IS(cpu_name(CpuId::r2ka), "r2ka");
    STR_IS(cpu_name(CpuId::r3k), "r3k");
    STR_IS(cpu_name(CpuId::gbz80), "gbz80");
    STR_IS(cpu_name(CpuId::i8080), "8080");
    STR_IS(cpu_name(CpuId::i8085), "8085");
    STR_IS(cpu_name(CpuId::r800), "r800");
    STR_IS(cpu_name(CpuId::r4k), "r4k");
    STR_IS(cpu_name(CpuId::r5k), "r5k");
    STR_IS(cpu_name(CpuId::kc160), "kc160");
    STR_IS(cpu_name(CpuId::kc160_z80), "kc160_z80");
}

void test_cpu_all_defines() {
    vector<string> defines = cpu_all_defines();
    IS(defines.size(), static_cast<size_t>(28));
    STR_IS(defines[0], "__CPU_Z80__");
    STR_IS(defines[1], "__CPU_ZILOG__");
    STR_IS(defines[2], "__CPU_Z80_STRICT__");
    STR_IS(defines[3], "__CPU_ZILOG__");
    STR_IS(defines[4], "__CPU_Z180__");
    STR_IS(defines[5], "__CPU_ZILOG__");
    STR_IS(defines[6], "__CPU_EZ80_Z80__");
    STR_IS(defines[7], "__CPU_ZILOG__");
    STR_IS(defines[8], "__CPU_EZ80__");
    STR_IS(defines[9], "__CPU_ZILOG__");
    STR_IS(defines[10], "__CPU_Z80N__");
    STR_IS(defines[11], "__CPU_ZILOG__");
    STR_IS(defines[12], "__CPU_R2KA__");
    STR_IS(defines[13], "__CPU_RABBIT__");
    STR_IS(defines[14], "__CPU_R3K__");
    STR_IS(defines[15], "__CPU_RABBIT__");
    STR_IS(defines[16], "__CPU_GBZ80__");
    STR_IS(defines[17], "__CPU_8080__");
    STR_IS(defines[18], "__CPU_INTEL__");
    STR_IS(defines[19], "__CPU_8085__");
    STR_IS(defines[20], "__CPU_INTEL__");
    STR_IS(defines[21], "__CPU_R800__");
    STR_IS(defines[22], "__CPU_R4K__");
    STR_IS(defines[23], "__CPU_RABBIT__");
    STR_IS(defines[24], "__CPU_R5K__");
    STR_IS(defines[25], "__CPU_RABBIT__");
    STR_IS(defines[26], "__CPU_KC160__");
    STR_IS(defines[27], "__CPU_KC160_Z80__");
}

void test_cpu_defines() {
    vector<string> defines;

    defines = cpu_defines(CpuId::undef);
    IS(defines.size(), static_cast<size_t>(0));

    defines = cpu_defines(CpuId::z80);
    IS(defines.size(), static_cast<size_t>(2));
    STR_IS(defines[0], "__CPU_Z80__");
    STR_IS(defines[1], "__CPU_ZILOG__");

    defines = cpu_defines(CpuId::z80_strict);
    IS(defines.size(), static_cast<size_t>(2));
    STR_IS(defines[0], "__CPU_Z80_STRICT__");
    STR_IS(defines[1], "__CPU_ZILOG__");

    defines = cpu_defines(CpuId::z180);
    IS(defines.size(), static_cast<size_t>(2));
    STR_IS(defines[0], "__CPU_Z180__");
    STR_IS(defines[1], "__CPU_ZILOG__");

    defines = cpu_defines(CpuId::ez80_z80);
    IS(defines.size(), static_cast<size_t>(2));
    STR_IS(defines[0], "__CPU_EZ80_Z80__");
    STR_IS(defines[1], "__CPU_ZILOG__");

    defines = cpu_defines(CpuId::ez80);
    IS(defines.size(), static_cast<size_t>(2));
    STR_IS(defines[0], "__CPU_EZ80__");
    STR_IS(defines[1], "__CPU_ZILOG__");

    defines = cpu_defines(CpuId::z80n);
    IS(defines.size(), static_cast<size_t>(2));
    STR_IS(defines[0], "__CPU_Z80N__");
    STR_IS(defines[1], "__CPU_ZILOG__");

    defines = cpu_defines(CpuId::r2ka);
    IS(defines.size(), static_cast<size_t>(2));
    STR_IS(defines[0], "__CPU_R2KA__");
    STR_IS(defines[1], "__CPU_RABBIT__");

    defines = cpu_defines(CpuId::r3k);
    IS(defines.size(), static_cast<size_t>(2));
    STR_IS(defines[0], "__CPU_R3K__");
    STR_IS(defines[1], "__CPU_RABBIT__");

    defines = cpu_defines(CpuId::gbz80);
    IS(defines.size(), static_cast<size_t>(1));
    STR_IS(defines[0], "__CPU_GBZ80__");

    defines = cpu_defines(CpuId::i8080);
    IS(defines.size(), static_cast<size_t>(2));
    STR_IS(defines[0], "__CPU_8080__");
    STR_IS(defines[1], "__CPU_INTEL__");

    defines = cpu_defines(CpuId::i8085);
    IS(defines.size(), static_cast<size_t>(2));
    STR_IS(defines[0], "__CPU_8085__");
    STR_IS(defines[1], "__CPU_INTEL__");

    defines = cpu_defines(CpuId::r800);
    IS(defines.size(), static_cast<size_t>(1));
    STR_IS(defines[0], "__CPU_R800__");

    defines = cpu_defines(CpuId::r4k);
    IS(defines.size(), static_cast<size_t>(2));
    STR_IS(defines[0], "__CPU_R4K__");
    STR_IS(defines[1], "__CPU_RABBIT__");

    defines = cpu_defines(CpuId::r5k);
    IS(defines.size(), static_cast<size_t>(2));
    STR_IS(defines[0], "__CPU_R5K__");
    STR_IS(defines[1], "__CPU_RABBIT__");

    defines = cpu_defines(CpuId::kc160);
    IS(defines.size(), static_cast<size_t>(1));
    STR_IS(defines[0], "__CPU_KC160__");

    defines = cpu_defines(CpuId::kc160_z80);
    IS(defines.size(), static_cast<size_t>(1));
    STR_IS(defines[0], "__CPU_KC160_Z80__");
}

void test_cpu_all_cpus() {
    const vector<CpuId>& cpus = cpu_all_cpus();
    IS(cpus.size(), static_cast<size_t>(16));
    IS(cpus[0], CpuId::z80n);
    IS(cpus[1], CpuId::z80);
    IS(cpus[2], CpuId::z180);
    IS(cpus[3], CpuId::r800);
    IS(cpus[4], CpuId::kc160_z80);
    IS(cpus[5], CpuId::z80_strict);
    IS(cpus[6], CpuId::r3k);
    IS(cpus[7], CpuId::i8085);
    IS(cpus[8], CpuId::r5k);
    IS(cpus[9], CpuId::ez80_z80);
    IS(cpus[10], CpuId::ez80);
    IS(cpus[11], CpuId::r2ka);
    IS(cpus[12], CpuId::gbz80);
    IS(cpus[13], CpuId::i8080);
    IS(cpus[14], CpuId::r4k);
    IS(cpus[15], CpuId::kc160);
}

void test_cpu_compatible() {
    OK(cpu_compatible(CpuId::z80, CpuId::z80));
    OK(cpu_compatible(CpuId::z80, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::z80, CpuId::z180));
    NOK(cpu_compatible(CpuId::z80, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::z80, CpuId::ez80));
    NOK(cpu_compatible(CpuId::z80, CpuId::z80n));
    NOK(cpu_compatible(CpuId::z80, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::z80, CpuId::r3k));
    NOK(cpu_compatible(CpuId::z80, CpuId::gbz80));
    OK(cpu_compatible(CpuId::z80, CpuId::i8080));
    NOK(cpu_compatible(CpuId::z80, CpuId::i8085));
    NOK(cpu_compatible(CpuId::z80, CpuId::r800));
    NOK(cpu_compatible(CpuId::z80, CpuId::r4k));
    NOK(cpu_compatible(CpuId::z80, CpuId::r5k));
    NOK(cpu_compatible(CpuId::z80, CpuId::kc160));
    NOK(cpu_compatible(CpuId::z80, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::z80, CpuId::undef));

    NOK(cpu_compatible(CpuId::z80_strict, CpuId::z80));
    OK(cpu_compatible(CpuId::z80_strict, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::z80_strict, CpuId::z180));
    NOK(cpu_compatible(CpuId::z80_strict, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::z80_strict, CpuId::ez80));
    NOK(cpu_compatible(CpuId::z80_strict, CpuId::z80n));
    NOK(cpu_compatible(CpuId::z80_strict, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::z80_strict, CpuId::r3k));
    NOK(cpu_compatible(CpuId::z80_strict, CpuId::gbz80));
    OK(cpu_compatible(CpuId::z80_strict, CpuId::i8080));
    NOK(cpu_compatible(CpuId::z80_strict, CpuId::i8085));
    NOK(cpu_compatible(CpuId::z80_strict, CpuId::r800));
    NOK(cpu_compatible(CpuId::z80_strict, CpuId::r4k));
    NOK(cpu_compatible(CpuId::z80_strict, CpuId::r5k));
    NOK(cpu_compatible(CpuId::z80_strict, CpuId::kc160));
    NOK(cpu_compatible(CpuId::z80_strict, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::z80_strict, CpuId::undef));

    NOK(cpu_compatible(CpuId::z180, CpuId::z80));
    OK(cpu_compatible(CpuId::z180, CpuId::z80_strict));
    OK(cpu_compatible(CpuId::z180, CpuId::z180));
    NOK(cpu_compatible(CpuId::z180, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::z180, CpuId::ez80));
    NOK(cpu_compatible(CpuId::z180, CpuId::z80n));
    NOK(cpu_compatible(CpuId::z180, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::z180, CpuId::r3k));
    NOK(cpu_compatible(CpuId::z180, CpuId::gbz80));
    OK(cpu_compatible(CpuId::z180, CpuId::i8080));
    NOK(cpu_compatible(CpuId::z180, CpuId::i8085));
    NOK(cpu_compatible(CpuId::z180, CpuId::r800));
    NOK(cpu_compatible(CpuId::z180, CpuId::r4k));
    NOK(cpu_compatible(CpuId::z180, CpuId::r5k));
    NOK(cpu_compatible(CpuId::z180, CpuId::kc160));
    NOK(cpu_compatible(CpuId::z180, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::z180, CpuId::undef));

    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::z80));
    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::z180));
    OK(cpu_compatible(CpuId::ez80_z80, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::ez80));
    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::z80n));
    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::r3k));
    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::gbz80));
    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::i8080));
    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::i8085));
    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::r800));
    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::r4k));
    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::r5k));
    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::kc160));
    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::ez80_z80, CpuId::undef));

    NOK(cpu_compatible(CpuId::ez80, CpuId::z80));
    NOK(cpu_compatible(CpuId::ez80, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::ez80, CpuId::z180));
    NOK(cpu_compatible(CpuId::ez80, CpuId::ez80_z80));
    OK(cpu_compatible(CpuId::ez80, CpuId::ez80));
    NOK(cpu_compatible(CpuId::ez80, CpuId::z80n));
    NOK(cpu_compatible(CpuId::ez80, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::ez80, CpuId::r3k));
    NOK(cpu_compatible(CpuId::ez80, CpuId::gbz80));
    NOK(cpu_compatible(CpuId::ez80, CpuId::i8080));
    NOK(cpu_compatible(CpuId::ez80, CpuId::i8085));
    NOK(cpu_compatible(CpuId::ez80, CpuId::r800));
    NOK(cpu_compatible(CpuId::ez80, CpuId::r4k));
    NOK(cpu_compatible(CpuId::ez80, CpuId::r5k));
    NOK(cpu_compatible(CpuId::ez80, CpuId::kc160));
    NOK(cpu_compatible(CpuId::ez80, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::ez80, CpuId::undef));

    OK(cpu_compatible(CpuId::z80n, CpuId::z80));
    OK(cpu_compatible(CpuId::z80n, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::z80n, CpuId::z180));
    NOK(cpu_compatible(CpuId::z80n, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::z80n, CpuId::ez80));
    OK(cpu_compatible(CpuId::z80n, CpuId::z80n));
    NOK(cpu_compatible(CpuId::z80n, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::z80n, CpuId::r3k));
    NOK(cpu_compatible(CpuId::z80n, CpuId::gbz80));
    OK(cpu_compatible(CpuId::z80n, CpuId::i8080));
    NOK(cpu_compatible(CpuId::z80n, CpuId::i8085));
    NOK(cpu_compatible(CpuId::z80n, CpuId::r800));
    NOK(cpu_compatible(CpuId::z80n, CpuId::r4k));
    NOK(cpu_compatible(CpuId::z80n, CpuId::r5k));
    NOK(cpu_compatible(CpuId::z80n, CpuId::kc160));
    NOK(cpu_compatible(CpuId::z80n, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::z80n, CpuId::undef));

    NOK(cpu_compatible(CpuId::r2ka, CpuId::z80));
    NOK(cpu_compatible(CpuId::r2ka, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::r2ka, CpuId::z180));
    NOK(cpu_compatible(CpuId::r2ka, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::r2ka, CpuId::ez80));
    NOK(cpu_compatible(CpuId::r2ka, CpuId::z80n));
    OK(cpu_compatible(CpuId::r2ka, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::r2ka, CpuId::r3k));
    NOK(cpu_compatible(CpuId::r2ka, CpuId::gbz80));
    NOK(cpu_compatible(CpuId::r2ka, CpuId::i8080));
    NOK(cpu_compatible(CpuId::r2ka, CpuId::i8085));
    NOK(cpu_compatible(CpuId::r2ka, CpuId::r800));
    NOK(cpu_compatible(CpuId::r2ka, CpuId::r4k));
    NOK(cpu_compatible(CpuId::r2ka, CpuId::r5k));
    NOK(cpu_compatible(CpuId::r2ka, CpuId::kc160));
    NOK(cpu_compatible(CpuId::r2ka, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::r2ka, CpuId::undef));

    NOK(cpu_compatible(CpuId::r3k, CpuId::z80));
    NOK(cpu_compatible(CpuId::r3k, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::r3k, CpuId::z180));
    NOK(cpu_compatible(CpuId::r3k, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::r3k, CpuId::ez80));
    NOK(cpu_compatible(CpuId::r3k, CpuId::z80n));
    OK(cpu_compatible(CpuId::r3k, CpuId::r2ka));
    OK(cpu_compatible(CpuId::r3k, CpuId::r3k));
    NOK(cpu_compatible(CpuId::r3k, CpuId::gbz80));
    NOK(cpu_compatible(CpuId::r3k, CpuId::i8080));
    NOK(cpu_compatible(CpuId::r3k, CpuId::i8085));
    NOK(cpu_compatible(CpuId::r3k, CpuId::r800));
    NOK(cpu_compatible(CpuId::r3k, CpuId::r4k));
    NOK(cpu_compatible(CpuId::r3k, CpuId::r5k));
    NOK(cpu_compatible(CpuId::r3k, CpuId::kc160));
    NOK(cpu_compatible(CpuId::r3k, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::r3k, CpuId::undef));

    NOK(cpu_compatible(CpuId::gbz80, CpuId::z80));
    NOK(cpu_compatible(CpuId::gbz80, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::gbz80, CpuId::z180));
    NOK(cpu_compatible(CpuId::gbz80, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::gbz80, CpuId::ez80));
    NOK(cpu_compatible(CpuId::gbz80, CpuId::z80n));
    NOK(cpu_compatible(CpuId::gbz80, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::gbz80, CpuId::r3k));
    OK(cpu_compatible(CpuId::gbz80, CpuId::gbz80));
    NOK(cpu_compatible(CpuId::gbz80, CpuId::i8080));
    NOK(cpu_compatible(CpuId::gbz80, CpuId::i8085));
    NOK(cpu_compatible(CpuId::gbz80, CpuId::r800));
    NOK(cpu_compatible(CpuId::gbz80, CpuId::r4k));
    NOK(cpu_compatible(CpuId::gbz80, CpuId::r5k));
    NOK(cpu_compatible(CpuId::gbz80, CpuId::kc160));
    NOK(cpu_compatible(CpuId::gbz80, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::gbz80, CpuId::undef));

    NOK(cpu_compatible(CpuId::i8080, CpuId::z80));
    NOK(cpu_compatible(CpuId::i8080, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::i8080, CpuId::z180));
    NOK(cpu_compatible(CpuId::i8080, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::i8080, CpuId::ez80));
    NOK(cpu_compatible(CpuId::i8080, CpuId::z80n));
    NOK(cpu_compatible(CpuId::i8080, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::i8080, CpuId::r3k));
    NOK(cpu_compatible(CpuId::i8080, CpuId::gbz80));
    OK(cpu_compatible(CpuId::i8080, CpuId::i8080));
    NOK(cpu_compatible(CpuId::i8080, CpuId::i8085));
    NOK(cpu_compatible(CpuId::i8080, CpuId::r800));
    NOK(cpu_compatible(CpuId::i8080, CpuId::r4k));
    NOK(cpu_compatible(CpuId::i8080, CpuId::r5k));
    NOK(cpu_compatible(CpuId::i8080, CpuId::kc160));
    NOK(cpu_compatible(CpuId::i8080, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::i8080, CpuId::undef));

    NOK(cpu_compatible(CpuId::i8085, CpuId::z80));
    NOK(cpu_compatible(CpuId::i8085, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::i8085, CpuId::z180));
    NOK(cpu_compatible(CpuId::i8085, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::i8085, CpuId::ez80));
    NOK(cpu_compatible(CpuId::i8085, CpuId::z80n));
    NOK(cpu_compatible(CpuId::i8085, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::i8085, CpuId::r3k));
    NOK(cpu_compatible(CpuId::i8085, CpuId::gbz80));
    OK(cpu_compatible(CpuId::i8085, CpuId::i8080));
    OK(cpu_compatible(CpuId::i8085, CpuId::i8085));
    NOK(cpu_compatible(CpuId::i8085, CpuId::r800));
    NOK(cpu_compatible(CpuId::i8085, CpuId::r4k));
    NOK(cpu_compatible(CpuId::i8085, CpuId::r5k));
    NOK(cpu_compatible(CpuId::i8085, CpuId::kc160));
    NOK(cpu_compatible(CpuId::i8085, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::i8085, CpuId::undef));

    NOK(cpu_compatible(CpuId::r800, CpuId::z80));
    OK(cpu_compatible(CpuId::r800, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::r800, CpuId::z180));
    NOK(cpu_compatible(CpuId::r800, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::r800, CpuId::ez80));
    NOK(cpu_compatible(CpuId::r800, CpuId::z80n));
    NOK(cpu_compatible(CpuId::r800, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::r800, CpuId::r3k));
    NOK(cpu_compatible(CpuId::r800, CpuId::gbz80));
    OK(cpu_compatible(CpuId::r800, CpuId::i8080));
    NOK(cpu_compatible(CpuId::r800, CpuId::i8085));
    OK(cpu_compatible(CpuId::r800, CpuId::r800));
    NOK(cpu_compatible(CpuId::r800, CpuId::r4k));
    NOK(cpu_compatible(CpuId::r800, CpuId::r5k));
    NOK(cpu_compatible(CpuId::r800, CpuId::kc160));
    NOK(cpu_compatible(CpuId::r800, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::r800, CpuId::undef));

    NOK(cpu_compatible(CpuId::r4k, CpuId::z80));
    NOK(cpu_compatible(CpuId::r4k, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::r4k, CpuId::z180));
    NOK(cpu_compatible(CpuId::r4k, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::r4k, CpuId::ez80));
    NOK(cpu_compatible(CpuId::r4k, CpuId::z80n));
    NOK(cpu_compatible(CpuId::r4k, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::r4k, CpuId::r3k));
    NOK(cpu_compatible(CpuId::r4k, CpuId::gbz80));
    NOK(cpu_compatible(CpuId::r4k, CpuId::i8080));
    NOK(cpu_compatible(CpuId::r4k, CpuId::i8085));
    NOK(cpu_compatible(CpuId::r4k, CpuId::r800));
    OK(cpu_compatible(CpuId::r4k, CpuId::r4k));
    NOK(cpu_compatible(CpuId::r4k, CpuId::r5k));
    NOK(cpu_compatible(CpuId::r4k, CpuId::kc160));
    NOK(cpu_compatible(CpuId::r4k, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::r4k, CpuId::undef));

    NOK(cpu_compatible(CpuId::r5k, CpuId::z80));
    NOK(cpu_compatible(CpuId::r5k, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::r5k, CpuId::z180));
    NOK(cpu_compatible(CpuId::r5k, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::r5k, CpuId::ez80));
    NOK(cpu_compatible(CpuId::r5k, CpuId::z80n));
    NOK(cpu_compatible(CpuId::r5k, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::r5k, CpuId::r3k));
    NOK(cpu_compatible(CpuId::r5k, CpuId::gbz80));
    NOK(cpu_compatible(CpuId::r5k, CpuId::i8080));
    NOK(cpu_compatible(CpuId::r5k, CpuId::i8085));
    NOK(cpu_compatible(CpuId::r5k, CpuId::r800));
    OK(cpu_compatible(CpuId::r5k, CpuId::r4k));
    OK(cpu_compatible(CpuId::r5k, CpuId::r5k));
    NOK(cpu_compatible(CpuId::r5k, CpuId::kc160));
    NOK(cpu_compatible(CpuId::r5k, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::r5k, CpuId::undef));

    NOK(cpu_compatible(CpuId::kc160, CpuId::z80));
    NOK(cpu_compatible(CpuId::kc160, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::kc160, CpuId::z180));
    NOK(cpu_compatible(CpuId::kc160, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::kc160, CpuId::ez80));
    NOK(cpu_compatible(CpuId::kc160, CpuId::z80n));
    NOK(cpu_compatible(CpuId::kc160, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::kc160, CpuId::r3k));
    NOK(cpu_compatible(CpuId::kc160, CpuId::gbz80));
    NOK(cpu_compatible(CpuId::kc160, CpuId::i8080));
    NOK(cpu_compatible(CpuId::kc160, CpuId::i8085));
    NOK(cpu_compatible(CpuId::kc160, CpuId::r800));
    NOK(cpu_compatible(CpuId::kc160, CpuId::r4k));
    NOK(cpu_compatible(CpuId::kc160, CpuId::r5k));
    OK(cpu_compatible(CpuId::kc160, CpuId::kc160));
    NOK(cpu_compatible(CpuId::kc160, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::kc160, CpuId::undef));

    NOK(cpu_compatible(CpuId::kc160_z80, CpuId::z80));
    OK(cpu_compatible(CpuId::kc160_z80, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::kc160_z80, CpuId::z180));
    NOK(cpu_compatible(CpuId::kc160_z80, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::kc160_z80, CpuId::ez80));
    NOK(cpu_compatible(CpuId::kc160_z80, CpuId::z80n));
    NOK(cpu_compatible(CpuId::kc160_z80, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::kc160_z80, CpuId::r3k));
    NOK(cpu_compatible(CpuId::kc160_z80, CpuId::gbz80));
    OK(cpu_compatible(CpuId::kc160_z80, CpuId::i8080));
    NOK(cpu_compatible(CpuId::kc160_z80, CpuId::i8085));
    NOK(cpu_compatible(CpuId::kc160_z80, CpuId::r800));
    NOK(cpu_compatible(CpuId::kc160_z80, CpuId::r4k));
    NOK(cpu_compatible(CpuId::kc160_z80, CpuId::r5k));
    NOK(cpu_compatible(CpuId::kc160_z80, CpuId::kc160));
    OK(cpu_compatible(CpuId::kc160_z80, CpuId::kc160_z80));
    NOK(cpu_compatible(CpuId::kc160_z80, CpuId::undef));

    NOK(cpu_compatible(CpuId::undef, CpuId::z80));
    NOK(cpu_compatible(CpuId::undef, CpuId::z80_strict));
    NOK(cpu_compatible(CpuId::undef, CpuId::z180));
    NOK(cpu_compatible(CpuId::undef, CpuId::ez80_z80));
    NOK(cpu_compatible(CpuId::undef, CpuId::ez80));
    NOK(cpu_compatible(CpuId::undef, CpuId::z80n));
    NOK(cpu_compatible(CpuId::undef, CpuId::r2ka));
    NOK(cpu_compatible(CpuId::undef, CpuId::r3k));
    NOK(cpu_compatible(CpuId::undef, CpuId::gbz80));
    NOK(cpu_compatible(CpuId::undef, CpuId::i8080));
    NOK(cpu_compatible(CpuId::undef, CpuId::i8085));
    NOK(cpu_compatible(CpuId::undef, CpuId::r800));
    NOK(cpu_compatible(CpuId::undef, CpuId::r4k));
    NOK(cpu_compatible(CpuId::undef, CpuId::r5k));
    NOK(cpu_compatible(CpuId::undef, CpuId::kc160));
    NOK(cpu_compatible(CpuId::undef, CpuId::kc160_z80));
}

void test_swap_ixiy_lookup_int() {
    SwapIXIY swap_ixiy;

    swap_ixiy = swap_ixiy_lookup(-1); IS(swap_ixiy, SwapIXIY::undef);
    swap_ixiy = swap_ixiy_lookup(0); IS(swap_ixiy, SwapIXIY::no_swap);
    swap_ixiy = swap_ixiy_lookup(1); IS(swap_ixiy, SwapIXIY::swap);
    swap_ixiy = swap_ixiy_lookup(2); IS(swap_ixiy, SwapIXIY::soft_swap);
    swap_ixiy = swap_ixiy_lookup(3); IS(swap_ixiy, SwapIXIY::undef);
    swap_ixiy = swap_ixiy_lookup(4); IS(swap_ixiy, SwapIXIY::undef);
}

void test_swap_ixiy_name() {
    STR_IS(swap_ixiy_name(SwapIXIY::undef), "");
    STR_IS(swap_ixiy_name(SwapIXIY::no_swap), "(no option)");
    STR_IS(swap_ixiy_name(SwapIXIY::swap), "-IXIY");
    STR_IS(swap_ixiy_name(SwapIXIY::soft_swap), "-IXIY-soft");
}

void test_swap_ixiy_all_defines() {
    vector<string> defines = swap_ixiy_all_defines();
    IS(defines.size(), static_cast<size_t>(2));
    STR_IS(defines[0], "__SWAP_IX_IY__");
    STR_IS(defines[1], "__SWAP_IX_IY__");
}

void test_swap_ixiy_defines() {
    vector<string> defines;

    defines = swap_ixiy_defines(SwapIXIY::undef);
    IS(defines.size(), static_cast<size_t>(0));

    defines = swap_ixiy_defines(SwapIXIY::no_swap);
    IS(defines.size(), static_cast<size_t>(0));

    defines = swap_ixiy_defines(SwapIXIY::swap);
    IS(defines.size(), static_cast<size_t>(1));
    STR_IS(defines[0], "__SWAP_IX_IY__");

    defines = swap_ixiy_defines(SwapIXIY::soft_swap);
    IS(defines.size(), static_cast<size_t>(1));
    STR_IS(defines[0], "__SWAP_IX_IY__");
}

void test_swap_ixiy_compatible() {
    OK(swap_ixiy_compatible(SwapIXIY::no_swap, SwapIXIY::no_swap));
    NOK(swap_ixiy_compatible(SwapIXIY::no_swap, SwapIXIY::swap));
    OK(swap_ixiy_compatible(SwapIXIY::no_swap, SwapIXIY::soft_swap));

    NOK(swap_ixiy_compatible(SwapIXIY::swap, SwapIXIY::no_swap));
    OK(swap_ixiy_compatible(SwapIXIY::swap, SwapIXIY::swap));
    NOK(swap_ixiy_compatible(SwapIXIY::swap, SwapIXIY::soft_swap));

    OK(swap_ixiy_compatible(SwapIXIY::soft_swap, SwapIXIY::no_swap));
    NOK(swap_ixiy_compatible(SwapIXIY::soft_swap, SwapIXIY::swap));
    OK(swap_ixiy_compatible(SwapIXIY::soft_swap, SwapIXIY::soft_swap));
}

void test_appmake() {
    IS(appmake_default_origin(Appmake::none), ORG_NOT_DEFINED);
    IS(appmake_min_origin(Appmake::none), ORG_NOT_DEFINED);
    IS(appmake_max_origin(Appmake::none), ORG_NOT_DEFINED);
    STR_IS(appmake_file_ext(Appmake::none), "");
    
    IS(appmake_default_origin(Appmake::zx81), 16514);
    IS(appmake_min_origin(Appmake::zx81), 16514);
    IS(appmake_max_origin(Appmake::zx81), 16514);
    STR_IS(appmake_file_ext(Appmake::zx81), ".P");
    
    IS(appmake_default_origin(Appmake::zx), 23760);
    IS(appmake_min_origin(Appmake::zx), 23760);
    IS(appmake_max_origin(Appmake::zx), 65535);
    STR_IS(appmake_file_ext(Appmake::zx), ".tap");
}

void test_zfloat_lookup_string() {
    IS(zfloat_lookup(""), ZFloat::undef);
    IS(zfloat_lookup("genmath"), ZFloat::genmath);
	IS(zfloat_lookup("math48"), ZFloat::math48);
	IS(zfloat_lookup("ieee16"), ZFloat::ieee16);
	IS(zfloat_lookup("ieee32"), ZFloat::ieee32);
	IS(zfloat_lookup("ieee64"), ZFloat::ieee64);
	IS(zfloat_lookup("z80"), ZFloat::z80);
	IS(zfloat_lookup("zx81"), ZFloat::zx81);
	IS(zfloat_lookup("zx"), ZFloat::zx);
	IS(zfloat_lookup("z88"), ZFloat::z88);
	IS(zfloat_lookup("mbfs"), ZFloat::mbfs);
	IS(zfloat_lookup("mbf40"), ZFloat::mbf40);
	IS(zfloat_lookup("mbf64"), ZFloat::mbf64);
	IS(zfloat_lookup("am9511"), ZFloat::am9511);
}

void test_zfloat_name() {
    STR_IS(zfloat_name(ZFloat::undef), "");
    STR_IS(zfloat_name(ZFloat::genmath), "genmath");
	STR_IS(zfloat_name(ZFloat::math48), "math48");
	STR_IS(zfloat_name(ZFloat::ieee16), "ieee16");
	STR_IS(zfloat_name(ZFloat::ieee32), "ieee32");
	STR_IS(zfloat_name(ZFloat::ieee64), "ieee64");
	STR_IS(zfloat_name(ZFloat::z80), "z80");
	STR_IS(zfloat_name(ZFloat::zx81), "zx81");
	STR_IS(zfloat_name(ZFloat::zx), "zx");
	STR_IS(zfloat_name(ZFloat::z88), "z88");
	STR_IS(zfloat_name(ZFloat::mbfs), "mbfs");
	STR_IS(zfloat_name(ZFloat::mbf40), "mbf40");
	STR_IS(zfloat_name(ZFloat::mbf64), "mbf64");
	STR_IS(zfloat_name(ZFloat::am9511), "am9511");
}

void test_zfloat_all_defines() {
	vector<string> defines = zfloat_all_defines();
	IS(defines.size(), static_cast<size_t>(13));
	STR_IS(defines[0], "__FLOAT_GENMATH__");
	STR_IS(defines[1], "__FLOAT_MATH48__");
	STR_IS(defines[2], "__FLOAT_IEEE16__");
	STR_IS(defines[3], "__FLOAT_IEEE32__");
	STR_IS(defines[4], "__FLOAT_IEEE64__");
	STR_IS(defines[5], "__FLOAT_Z80__");
	STR_IS(defines[6], "__FLOAT_ZX81__");
	STR_IS(defines[7], "__FLOAT_ZX__");
	STR_IS(defines[8], "__FLOAT_Z88__");
	STR_IS(defines[9], "__FLOAT_MBFS__");
	STR_IS(defines[10], "__FLOAT_MBF40__");
	STR_IS(defines[11], "__FLOAT_MBF64__");
	STR_IS(defines[12], "__FLOAT_AM9511__");
}

void test_zfloat_defines() {
	vector<string> defines;
	
	defines = zfloat_defines(ZFloat::genmath);
	IS(defines.size(), static_cast<size_t>(1));
	STR_IS(defines[0], "__FLOAT_GENMATH__");
	
	defines = zfloat_defines(ZFloat::math48);
	IS(defines.size(), static_cast<size_t>(1));
	STR_IS(defines[0], "__FLOAT_MATH48__");
	
	defines = zfloat_defines(ZFloat::ieee16);
	IS(defines.size(), static_cast<size_t>(1));
	STR_IS(defines[0], "__FLOAT_IEEE16__");
	
	defines = zfloat_defines(ZFloat::ieee32);
	IS(defines.size(), static_cast<size_t>(1));
	STR_IS(defines[0], "__FLOAT_IEEE32__");
	
	defines = zfloat_defines(ZFloat::ieee64);
	IS(defines.size(), static_cast<size_t>(1));
	STR_IS(defines[0], "__FLOAT_IEEE64__");
	
	defines = zfloat_defines(ZFloat::z80);
	IS(defines.size(), static_cast<size_t>(1));
	STR_IS(defines[0], "__FLOAT_Z80__");
	
	defines = zfloat_defines(ZFloat::zx81);
	IS(defines.size(), static_cast<size_t>(1));
	STR_IS(defines[0], "__FLOAT_ZX81__");
	
	defines = zfloat_defines(ZFloat::zx);
	IS(defines.size(), static_cast<size_t>(1));
	STR_IS(defines[0], "__FLOAT_ZX__");
	
	defines = zfloat_defines(ZFloat::z88);
	IS(defines.size(), static_cast<size_t>(1));
	STR_IS(defines[0], "__FLOAT_Z88__");
	
	defines = zfloat_defines(ZFloat::mbfs);
	IS(defines.size(), static_cast<size_t>(1));
	STR_IS(defines[0], "__FLOAT_MBFS__");
	
	defines = zfloat_defines(ZFloat::mbf40);
	IS(defines.size(), static_cast<size_t>(1));
	STR_IS(defines[0], "__FLOAT_MBF40__");
	
	defines = zfloat_defines(ZFloat::mbf64);
	IS(defines.size(), static_cast<size_t>(1));
	STR_IS(defines[0], "__FLOAT_MBF64__");
	
	defines = zfloat_defines(ZFloat::am9511);
	IS(defines.size(), static_cast<size_t>(1));
	STR_IS(defines[0], "__FLOAT_AM9511__");
}

void test_option_envvars() {
    g_args = Args();
    OK(putenv(const_cast<char*>("Z80ASM=-ucase -raw-strings -I'dir with spaces'")) == 0);
    create_f1_asm();

    NOK(g_args.opt_ucase);
    NOK(g_args.opt_raw_strings);
    IS(g_args.opt_include_path.size(), static_cast<size_t>(0));

    g_args.parse("Test", { "f1.asm" });

    OK(g_args.opt_ucase);
    OK(g_args.opt_raw_strings);
    IS(g_args.opt_include_path.size(), static_cast<size_t>(1));
    STR_IS(g_args.opt_include_path[0], "dir with spaces");

    OK(putenv(const_cast<char*>("Z80ASM=")) == 0);
    remove_f1_asm();
    g_args = Args();
}

void test_option_no_files() {
    RUN_NOK("exec_option_no_files");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: source file expected\n");
}

int exec_option_no_files() {
    g_args.parse("Test", { "-ucase" });
    return EXIT_SUCCESS;
}

void test_option_copyright() {
    RUN_OK("exec_option_copyright");
    STR_IS(test_exec_out, COPYRIGHT_MSG "\n");
    STR_IS(test_exec_err, "");
}

int exec_option_copyright() {
    g_args.parse("Test", {});
    return EXIT_FAILURE;
}

void test_option_help() {
    string expected = COPYRIGHT_MSG + string("\n\n") + test_file_slurp("t/help.txt");
    RUN_OK("exec_option_help");
    STR_IS(test_exec_out, expected);
    STR_IS(test_exec_err, "");
}

int exec_option_help() {
    g_args.parse("Test", { "-h" });
    return EXIT_FAILURE;
}

void test_option_verbose() {
    g_args = Args();
    create_f1_asm();

    RUN_OK("exec_option_verbose");
    STR_IS(test_exec_out,
        "% Test -v f1.asm\n"
        "Predefined constant: __CPU_Z80__ = 1\n"
        "Predefined constant: __CPU_ZILOG__ = 1\n"
        "Predefined constant: __FLOAT_GENMATH__ = 1\n");
    STR_IS(test_exec_err, "");

    remove_f1_asm();
    g_args = Args();
}

int exec_option_verbose() {
    xassert(!g_args.opt_verbose);
    g_args.parse("Test", { "-v", "f1.asm" });
    xassert(g_args.opt_verbose);
    return EXIT_SUCCESS;
}

void test_option_debug_z80asm() {
    g_args = Args();
    create_f1_asm();

    RUN_OK("exec_option_debug_z80asm");
    STR_IS(test_exec_out,
        "% Test -vv f1.asm\n"
        "Predefined constant: __CPU_Z80__ = 1\n"
        "Predefined constant: __CPU_ZILOG__ = 1\n"
        "Predefined constant: __FLOAT_GENMATH__ = 1\n");
    STR_IS(test_exec_err, "");

    remove_f1_asm();
    g_args = Args();
}

int exec_option_debug_z80asm() {
    xassert(!g_args.opt_debug_z80asm);
    g_args.parse("Test", { "-vv", "f1.asm" });
    xassert(g_args.opt_debug_z80asm);
    return EXIT_SUCCESS;
}

void test_option_swap_ixiy() {
    g_args = Args();
    int value;
    create_f1_asm();

    g_args.parse("Test", { "f1.asm" });
    IS(g_args.opt_swap_ixiy, SwapIXIY::no_swap);
    NOK(g_static_defines.lookup("__SWAP_IX_IY__", value)); IS(value, 0);

    g_args.parse("Test", { "-IXIY", "f1.asm" });
    IS(g_args.opt_swap_ixiy, SwapIXIY::swap);
    OK(g_static_defines.lookup("__SWAP_IX_IY__", value)); IS(value, 1);

    g_args.parse("Test", { "-IXIY-soft", "f1.asm" });
    IS(g_args.opt_swap_ixiy, SwapIXIY::soft_swap);
    OK(g_static_defines.lookup("__SWAP_IX_IY__", value)); IS(value, 1);

    g_args.set_swap_ixiy(SwapIXIY::no_swap);

    remove_f1_asm();
    g_args = Args();
}

void test_option_include() {
    g_args = Args();
    create_f1_asm();

    OK(g_args.opt_include_path.empty());
    g_args.parse("Test", { "-Ix1", "-Ix2", "f1.asm" });
    IS(g_args.opt_include_path.size(), static_cast<size_t>(2));
    STR_IS(g_args.opt_include_path[0], "x1");
    STR_IS(g_args.opt_include_path[1], "x2");

    RUN_NOK("exec_option_include");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal option: -I\n");

    remove_f1_asm();
    g_args = Args();
}

int exec_option_include() {
    g_args.parse("Test", { "-I", "f1.asm" });
    return EXIT_SUCCESS;
}

void test_option_define() {
    g_args = Args();
    int value;

    create_f1_asm();

    g_args.parse("Test", { "-Dx1", "-D=x2=2", "f1.asm" });
    OK(g_static_defines.lookup("x1", value));
    IS(value, 1);
    OK(g_static_defines.lookup("x2", value));
    IS(value, 2);

    remove_f1_asm();
    g_static_defines.clear();
    g_args = Args();
}

void test_option_ucase() {
    g_args = Args();
    create_f1_asm();

    NOK(g_args.opt_ucase);
    g_args.parse("Test", { "-ucase", "f1.asm" });
    OK(g_args.opt_ucase);

    remove_f1_asm();
    g_args = Args();
}

void test_option_float() {
    g_args = Args();
    int value;
	
    create_f1_asm();

    g_args.set_zfloat(ZFloat::undef);
    NOK(g_static_defines.lookup("__FLOAT_GENMATH__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MATH48__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE16__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE32__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX81__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z88__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBFS__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF40__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_AM9511__", value)); IS(value, 0);

    g_args.parse("Test", { "f1.asm" });
    IS(g_args.opt_zfloat, ZFloat::genmath);
    OK(g_static_defines.lookup("__FLOAT_GENMATH__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__FLOAT_MATH48__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE16__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE32__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX81__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z88__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBFS__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF40__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_AM9511__", value)); IS(value, 0);

    g_args.parse("Test", { "-float=genmath", "f1.asm" });
    IS(g_args.opt_zfloat, ZFloat::genmath);
    OK(g_static_defines.lookup("__FLOAT_GENMATH__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__FLOAT_MATH48__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE16__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE32__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX81__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z88__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBFS__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF40__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_AM9511__", value)); IS(value, 0);

    g_args.parse("Test", { "-floatmath48", "f1.asm" });
    IS(g_args.opt_zfloat, ZFloat::math48);
    NOK(g_static_defines.lookup("__FLOAT_GENMATH__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__FLOAT_MATH48__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__FLOAT_IEEE16__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE32__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX81__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z88__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBFS__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF40__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_AM9511__", value)); IS(value, 0);

    g_args.parse("Test", { "-float=ieee16", "f1.asm" });
    IS(g_args.opt_zfloat, ZFloat::ieee16);
    NOK(g_static_defines.lookup("__FLOAT_GENMATH__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MATH48__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__FLOAT_IEEE16__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__FLOAT_IEEE32__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX81__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z88__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBFS__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF40__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_AM9511__", value)); IS(value, 0);

    g_args.parse("Test", { "-float=ieee32", "f1.asm" });
    IS(g_args.opt_zfloat, ZFloat::ieee32);
    NOK(g_static_defines.lookup("__FLOAT_GENMATH__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MATH48__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE16__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__FLOAT_IEEE32__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__FLOAT_IEEE64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX81__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z88__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBFS__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF40__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_AM9511__", value)); IS(value, 0);

    g_args.parse("Test", { "-float=ieee64", "f1.asm" });
    IS(g_args.opt_zfloat, ZFloat::ieee64);
    NOK(g_static_defines.lookup("__FLOAT_GENMATH__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MATH48__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE16__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE32__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__FLOAT_IEEE64__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__FLOAT_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX81__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z88__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBFS__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF40__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_AM9511__", value)); IS(value, 0);

    g_args.parse("Test", { "-float=z80", "f1.asm" });
    IS(g_args.opt_zfloat, ZFloat::z80);
    NOK(g_static_defines.lookup("__FLOAT_GENMATH__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MATH48__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE16__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE32__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE64__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__FLOAT_Z80__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__FLOAT_ZX81__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z88__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBFS__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF40__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_AM9511__", value)); IS(value, 0);

    g_args.parse("Test", { "-float=zx81", "f1.asm" });
    IS(g_args.opt_zfloat, ZFloat::zx81);
    NOK(g_static_defines.lookup("__FLOAT_GENMATH__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MATH48__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE16__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE32__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z80__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__FLOAT_ZX81__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__FLOAT_ZX__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z88__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBFS__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF40__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_AM9511__", value)); IS(value, 0);

    g_args.parse("Test", { "-float=zx", "f1.asm" });
    IS(g_args.opt_zfloat, ZFloat::zx);
    NOK(g_static_defines.lookup("__FLOAT_GENMATH__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MATH48__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE16__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE32__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX81__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__FLOAT_ZX__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__FLOAT_Z88__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBFS__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF40__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_AM9511__", value)); IS(value, 0);

    g_args.parse("Test", { "-float=z88", "f1.asm" });
    IS(g_args.opt_zfloat, ZFloat::z88);
    NOK(g_static_defines.lookup("__FLOAT_GENMATH__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MATH48__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE16__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE32__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX81__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__FLOAT_Z88__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__FLOAT_MBFS__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF40__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_AM9511__", value)); IS(value, 0);

    g_args.parse("Test", { "-float=mbfs", "f1.asm" });
    IS(g_args.opt_zfloat, ZFloat::mbfs);
    NOK(g_static_defines.lookup("__FLOAT_GENMATH__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MATH48__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE16__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE32__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX81__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z88__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__FLOAT_MBFS__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__FLOAT_MBF40__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_AM9511__", value)); IS(value, 0);

    g_args.parse("Test", { "-float=mbf40", "f1.asm" });
    IS(g_args.opt_zfloat, ZFloat::mbf40);
    NOK(g_static_defines.lookup("__FLOAT_GENMATH__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MATH48__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE16__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE32__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX81__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z88__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBFS__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__FLOAT_MBF40__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__FLOAT_MBF64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_AM9511__", value)); IS(value, 0);

    g_args.parse("Test", { "-float=mbf64", "f1.asm" });
    IS(g_args.opt_zfloat, ZFloat::mbf64);
    NOK(g_static_defines.lookup("__FLOAT_GENMATH__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MATH48__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE16__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE32__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX81__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z88__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBFS__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF40__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__FLOAT_MBF64__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__FLOAT_AM9511__", value)); IS(value, 0);

    g_args.parse("Test", { "-float=am9511", "f1.asm" });
    IS(g_args.opt_zfloat, ZFloat::am9511);
    NOK(g_static_defines.lookup("__FLOAT_GENMATH__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MATH48__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE16__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE32__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_IEEE64__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX81__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_ZX__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_Z88__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBFS__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF40__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__FLOAT_MBF64__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__FLOAT_AM9511__", value)); IS(value, 1);
    
    RUN_NOK("exec_option_float");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal -float option: abc\n");

    remove_f1_asm();
    g_args.set_zfloat(ZFloat::undef);
    g_args = Args();
}

int exec_option_float() {
    g_args.parse("Test", { "-float=abc", "f1.asm" });
    return EXIT_SUCCESS;
}

void test_option_raw_strings() {
    g_args = Args();
    create_f1_asm();

    NOK(g_args.opt_raw_strings);
    g_args.parse("Test", { "-raw-strings", "f1.asm" });
    OK(g_args.opt_raw_strings);

    remove_f1_asm();
    g_args = Args();
}

void test_option_cpu() {
    g_args = Args();
    int value;

    create_f1_asm();

    g_args.set_cpu(CpuId::undef);
    IS(g_args.opt_cpu, CpuId::undef);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "f1.asm" });
    IS(g_args.opt_cpu, CpuId::z80);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 1);
    OK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m*", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::z80);
    OK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 1);
    OK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-mz80", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::z80);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 1);
    OK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=z80_strict", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::z80_strict);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=z180", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::z180);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=ez80", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::ez80);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=ez80_z80", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::ez80_z80);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=z80n", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::z80n);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=gbz80", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::gbz80);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=r2ka", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::r2ka);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 1);
    OK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=r3k", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::r3k);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=r4k", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::r4k);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=r5k", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::r5k);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=ti83", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::z80_strict);
    NOK(g_args.opt_lib_for_all_cpus);
    OK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=ti83plus", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::z80_strict);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    OK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 1);

    g_args.parse("Test", { "-m=8080", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::i8080);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    OK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 1);
    OK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=8085", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::i8085);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    OK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=r800", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::r800);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=kc160", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::kc160);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    g_args.parse("Test", { "-m=kc160_z80", "f1.asm" });
    IS(g_args.opt_cpu, CpuId::kc160_z80);
    NOK(g_args.opt_lib_for_all_cpus);
    NOK(g_args.opt_ti83);
    NOK(g_args.opt_ti83plus);
    NOK(g_static_defines.lookup("__CPU_INTEL__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8080__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_8085__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_ZILOG__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80_STRICT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z80N__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_Z180__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_EZ80_Z80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R800__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_GBZ80__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_KC160__", value)); IS(value, 0);
    OK(g_static_defines.lookup("__CPU_KC160_Z80__", value)); IS(value, 1);
    NOK(g_static_defines.lookup("__CPU_RABBIT__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R2KA__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R3K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R4K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_R5K__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83__", value)); IS(value, 0);
    NOK(g_static_defines.lookup("__CPU_TI83PLUS__", value)); IS(value, 0);

    RUN_NOK("exec_option_cpu");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal -m option: abc\n");

    remove_f1_asm();
    g_args.set_cpu(CpuId::undef);
    g_args = Args();
}

int exec_option_cpu() {
    g_args.parse("Test", { "-m=abc", "f1.asm" });
    return EXIT_SUCCESS;
}

void test_option_opt_speed() {
    g_args = Args();
    create_f1_asm();

    NOK(g_args.opt_speed);
    g_args.parse("Test", { "-opt-speed", "f1.asm" });
    OK(g_args.opt_speed);

    remove_f1_asm();
    g_args = Args();
}

void test_option_debug() {
    g_args = Args();
    create_f1_asm();

    NOK(g_args.opt_debug);
    g_args.parse("Test", { "-debug", "f1.asm" });
    OK(g_args.opt_debug);

    remove_f1_asm();
    g_args = Args();
}

void test_option_library_path() {
    g_args = Args();
    create_f1_asm();

    OK(g_args.opt_library_path.empty());
    g_args.parse("Test", { "-Lx1", "-Lx2", "f1.asm" });
    IS(g_args.opt_library_path.size(), static_cast<size_t>(2));
    STR_IS(g_args.opt_library_path[0], "x1");
    STR_IS(g_args.opt_library_path[1], "x2");

    RUN_NOK("exec_option_library_path");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal option: -L\n");

    remove_f1_asm();
    g_args = Args();
}

int exec_option_library_path() {
    g_args.parse("Test", { "-L", "f1.asm" });
    return EXIT_SUCCESS;
}

void test_option_make_library() {
    g_args = Args();
    create_f1_asm();

    STR_IS(g_args.opt_lib_file, "");
    g_args.parse("Test", { "-x=l1", "f1.asm" });
    STR_IS(g_args.opt_lib_file, "l1");

    RUN_NOK("exec_option_make_library");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal option: -x\n");

    remove_f1_asm();
    g_args = Args();
}

int exec_option_make_library() {
    g_args.parse("Test", { "-x", "f1.asm" });
    return EXIT_SUCCESS;
}

void test_option_library() {
    g_args = Args();
    create_f1_asm();

    OK(g_args.opt_libraries.empty());
    g_args.parse("Test", { "-lx1", "-lx2", "f1.asm" });
    IS(g_args.opt_libraries.size(), static_cast<size_t>(3));
    STR_IS(g_args.opt_libraries[0], "x1.lib");
    STR_IS(g_args.opt_libraries[1], "x2.lib");
    STR_IS(g_args.opt_libraries[2], "z88dk-z80asm.lib");

    // -l is list file
    RUN_OK("exec_option_library");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "");

    remove_f1_asm();
    g_args = Args();
}

int exec_option_library() {
    g_args.parse("Test", { "-l", "f1.asm" });
    return EXIT_SUCCESS;
}

void test_option_output_dir() {
    g_args = Args();
    fs::remove_all(fs::path("test_output_dir"));
    create_f1_asm();

    STR_IS(g_args.opt_output_dir, "");
    g_args.parse("Test", { "-O=test_output_dir", "f1.asm" });
    STR_IS(g_args.opt_output_dir, "test_output_dir");
    STR_IS(g_args.o_filename("f1.asm"), "test_output_dir/f1.o");

    OK(fs::is_directory(fs::path("test_output_dir")));
    fs::remove_all(fs::path("test_output_dir"));
    NOK(fs::is_directory(fs::path("test_output_dir")));

    RUN_NOK("exec_option_output_dir");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal option: -O\n");

    remove_f1_asm();
    g_args = Args();
}

int exec_option_output_dir() {
    g_args.parse("Test", { "-O", "f1.asm" });
    return EXIT_SUCCESS;
}

void test_option_output_file() {
    g_args = Args();
    create_f1_asm();

    STR_IS(g_args.opt_bin_file, "");
    STR_IS(g_args.opt_consol_obj_file, "");
    NOK(g_args.opt_make_bin);

    g_args.parse("Test", { "-o=f1", "f1.asm" });
    STR_IS(g_args.opt_bin_file, "");
    STR_IS(g_args.opt_consol_obj_file, "f1");
    NOK(g_args.opt_make_bin);

    g_args = Args();

    g_args.parse("Test", { "-b", "-o=f1", "f1.asm" });
    STR_IS(g_args.opt_bin_file, "f1");
    STR_IS(g_args.opt_consol_obj_file, "");
    OK(g_args.opt_make_bin);

    RUN_NOK("exec_option_output_file");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal option: -o\n");

    remove_f1_asm();
    g_args = Args();
}

int exec_option_output_file() {
    g_args.parse("Test", { "-o", "f1.asm" });
    return EXIT_SUCCESS;
}

void test_option_make_bin() {
    g_args = Args();
    create_f1_asm();

    NOK(g_args.opt_make_bin);
    g_args.parse("Test", { "-b", "f1.asm" });
    OK(g_args.opt_make_bin);

    remove_f1_asm();
    g_args = Args();
}

void test_option_split_bin() {
    g_args = Args();
    create_f1_asm();

    NOK(g_args.opt_split_bin);
    g_args.parse("Test", { "-split-bin", "f1.asm" });
    OK(g_args.opt_split_bin);

    remove_f1_asm();
    g_args = Args();
}

void test_option_date_stamp() {
    g_args = Args();
    create_f1_asm();

    NOK(g_args.opt_date_stamp);
    g_args.parse("Test", { "-d", "f1.asm" });
    OK(g_args.opt_date_stamp);

    RUN_NOK("exec_option_date_stamp");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: -m* and -d options incompatible\n");

    remove_f1_asm();
    g_args = Args();
}

int exec_option_date_stamp() {
    g_args.parse("Test", { "-m*", "-d", "f1.asm" });
    return EXIT_SUCCESS;
}

void test_option_relocatable() {
    g_args = Args();
    create_f1_asm();

    NOK(g_args.opt_relocatable);
    g_args.parse("Test", { "-R", "f1.asm" });
    OK(g_args.opt_relocatable);

    remove_f1_asm();
    g_args = Args();
}

void test_option_reloc_info() {
    g_args = Args();
    create_f1_asm();

    NOK(g_args.opt_reloc_info);
    g_args.parse("Test", { "-reloc-info", "f1.asm" });
    OK(g_args.opt_reloc_info);

    remove_f1_asm();
    g_args = Args();
}

void test_option_origin() {
    g_args = Args();
    create_f1_asm();

    IS(g_args.opt_origin, ORG_NOT_DEFINED);

    g_args.parse("Test", { "-r0", "f1.asm" });
    IS(g_args.opt_origin, 0);

    g_args.parse("Test", { "-r123", "f1.asm" });
    IS(g_args.opt_origin, 123);

    g_args.parse("Test", { "-r$5a5a", "f1.asm" });
    IS(g_args.opt_origin, 0x5a5a);

    g_args.parse("Test", { "-r0xa5a5", "f1.asm" });
    IS(g_args.opt_origin, 0xa5a5);

    RUN_NOK("exec_option_origin");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal option: -r\n");

    remove_f1_asm();
    g_args = Args();
}

int exec_option_origin() {
    g_args.parse("Test", { "-r", "f1.asm" });
    return EXIT_SUCCESS;
}

void test_option_filler() {
    g_args = Args();
    create_f1_asm();

    IS(g_args.opt_filler, 0);

    g_args.parse("Test", { "-f0", "f1.asm" });
    IS(g_args.opt_filler, 0);

    g_args.parse("Test", { "-f123", "f1.asm" });
    IS(g_args.opt_filler, 123);

    g_args.parse("Test", { "-f$5a", "f1.asm" });
    IS(g_args.opt_filler, 0x5a);

    g_args.parse("Test", { "-f0xa5", "f1.asm" });
    IS(g_args.opt_filler, 0xa5);

    RUN_NOK("exec_option_filler_1");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal option: -f\n");

    RUN_NOK("exec_option_filler_2");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: invalid filler (-f) option: 0x100\n");

    remove_f1_asm();
    g_args = Args();
}

int exec_option_filler_1() {
    g_args.parse("Test", { "-f", "f1.asm" });
    return EXIT_SUCCESS;
}

int exec_option_filler_2() {
    g_args.parse("Test", { "-f0x100", "f1.asm" });
    return EXIT_SUCCESS;
}

void test_option_symtable() {
    g_args = Args();
    create_f1_asm();

    NOK(g_args.opt_symtable);
    g_args.parse("Test", { "-s", "f1.asm" });
    OK(g_args.opt_symtable);

    remove_f1_asm();
    g_args = Args();
}

void test_option_list_file() {
    g_args = Args();
    create_f1_asm();

    NOK(g_args.opt_list_file);
    g_args.parse("Test", { "-l", "f1.asm" });
    OK(g_args.opt_list_file);

    remove_f1_asm();
    g_args = Args();
}

void test_option_map_file() {
    g_args = Args();
    create_f1_asm();

    NOK(g_args.opt_map_file);
    g_args.parse("Test", { "-m", "f1.asm" });
    OK(g_args.opt_map_file);

    remove_f1_asm();
    g_args = Args();
}

void test_option_globaldef() {
    g_args = Args();
    create_f1_asm();

    NOK(g_args.opt_globaldef);
    g_args.parse("Test", { "-g", "f1.asm" });
    OK(g_args.opt_globaldef);

    remove_f1_asm();
    g_args = Args();
}

void test_option_appmake() {
    g_args = Args();
    create_f1_asm();

    IS(g_args.opt_appmake, Appmake::none);
    IS(g_args.opt_cpu, CpuId::undef);
    IS(g_args.opt_zfloat, ZFloat::undef);
    IS(g_args.opt_origin, ORG_NOT_DEFINED);

    g_args.parse("Test", { "+zx81", "f1.asm" });
    IS(g_args.opt_appmake, Appmake::zx81);
    IS(g_args.opt_cpu, CpuId::z80);
    IS(g_args.opt_zfloat, ZFloat::zx81);
    IS(g_args.opt_origin, 16514);

    g_args.parse("Test", { "+zx", "f1.asm" });
    IS(g_args.opt_appmake, Appmake::zx);
    IS(g_args.opt_cpu, CpuId::z80);
    IS(g_args.opt_zfloat, ZFloat::zx);
    IS(g_args.opt_origin, 23760);

    RUN_NOK("exec_option_appmake");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: illegal option: +abc\n");

    remove_f1_asm();
    g_args = Args();
}

int exec_option_appmake() {
    g_args.parse("Test", { "+abc", "f1.asm" });
    return EXIT_SUCCESS;
}

void test_option_m4() {
    g_args = Args();

    test_file_spew("f1.asm.m4", "define(`x',INPUT)x\n");
    remove("f1.asm");

    g_args.parse("Test", { "-m4=-DINPUT=nop", "f1.asm.m4" });
    STR_IS(test_file_slurp("f1.asm"), "nop\n");
    IS(g_args.files.size(), static_cast<size_t>(1));
    STR_IS(g_args.files[0], "f1.asm");

    remove("f1.asm");
    remove("f1.asm.m4");
    g_args = Args();
}
