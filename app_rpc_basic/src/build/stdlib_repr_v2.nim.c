/* Generated by Nim Compiler v1.7.1 */
#define NIM_INTBITS 32

#include "nimbase.h"
#undef LANGUAGE_C
#undef MIPSEB
#undef MIPSEL
#undef PPC
#undef R3000
#undef R4000
#undef i386
#undef linux
#undef mips
#undef near
#undef far
#undef powerpc
#undef unix
#define nimfr_(x, y)
#define nimln_(x, y)
typedef struct NimStrPayload NimStrPayload;
typedef struct NimStringV2 NimStringV2;
struct NimStrPayload {NI cap;
NIM_CHAR data[SEQ_DECL_SIZE];
};
struct NimStringV2 {NI len;
NimStrPayload* p;
};
N_LIB_PRIVATE N_NIMCALL(NimStringV2, dollar___systemZdollars_3)(NI x);
static N_INLINE(NIM_BOOL*, nimErrorFlag)(void);
extern NIM_THREADVAR NIM_BOOL nimInErrorMode__system_4013;

#line 423 "/home/user/.choosenim/toolchains/nim-#c17baaefbcff5c207a4e95242fa0790e64ca6c8c/lib/system/excpt.nim"
static N_INLINE(NIM_BOOL*, nimErrorFlag)(void) {	NIM_BOOL* result;	result = (NIM_BOOL*)0;
#line 424 "/home/user/.choosenim/toolchains/nim-#c17baaefbcff5c207a4e95242fa0790e64ca6c8c/lib/system/excpt.nim"
	result = (&nimInErrorMode__system_4013);	return result;}

#line 11 "/home/user/.choosenim/toolchains/nim-#c17baaefbcff5c207a4e95242fa0790e64ca6c8c/lib/system/repr_v2.nim"
N_LIB_PRIVATE N_NIMCALL(NimStringV2, repr__systemZrepr95v50_16)(NI x) {	NimStringV2 result;NIM_BOOL* nimErr_;{nimErr_ = nimErrorFlag();	result.len = 0; result.p = NIM_NIL;
#line 13 "/home/user/.choosenim/toolchains/nim-#c17baaefbcff5c207a4e95242fa0790e64ca6c8c/lib/system/repr_v2.nim"

#line 13 "/home/user/.choosenim/toolchains/nim-#c17baaefbcff5c207a4e95242fa0790e64ca6c8c/lib/system/repr_v2.nim"
	result = dollar___systemZdollars_3(x);	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;	}BeforeRet_: ;
	return result;}
