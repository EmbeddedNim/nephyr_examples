/* Generated by Nim Compiler v1.7.1 */
#define NIM_INTBITS 32

#include "nimbase.h"
#include <sys/types.h>
                          #include <pthread.h>
#include <pthread.h>
#include <string.h>
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
typedef struct tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A;
typedef struct NimStrPayload NimStrPayload;
typedef struct NimStringV2 NimStringV2;
struct tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A {NU64 a0;
NU64 a1;
};
typedef NU8 tyArray__qtqsWM5aXmcpMIVmvq3kAA[16];
struct NimStrPayload {NI cap;
NIM_CHAR data[SEQ_DECL_SIZE];
};
struct NimStringV2 {NI len;
NimStrPayload* p;
};
typedef NU64 tyArray__NzKR9bw29cLPrd712Xt6Liiw[2];
static N_INLINE(void, initLock__coreZlocks_60)(pthread_mutex_t* lock);
static N_INLINE(NIM_BOOL*, nimErrorFlag)(void);
N_LIB_PRIVATE N_NIMCALL(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A, initRand__pureZrandom_247)(void);
static N_INLINE(void, nimZeroMem)(void* p, NI size);
static N_INLINE(void, nimSetMem__systemZmemory_7)(void* a, int v, NI size);
static N_INLINE(void, acquire__coreZlocks_67)(pthread_mutex_t* lock);
static N_INLINE(NIM_BOOL, isValid__pureZrandom_24)(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A r);
N_LIB_PRIVATE N_NIMCALL(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A, getRandomState__pureZrandom_249)(void);
N_LIB_PRIVATE N_NIMCALL(NIM_BOOL, urandom__stdZsysrand_45)(NU8* dest, NI destLen_0);
static N_INLINE(void, copyMem__system_1709)(void* dest, void* source, NI size);
static N_INLINE(void, nimCopyMem)(void* dest, void* source, NI size);
N_LIB_PRIVATE N_NOINLINE(void, raiseOverflow)(void);
N_LIB_PRIVATE N_NIMCALL(void, quit__system_6727)(NimStringV2 errormsg, NI errorcode);
N_LIB_PRIVATE N_NIMCALL(void, skipRandomNumbers__pureZrandom_53)(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A* s);
N_LIB_PRIVATE N_NOINLINE(void, raiseIndexError2)(NI i, NI n);
N_LIB_PRIVATE N_NIMCALL(NU64, next__pureZrandom_44)(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A* r);
N_LIB_PRIVATE N_NIMCALL(NU64, rotl__pureZrandom_32)(NU64 x, NU64 k);
static N_INLINE(void, release__coreZlocks_69)(pthread_mutex_t* lock);
N_LIB_PRIVATE N_NIMCALL(NI, rand__pureZrandom_92)(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A* r, NI max);
N_LIB_PRIVATE N_NIMCALL(NU64, rand__pureZrandom_96)(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A* r, NU64 max);
N_LIB_PRIVATE N_NOINLINE(void, raiseRangeErrorI)(NI64 i, NI64 a, NI64 b);
N_LIB_PRIVATE NIM_CONST tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A DefaultRandSeed__pureZrandom_13 = {7616934476015405061ULL, 15122295919272093642ULL}
;
static const struct {
  NI cap; NIM_CHAR data[81+1];
} TM__AIKkgex03Z1j45JceakCTA_3 = { 81 | NIM_STRLIT_FLAG, "Failed to initializes baseState in random module as sysrand.urandom doesn\'t work." };
static const NimStringV2 TM__AIKkgex03Z1j45JceakCTA_4 = {81, (NimStrPayload*)&TM__AIKkgex03Z1j45JceakCTA_3};
N_LIB_PRIVATE NIM_CONST tyArray__NzKR9bw29cLPrd712Xt6Liiw helper__pureZrandom_55 = {13739361407582206667ULL,
15594563132006766882ULL}
;
N_LIB_PRIVATE tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A state__pureZrandom_14;
N_LIB_PRIVATE pthread_mutex_t baseSeedLock__pureZrandom_245;
N_LIB_PRIVATE tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A baseState__pureZrandom_246;
extern NIM_THREADVAR NIM_BOOL nimInErrorMode__system_4001;

#line 36 "/home/user/.choosenim/toolchains/nim-#devel/lib/core/locks.nim"
static N_INLINE(void, initLock__coreZlocks_60)(pthread_mutex_t* lock) {
#line 39 "/home/user/.choosenim/toolchains/nim-#devel/lib/core/locks.nim"

#line 39 "/home/user/.choosenim/toolchains/nim-#devel/lib/core/locks.nim"
	pthread_mutex_init(lock, ((pthread_mutexattr_t*) NIM_NIL));
}

#line 423 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/excpt.nim"
static N_INLINE(NIM_BOOL*, nimErrorFlag)(void) {	NIM_BOOL* result;	result = (NIM_BOOL*)0;
#line 424 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/excpt.nim"
	result = (&nimInErrorMode__system_4001);	return result;}

#line 19 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/memory.nim"
static N_INLINE(void, nimSetMem__systemZmemory_7)(void* a, int v, NI size) {	void* T1_;
#line 21 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/memory.nim"

#line 21 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/memory.nim"
	T1_ = (void*)0;	T1_ = memset(a, v, ((size_t) (size)));}

#line 30 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/memory.nim"
static N_INLINE(void, nimZeroMem)(void* p, NI size) {NIM_BOOL* nimErr_;{nimErr_ = nimErrorFlag();
#line 31 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/memory.nim"

#line 31 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/memory.nim"
	nimSetMem__systemZmemory_7(p, ((int) 0), size);
	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;	}BeforeRet_: ;
}

#line 49 "/home/user/.choosenim/toolchains/nim-#devel/lib/core/locks.nim"
static N_INLINE(void, acquire__coreZlocks_67)(pthread_mutex_t* lock) {
#line 52 "/home/user/.choosenim/toolchains/nim-#devel/lib/core/locks.nim"

#line 52 "/home/user/.choosenim/toolchains/nim-#devel/lib/core/locks.nim"
	pthread_mutex_lock(lock);
}

#line 118 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
static N_INLINE(NIM_BOOL, isValid__pureZrandom_24)(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A r) {	NIM_BOOL result;	NIM_BOOL T1_;	result = (NIM_BOOL)0;
#line 119 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 123 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 123 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	T1_ = (NIM_BOOL)0;
#line 123 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	T1_ = (r.a0 == 0ULL);	if (!(T1_)) goto LA2_;

#line 123 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	T1_ = (r.a1 == 0ULL);	LA2_: ;
	result = !(T1_);	return result;}

#line 8 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/memory.nim"
static N_INLINE(void, nimCopyMem)(void* dest, void* source, NI size) {	void* T1_;
#line 10 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/memory.nim"

#line 10 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/memory.nim"
	T1_ = (void*)0;	T1_ = memcpy(dest, source, ((size_t) (size)));}

#line 2231 "/home/user/.choosenim/toolchains/nim-#devel/lib/system.nim"
static N_INLINE(void, copyMem__system_1709)(void* dest, void* source, NI size) {
#line 2232 "/home/user/.choosenim/toolchains/nim-#devel/lib/system.nim"

#line 2232 "/home/user/.choosenim/toolchains/nim-#devel/lib/system.nim"
	nimCopyMem(dest, source, size);
}

#line 660 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
N_LIB_PRIVATE N_NIMCALL(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A, getRandomState__pureZrandom_249)(void) {	tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A result;	tyArray__qtqsWM5aXmcpMIVmvq3kAA urand;NIM_BOOL* nimErr_;{nimErr_ = nimErrorFlag();	nimZeroMem((void*)(&result), sizeof(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A));	nimZeroMem((void*)urand, sizeof(tyArray__qtqsWM5aXmcpMIVmvq3kAA));	{		NI i;		NI res;		i = (NI)0;
#line 90 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/iterators_1.nim"
		res = ((NI) 0);		{
#line 91 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/iterators_1.nim"
			while (1) {				NI TM__AIKkgex03Z1j45JceakCTA_2;
#line 91 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/iterators_1.nim"
				if (!(res <= ((NI) 7))) goto LA3;

#line 670 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
				i = res;
#line 670 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
				{					NIM_BOOL T6_;
#line 671 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 671 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
					T6_ = (NIM_BOOL)0;					T6_ = urandom__stdZsysrand_45(urand, 16);					if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;					if (!T6_) goto LA7_;

#line 672 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 672 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
					copyMem__system_1709(((void*) ((&result))), ((void*) ((&urand[(((NI) 0))- 0]))), ((NI) 16));

#line 673 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
					{						NIM_BOOL T11_;
#line 673 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 673 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
						T11_ = (NIM_BOOL)0;						T11_ = isValid__pureZrandom_24(result);						if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;						if (!T11_) goto LA12_;

#line 674 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
						goto LA1;
					}
					LA12_: ;
				}
				LA7_: ;

#line 93 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/iterators_1.nim"
				if (nimAddInt(res, ((NI) 1), &TM__AIKkgex03Z1j45JceakCTA_2)) { raiseOverflow(); goto BeforeRet_;};				res = (NI)(TM__AIKkgex03Z1j45JceakCTA_2);			} LA3: ;
		}
	} LA1: ;

#line 676 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	{		NIM_BOOL T16_;
#line 676 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 676 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 676 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
		T16_ = (NIM_BOOL)0;		T16_ = isValid__pureZrandom_24(result);		if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;		if (!!(T16_)) goto LA17_;

#line 679 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 679 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
		quit__system_6727(TM__AIKkgex03Z1j45JceakCTA_4, ((NI) 1));
	}
	LA17_: ;
	}BeforeRet_: ;
	return result;}

#line 131 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
N_LIB_PRIVATE N_NIMCALL(NU64, rotl__pureZrandom_32)(NU64 x, NU64 k) {	NU64 result;	result = (NU64)0;
#line 132 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 132 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 132 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 132 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 132 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	result = (NU64)((NU64)((NU64)(x) << (NU64)(k)) | (NU64)((NU64)(x) >> (NU64)((NU64)((NU64)(64ULL) - (NU64)(k)))));	return result;}

#line 134 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
N_LIB_PRIVATE N_NIMCALL(NU64, next__pureZrandom_44)(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A* r) {	NU64 result;	NU64 s0;	NU64 s1;	NU64 T1_;	NU64 T2_;NIM_BOOL* nimErr_;{nimErr_ = nimErrorFlag();	result = (NU64)0;
#line 150 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	s0 = (*r).a0;
#line 151 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	s1 = (*r).a1;
#line 152 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 152 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	result = (NU64)((NU64)(s0) + (NU64)(s1));
#line 153 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 153 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	s1 = (NU64)(s1 ^ s0);
#line 154 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 154 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 154 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 154 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 154 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	T1_ = (NU64)0;	T1_ = rotl__pureZrandom_32(s0, 55ULL);	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;
#line 154 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	(*r).a0 = (NU64)((NU64)(T1_ ^ s1) ^ (NU64)((NU64)(s1) << (NU64)(((NI) 14))));
#line 155 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 155 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	T2_ = (NU64)0;	T2_ = rotl__pureZrandom_32(s1, 36ULL);	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;	(*r).a1 = T2_;	}BeforeRet_: ;
	return result;}

#line 157 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
N_LIB_PRIVATE N_NIMCALL(void, skipRandomNumbers__pureZrandom_53)(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A* s) {	NU64 s0;	NU64 s1;NIM_BOOL* nimErr_;{nimErr_ = nimErrorFlag();
#line 205 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	s0 = 0ULL;
#line 206 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	s1 = 0ULL;	{		NI i;		NI res;		i = (NI)0;
#line 90 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/iterators_1.nim"
		res = ((NI) 0);		{
#line 91 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/iterators_1.nim"
			while (1) {				NI TM__AIKkgex03Z1j45JceakCTA_6;
#line 91 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/iterators_1.nim"
				if (!(res <= ((NI) 1))) goto LA3;

#line 207 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
				i = res;				{					NI b;					NI i_2;					b = (NI)0;
#line 119 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/iterators_1.nim"
					i_2 = ((NI) 0);					{
#line 120 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/iterators_1.nim"
						while (1) {							NU64 T11_;							NI TM__AIKkgex03Z1j45JceakCTA_5;
#line 120 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/iterators_1.nim"
							if (!(i_2 < ((NI) 64))) goto LA6;

#line 208 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
							b = i_2;
#line 208 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
							{
#line 209 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 209 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 209 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
								if ((NU)(i) > (NU)(1)){ raiseIndexError2(i, 1); goto BeforeRet_;}
#line 209 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
								if (!!(((NU64)(helper__pureZrandom_55[(i)- 0] & (NU64)((NU64)(1ULL) << (NU64)(((NU64) (b))))) == 0ULL))) goto LA9_;

#line 210 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 210 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
								s0 = (NU64)(s0 ^ (*s).a0);
#line 211 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 211 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
								s1 = (NU64)(s1 ^ (*s).a1);							}
							LA9_: ;

#line 208 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 212 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 212 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
							T11_ = (NU64)0;							T11_ = next__pureZrandom_44(s);							if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;							(void)(T11_);

#line 122 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/iterators_1.nim"
							if (nimAddInt(i_2, ((NI) 1), &TM__AIKkgex03Z1j45JceakCTA_5)) { raiseOverflow(); goto BeforeRet_;};							i_2 = (NI)(TM__AIKkgex03Z1j45JceakCTA_5);						} LA6: ;
					}
				}

#line 93 "/home/user/.choosenim/toolchains/nim-#devel/lib/system/iterators_1.nim"
				if (nimAddInt(res, ((NI) 1), &TM__AIKkgex03Z1j45JceakCTA_6)) { raiseOverflow(); goto BeforeRet_;};				res = (NI)(TM__AIKkgex03Z1j45JceakCTA_6);			} LA3: ;
		}
	}

#line 213 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	(*s).a0 = s0;
#line 214 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	(*s).a1 = s1;	}BeforeRet_: ;
}

#line 54 "/home/user/.choosenim/toolchains/nim-#devel/lib/core/locks.nim"
static N_INLINE(void, release__coreZlocks_69)(pthread_mutex_t* lock) {
#line 57 "/home/user/.choosenim/toolchains/nim-#devel/lib/core/locks.nim"

#line 57 "/home/user/.choosenim/toolchains/nim-#devel/lib/core/locks.nim"
	pthread_mutex_unlock(lock);
}

#line 645 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
N_LIB_PRIVATE N_NIMCALL(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A, initRand__pureZrandom_247)(void) {	tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A result;NIM_BOOL oldNimErrFin1_;NIM_BOOL* nimErr_;{nimErr_ = nimErrorFlag();	nimZeroMem((void*)(&result), sizeof(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A));
#line 84 "/home/user/.choosenim/toolchains/nim-#devel/lib/core/locks.nim"

#line 84 "/home/user/.choosenim/toolchains/nim-#devel/lib/core/locks.nim"
	acquire__coreZlocks_67((&baseSeedLock__pureZrandom_245));
	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;
#line 683 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	{		NIM_BOOL T4_;		tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A T7_;
#line 683 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 683 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 683 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
		T4_ = (NIM_BOOL)0;		T4_ = isValid__pureZrandom_24(baseState__pureZrandom_246);		if (NIM_UNLIKELY(*nimErr_)) goto LA1_;		if (!!(T4_)) goto LA5_;

#line 684 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 684 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
		nimZeroMem((void*)(&T7_), sizeof(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A));		T7_ = getRandomState__pureZrandom_249();		if (NIM_UNLIKELY(*nimErr_)) goto LA1_;		baseState__pureZrandom_246 = T7_;	}
	LA5_: ;

#line 685 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	result = baseState__pureZrandom_246;
#line 686 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 686 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	skipRandomNumbers__pureZrandom_53((&baseState__pureZrandom_246));
	if (NIM_UNLIKELY(*nimErr_)) goto LA1_;	{		LA1_:;	}
	{		oldNimErrFin1_ = *nimErr_; *nimErr_ = NIM_FALSE;
#line 89 "/home/user/.choosenim/toolchains/nim-#devel/lib/core/locks.nim"

#line 89 "/home/user/.choosenim/toolchains/nim-#devel/lib/core/locks.nim"
		release__coreZlocks_69((&baseSeedLock__pureZrandom_245));
		if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;		*nimErr_ = oldNimErrFin1_;	}
	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;	}BeforeRet_: ;
	return result;}

#line 696 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
N_LIB_PRIVATE N_NIMCALL(void, randomize__pureZrandom_270)(void) {	tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A T1_;NIM_BOOL* nimErr_;{nimErr_ = nimErrorFlag();
#line 711 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 711 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	nimZeroMem((void*)(&T1_), sizeof(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A));	T1_ = initRand__pureZrandom_247();	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;	state__pureZrandom_14 = T1_;	}BeforeRet_: ;
}

#line 216 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
N_LIB_PRIVATE N_NIMCALL(NU64, rand__pureZrandom_96)(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A* r, NU64 max) {	NU64 result;NIM_BOOL* nimErr_;{nimErr_ = nimErrorFlag();	result = (NU64)0;
#line 218 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	{
#line 218 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
		if (!(max == 0ULL)) goto LA3_;

#line 218 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
		goto BeforeRet_;
	}
	goto LA1_;
	LA3_: ;
	{		NU64 max_2;
#line 220 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
		max_2 = max;
#line 222 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
		{
#line 222 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
			if (!(max_2 == 18446744073709551615ULL)) goto LA8_;

#line 222 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 222 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 222 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 222 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
			result = next__pureZrandom_44(r);			if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;			goto BeforeRet_;
		}
		LA8_: ;
		{
#line 223 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
			while (1) {				NU64 x;
#line 224 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 224 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
				x = next__pureZrandom_44(r);				if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;
#line 226 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
				{
#line 226 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 226 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 226 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
					if (!((NU64)(x) <= (NU64)((NU64)((NU64)(18446744073709551615ULL) - (NU64)((NU64)((NU64)(18446744073709551615ULL) % (NU64)(max_2))))))) goto LA14_;

#line 227 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 227 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 227 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 227 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
					result = (NU64)((NU64)(x) % (NU64)((NU64)((NU64)(max_2) + (NU64)(1ULL))));					goto BeforeRet_;
				}
				LA14_: ;
			}
		}
	}
	LA1_: ;
	}BeforeRet_: ;
	return result;}

#line 229 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
N_LIB_PRIVATE N_NIMCALL(NI, rand__pureZrandom_92)(tyObject_Rand__liBKmwv1H6v7oYBhDFHa6A* r, NI max) {	NI result;	NU64 T1_;NIM_BOOL* nimErr_;{nimErr_ = nimErrorFlag();	result = (NI)0;
#line 230 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 243 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 243 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	T1_ = (NU64)0;	T1_ = rand__pureZrandom_96(r, ((NU64) (max)));	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;	result = ((NI) (T1_));	}BeforeRet_: ;
	return result;}

#line 246 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
N_LIB_PRIVATE N_NIMCALL(NI, rand__pureZrandom_115)(NI max) {	NI result;NIM_BOOL* nimErr_;{nimErr_ = nimErrorFlag();	result = (NI)0;
#line 247 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 265 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	if ((max) < ((NI) 0) || (max) > ((NI) 2147483647)){ raiseRangeErrorI(max, ((NI) 0), ((NI) 2147483647)); goto BeforeRet_;}
#line 265 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	result = rand__pureZrandom_92((&state__pureZrandom_14), ((NI) (max)));	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;	}BeforeRet_: ;
	return result;}
N_LIB_PRIVATE N_NIMCALL(void, stdlib_randomInit000)(void) {

#line 999999 "generated_not_to_break_here"
{
NIM_BOOL* nimErr_;nimErr_ = nimErrorFlag();
#line 116 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	state__pureZrandom_14 = DefaultRandSeed__pureZrandom_13;
#line 641 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"

#line 641 "/home/user/.choosenim/toolchains/nim-#devel/lib/pure/random.nim"
	initLock__coreZlocks_60((&baseSeedLock__pureZrandom_245));
	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;	BeforeRet_: ;
}
}

