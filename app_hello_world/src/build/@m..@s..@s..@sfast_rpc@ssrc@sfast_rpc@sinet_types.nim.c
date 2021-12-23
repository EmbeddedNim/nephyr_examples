/* Generated by Nim Compiler v1.7.1 */
#define NIM_INTBITS 32

#include "nimbase.h"
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
typedef struct tyObject_InetAddress__wVPoBlPbPXra4wAolQEAdg tyObject_InetAddress__wVPoBlPbPXra4wAolQEAdg;
typedef struct tyObject_IpAddress__t0yd6ha54oWXm7nwZ4QqfA tyObject_IpAddress__t0yd6ha54oWXm7nwZ4QqfA;
typedef struct NimStrPayload NimStrPayload;
typedef struct NimStringV2 NimStringV2;
typedef struct TNimTypeV2 TNimTypeV2;
typedef struct tyObject_InetClientDisconnected__1CvcxxdV2lnOths4lIcDCA tyObject_InetClientDisconnected__1CvcxxdV2lnOths4lIcDCA;
typedef struct tyObject_OSError__BeJgrOdDsczOwEWOZbRfKA tyObject_OSError__BeJgrOdDsczOwEWOZbRfKA;
typedef struct tyObject_CatchableError__qrLSDoe2oBoAqNtJ9badtnA tyObject_CatchableError__qrLSDoe2oBoAqNtJ9badtnA;
typedef struct Exception Exception;
typedef struct RootObj RootObj;
typedef struct tySequence__uB9b75OUPRENsBAu4AnoePA tySequence__uB9b75OUPRENsBAu4AnoePA;
typedef struct tySequence__uB9b75OUPRENsBAu4AnoePA_Content tySequence__uB9b75OUPRENsBAu4AnoePA_Content;
typedef struct tyObject_StackTraceEntry__oLyohQ7O2XOvGnflOss8EA tyObject_StackTraceEntry__oLyohQ7O2XOvGnflOss8EA;
typedef NU8 tyEnum_IpAddressFamily__iqqacz9cr9bcNjYY74E10wPA;
typedef NU8 tyArray__qtqsWM5aXmcpMIVmvq3kAA[16];
typedef NU8 tyArray__H8qf9bpC2ziYA2earmO8m7w[4];
struct tyObject_IpAddress__t0yd6ha54oWXm7nwZ4QqfA {tyEnum_IpAddressFamily__iqqacz9cr9bcNjYY74E10wPA family;
union{
struct {tyArray__qtqsWM5aXmcpMIVmvq3kAA address_v6;
} _family_1;
struct {tyArray__H8qf9bpC2ziYA2earmO8m7w address_v4;
} _family_2;
};
};
typedef NU8 tyEnum_Protocol__dqJ1OqRGclxIMMdSLRzzXg;
typedef NU8 tyEnum_SockType__NQT1bItGG2X9byGdrWX7ujw;
struct tyObject_InetAddress__wVPoBlPbPXra4wAolQEAdg {tyObject_IpAddress__t0yd6ha54oWXm7nwZ4QqfA host;
NU16 port;
tyEnum_Protocol__dqJ1OqRGclxIMMdSLRzzXg protocol;
tyEnum_SockType__NQT1bItGG2X9byGdrWX7ujw socktype;
};
struct NimStrPayload {NI cap;
NIM_CHAR data[SEQ_DECL_SIZE];
};
struct NimStringV2 {NI len;
NimStrPayload* p;
};
typedef NU8 tyEnum_Domain__Q79bEtFARvq0ekDNtvj3Vqg;
struct TNimTypeV2 {void* destructor;
NI size;
NI align;
NCSTRING name;
void* traceImpl;
void* typeInfoV1;
NI flags;
};
struct RootObj {TNimTypeV2* m_type;};
struct tySequence__uB9b75OUPRENsBAu4AnoePA {
  NI len; tySequence__uB9b75OUPRENsBAu4AnoePA_Content* p;
};
struct Exception {  RootObj Sup;Exception* parent;
NCSTRING name;
NimStringV2 message;
tySequence__uB9b75OUPRENsBAu4AnoePA trace;
Exception* up;
};
struct tyObject_CatchableError__qrLSDoe2oBoAqNtJ9badtnA {  Exception Sup;};
struct tyObject_OSError__BeJgrOdDsczOwEWOZbRfKA {  tyObject_CatchableError__qrLSDoe2oBoAqNtJ9badtnA Sup;NI32 errorCode;
};
struct tyObject_InetClientDisconnected__1CvcxxdV2lnOths4lIcDCA {  tyObject_OSError__BeJgrOdDsczOwEWOZbRfKA Sup;};
struct tyObject_StackTraceEntry__oLyohQ7O2XOvGnflOss8EA {NCSTRING procname;
NI line;
NCSTRING filename;
};


#ifndef tySequence__uB9b75OUPRENsBAu4AnoePA_Content_PP
#define tySequence__uB9b75OUPRENsBAu4AnoePA_Content_PP
struct tySequence__uB9b75OUPRENsBAu4AnoePA_Content { NI cap; tyObject_StackTraceEntry__oLyohQ7O2XOvGnflOss8EA data[SEQ_DECL_SIZE];};
#endif

      static N_INLINE(void, nimZeroMem)(void* p, NI size);
static N_INLINE(void, nimSetMem__systemZmemory_7)(void* a, int v, NI size);
static N_INLINE(NIM_BOOL*, nimErrorFlag)(void);
N_LIB_PRIVATE N_NIMCALL(tyObject_IpAddress__t0yd6ha54oWXm7nwZ4QqfA, parseIpAddress__pureZnet_369)(NimStringV2 addressStr);
N_LIB_PRIVATE N_NIMCALL(tyEnum_SockType__NQT1bItGG2X9byGdrWX7ujw, toSockType__pureZnativesockets_128)(tyEnum_Protocol__dqJ1OqRGclxIMMdSLRzzXg protocol);
N_LIB_PRIVATE N_NIMCALL(void, eqdestroy___OOZOOZOOZfast95rpcZsrcZfast95rpcZsocketserverZcommon95handlers_11)(tyObject_InetClientDisconnected__1CvcxxdV2lnOths4lIcDCA* dest);
N_LIB_PRIVATE TNimTypeV2 NTIv2__1CvcxxdV2lnOths4lIcDCA_;
extern NIM_THREADVAR NIM_BOOL nimInErrorMode__system_4013;

#line 19 "/home/user/.choosenim/toolchains/nim-#c17baaefbcff5c207a4e95242fa0790e64ca6c8c/lib/system/memory.nim"
static N_INLINE(void, nimSetMem__systemZmemory_7)(void* a, int v, NI size) {	void* T1_;
#line 21 "/home/user/.choosenim/toolchains/nim-#c17baaefbcff5c207a4e95242fa0790e64ca6c8c/lib/system/memory.nim"

#line 21 "/home/user/.choosenim/toolchains/nim-#c17baaefbcff5c207a4e95242fa0790e64ca6c8c/lib/system/memory.nim"
	T1_ = (void*)0;	T1_ = memset(a, v, ((size_t) (size)));}

#line 423 "/home/user/.choosenim/toolchains/nim-#c17baaefbcff5c207a4e95242fa0790e64ca6c8c/lib/system/excpt.nim"
static N_INLINE(NIM_BOOL*, nimErrorFlag)(void) {	NIM_BOOL* result;	result = (NIM_BOOL*)0;
#line 424 "/home/user/.choosenim/toolchains/nim-#c17baaefbcff5c207a4e95242fa0790e64ca6c8c/lib/system/excpt.nim"
	result = (&nimInErrorMode__system_4013);	return result;}

#line 30 "/home/user/.choosenim/toolchains/nim-#c17baaefbcff5c207a4e95242fa0790e64ca6c8c/lib/system/memory.nim"
static N_INLINE(void, nimZeroMem)(void* p, NI size) {NIM_BOOL* nimErr_;{nimErr_ = nimErrorFlag();
#line 31 "/home/user/.choosenim/toolchains/nim-#c17baaefbcff5c207a4e95242fa0790e64ca6c8c/lib/system/memory.nim"

#line 31 "/home/user/.choosenim/toolchains/nim-#c17baaefbcff5c207a4e95242fa0790e64ca6c8c/lib/system/memory.nim"
	nimSetMem__systemZmemory_7(p, ((int) 0), size);
	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;	}BeforeRet_: ;
}

#line 42 "/home/user/fast_rpc/src/fast_rpc/inet_types.nim"
N_LIB_PRIVATE N_NIMCALL(tyObject_InetAddress__wVPoBlPbPXra4wAolQEAdg, newInetAddr__OOZOOZOOZfast95rpcZsrcZfast95rpcZinet95types_60)(NimStringV2 host, NI port, tyEnum_Protocol__dqJ1OqRGclxIMMdSLRzzXg protocol) {	tyObject_InetAddress__wVPoBlPbPXra4wAolQEAdg result;	tyObject_IpAddress__t0yd6ha54oWXm7nwZ4QqfA T1_;	tyEnum_SockType__NQT1bItGG2X9byGdrWX7ujw T2_;NIM_BOOL* nimErr_;{nimErr_ = nimErrorFlag();	nimZeroMem((void*)(&result), sizeof(tyObject_InetAddress__wVPoBlPbPXra4wAolQEAdg));
#line 43 "/home/user/fast_rpc/src/fast_rpc/inet_types.nim"

#line 43 "/home/user/fast_rpc/src/fast_rpc/inet_types.nim"
	nimZeroMem((void*)(&T1_), sizeof(tyObject_IpAddress__t0yd6ha54oWXm7nwZ4QqfA));	T1_ = parseIpAddress__pureZnet_369(host);	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;	result.host = T1_;
#line 44 "/home/user/fast_rpc/src/fast_rpc/inet_types.nim"
	result.port = ((NU16) (port));
#line 45 "/home/user/fast_rpc/src/fast_rpc/inet_types.nim"
	result.protocol = protocol;
#line 46 "/home/user/fast_rpc/src/fast_rpc/inet_types.nim"

#line 46 "/home/user/fast_rpc/src/fast_rpc/inet_types.nim"
	T2_ = (tyEnum_SockType__NQT1bItGG2X9byGdrWX7ujw)0;	T2_ = toSockType__pureZnativesockets_128(protocol);	if (NIM_UNLIKELY(*nimErr_)) goto BeforeRet_;	result.socktype = T2_;	}BeforeRet_: ;
	return result;}

#line 64 "/home/user/fast_rpc/src/fast_rpc/inet_types.nim"
N_LIB_PRIVATE N_NIMCALL(tyEnum_Domain__Q79bEtFARvq0ekDNtvj3Vqg, inetDomain__OOZOOZOOZfast95rpcZsrcZfast95rpcZinet95types_119)(tyObject_InetAddress__wVPoBlPbPXra4wAolQEAdg inetaddr) {	tyEnum_Domain__Q79bEtFARvq0ekDNtvj3Vqg result;	result = (tyEnum_Domain__Q79bEtFARvq0ekDNtvj3Vqg)0;
#line 65 "/home/user/fast_rpc/src/fast_rpc/inet_types.nim"
	switch (inetaddr.host.family) {
	case ((tyEnum_IpAddressFamily__iqqacz9cr9bcNjYY74E10wPA) 1):
	{
#line 67 "/home/user/fast_rpc/src/fast_rpc/inet_types.nim"
		result = ((tyEnum_Domain__Q79bEtFARvq0ekDNtvj3Vqg) 2);	}
	break;
	case ((tyEnum_IpAddressFamily__iqqacz9cr9bcNjYY74E10wPA) 0):
	{
#line 69 "/home/user/fast_rpc/src/fast_rpc/inet_types.nim"
		result = ((tyEnum_Domain__Q79bEtFARvq0ekDNtvj3Vqg) 23);	}
	break;
	}
	return result;}
N_LIB_PRIVATE N_NIMCALL(void, fast_rpc_inet_typesDatInit000)(void) {

#line 999999 "generated_not_to_break_here"
NTIv2__1CvcxxdV2lnOths4lIcDCA_.destructor = (void*)eqdestroy___OOZOOZOOZfast95rpcZsrcZfast95rpcZsocketserverZcommon95handlers_11; NTIv2__1CvcxxdV2lnOths4lIcDCA_.size = sizeof(tyObject_InetClientDisconnected__1CvcxxdV2lnOths4lIcDCA); NTIv2__1CvcxxdV2lnOths4lIcDCA_.align = NIM_ALIGNOF(tyObject_InetClientDisconnected__1CvcxxdV2lnOths4lIcDCA); NTIv2__1CvcxxdV2lnOths4lIcDCA_.name = "|fast_rpc.inet_types.InetClientDisconnected|OSError|CatchableError|Exception|RootObj|";
; NTIv2__1CvcxxdV2lnOths4lIcDCA_.traceImpl = (void*)NIM_NIL; NTIv2__1CvcxxdV2lnOths4lIcDCA_.flags = 0;}

