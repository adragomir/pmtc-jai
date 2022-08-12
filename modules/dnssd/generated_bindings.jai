//
// This file was auto-generated using the following command:
//
// /Users/adragomi/work/personal/jaitest/modules/dnssd/generate
//



_DNS_SD_H :: 10970003;

_DNS_SD_LIBDISPATCH :: 1;

CompileTimeAssertionChecks_DNS_SD :: struct {
    assert0: [1] u8;
}

DNSServiceSleepKeepalive :: (sdRef: *DNSServiceRef, flags: DNSServiceFlags, fd: s32, timeout: u32, callBack: DNSServiceSleepKeepaliveReply, _context: *void) -> DNSServiceErrorType #foreign libdnssd;

kDNSServiceMaxServiceName :: 64;

kDNSServiceMaxDomainName :: 1009;

kDNSServiceInterfaceIndexAny :: 0;

DNSServiceSleepKeepaliveReply :: #type (a0: DNSServiceRef, a1: DNSServiceErrorType, a2: *void) -> void #c_call;

DNSServiceSetDispatchQueue :: (service: DNSServiceRef, queue: dispatch_queue_t) -> DNSServiceErrorType #foreign libdnssd;

TXTRecordGetItemAtIndex :: (txtLen: u16, txtRecord: *void, itemIndex: u16, keyBufLen: u16, key: *u8, valueLen: *u8, value: **void) -> DNSServiceErrorType #foreign libdnssd;

TXTRecordGetCount :: (txtLen: u16, txtRecord: *void) -> u16 #foreign libdnssd;

kDNSServiceProperty_DaemonVersion :: "DaemonVersion";

dnssd_sock_t :: s32;

_DNSServiceRef_t :: struct {}
DNSServiceRef :: *_DNSServiceRef_t;
_DNSRecordRef_t :: struct {}
DNSRecordRef :: *_DNSRecordRef_t;

sockaddr :: struct {}

kDNSServiceFlag :: enum u32 {
    sMoreComing             :: 1;

    sAutoTrigger            :: 1;

    sAdd                    :: 2;
    sDefault                :: 4;

    sNoAutoRename           :: 8;

    sShared                 :: 16;
    sUnique                 :: 32;

    sBrowseDomains          :: 64;
    sRegistrationDomains    :: 128;

    sLongLivedQuery         :: 256;

    sAllowRemoteQuery       :: 512;

    sForceMulticast         :: 1024;

    sForce                  :: 2048;

    sKnownUnique            :: 2048;

    sReturnIntermediates    :: 4096;

    sShareConnection        :: 16384;

    sSuppressUnusable       :: 32768;

    sTimeout                :: 65536;

    sIncludeP2P             :: 131072;

    sWakeOnResolve          :: 262144;

    sBackgroundTrafficClass :: 524288;

    sIncludeAWDL            :: 1048576;

    sValidate               :: 2097152;

    sSecure                 :: 2097168;

    sInsecure               :: 2097184;

    sBogus                  :: 2097216;

    sIndeterminate          :: 2097280;

    sUnicastResponse        :: 4194304;

    sValidateOptional       :: 8388608;

    sWakeOnlyService        :: 16777216;

    sThresholdOne           :: 33554432;
    sThresholdFinder        :: 67108864;
    sThresholdReached       :: 33554432;

    sPrivateOne             :: 8192;

    sPrivateTwo             :: 134217728;

    sPrivateThree           :: 268435456;

    sPrivateFour            :: 536870912;

    sPrivateFive            :: 1073741824;

    AnsweredFromCache       :: 1073741824;

    sAllowExpiredAnswers    :: 2147483648;

    sExpiredAnswer          :: 2147483648;

    kDNSServiceFlagsMoreComing             :: sMoreComing;

    kDNSServiceFlagsAutoTrigger            :: sAutoTrigger;

    kDNSServiceFlagsAdd                    :: sAdd;
    kDNSServiceFlagsDefault                :: sDefault;

    kDNSServiceFlagsNoAutoRename           :: sNoAutoRename;

    kDNSServiceFlagsShared                 :: sShared;
    kDNSServiceFlagsUnique                 :: sUnique;

    kDNSServiceFlagsBrowseDomains          :: sBrowseDomains;
    kDNSServiceFlagsRegistrationDomains    :: sRegistrationDomains;

    kDNSServiceFlagsLongLivedQuery         :: sLongLivedQuery;

    kDNSServiceFlagsAllowRemoteQuery       :: sAllowRemoteQuery;

    kDNSServiceFlagsForceMulticast         :: sForceMulticast;

    kDNSServiceFlagsForce                  :: sForce;

    kDNSServiceFlagsKnownUnique            :: sKnownUnique;

    kDNSServiceFlagsReturnIntermediates    :: sReturnIntermediates;

    kDNSServiceFlagsShareConnection        :: sShareConnection;

    kDNSServiceFlagsSuppressUnusable       :: sSuppressUnusable;

    kDNSServiceFlagsTimeout                :: sTimeout;

    kDNSServiceFlagsIncludeP2P             :: sIncludeP2P;

    kDNSServiceFlagsWakeOnResolve          :: sWakeOnResolve;

    kDNSServiceFlagsBackgroundTrafficClass :: sBackgroundTrafficClass;

    kDNSServiceFlagsIncludeAWDL            :: sIncludeAWDL;

    kDNSServiceFlagsValidate               :: sValidate;

    kDNSServiceFlagsSecure                 :: sSecure;

    kDNSServiceFlagsInsecure               :: sInsecure;

    kDNSServiceFlagsBogus                  :: sBogus;

    kDNSServiceFlagsIndeterminate          :: sIndeterminate;

    kDNSServiceFlagsUnicastResponse        :: sUnicastResponse;

    kDNSServiceFlagsValidateOptional       :: sValidateOptional;

    kDNSServiceFlagsWakeOnlyService        :: sWakeOnlyService;

    kDNSServiceFlagsThresholdOne           :: sThresholdOne;
    kDNSServiceFlagsThresholdFinder        :: sThresholdFinder;
    kDNSServiceFlagsThresholdReached       :: sThresholdReached;

    kDNSServiceFlagsPrivateOne             :: sPrivateOne;

    kDNSServiceFlagsPrivateTwo             :: sPrivateTwo;

    kDNSServiceFlagsPrivateThree           :: sPrivateThree;

    kDNSServiceFlagsPrivateFour            :: sPrivateFour;

    kDNSServiceFlagsPrivateFive            :: sPrivateFive;

    kDNSServiceFlagAnsweredFromCache       :: AnsweredFromCache;

    kDNSServiceFlagsAllowExpiredAnswers    :: sAllowExpiredAnswers;

    kDNSServiceFlagsExpiredAnswer          :: sExpiredAnswer;
}

kDNSServiceProtocol :: enum u32 {
    IPv4 :: 1;
    IPv6 :: 2;

    UDP  :: 16;
    TCP  :: 32;

    kDNSServiceProtocol_IPv4 :: IPv4;
    kDNSServiceProtocol_IPv6 :: IPv6;

    kDNSServiceProtocol_UDP  :: UDP;
    kDNSServiceProtocol_TCP  :: TCP;
}

anon_enum :: enum u32 {
    kDNSServiceClass_IN :: 1;
}

kDNSServiceType :: enum u32 {
    A          :: 1;
    NS         :: 2;
    MD         :: 3;
    MF         :: 4;
    CNAME      :: 5;
    SOA        :: 6;
    MB         :: 7;
    MG         :: 8;
    MR         :: 9;
    NULL       :: 10;
    WKS        :: 11;
    PTR        :: 12;
    HINFO      :: 13;
    MINFO      :: 14;
    MX         :: 15;
    TXT        :: 16;
    RP         :: 17;
    AFSDB      :: 18;
    X25        :: 19;
    ISDN       :: 20;
    RT         :: 21;
    NSAP       :: 22;
    NSAP_PTR   :: 23;
    SIG        :: 24;
    KEY        :: 25;
    PX         :: 26;
    GPOS       :: 27;
    AAAA       :: 28;
    LOC        :: 29;
    NXT        :: 30;
    EID        :: 31;
    NIMLOC     :: 32;
    SRV        :: 33;
    ATMA       :: 34;
    NAPTR      :: 35;
    KX         :: 36;
    CERT       :: 37;
    A6         :: 38;
    DNAME      :: 39;
    SINK       :: 40;
    OPT        :: 41;
    APL        :: 42;
    DS         :: 43;
    SSHFP      :: 44;
    IPSECKEY   :: 45;
    RRSIG      :: 46;
    NSEC       :: 47;
    DNSKEY     :: 48;
    DHCID      :: 49;
    NSEC3      :: 50;
    NSEC3PARAM :: 51;

    HIP        :: 55;

    SPF        :: 99;
    UINFO      :: 100;
    UID        :: 101;
    GID        :: 102;
    UNSPEC     :: 103;

    TKEY       :: 249;
    TSIG       :: 250;
    IXFR       :: 251;
    AXFR       :: 252;
    MAILB      :: 253;
    MAILA      :: 254;
    ANY        :: 255;

    kDNSServiceType_A          :: A;
    kDNSServiceType_NS         :: NS;
    kDNSServiceType_MD         :: MD;
    kDNSServiceType_MF         :: MF;
    kDNSServiceType_CNAME      :: CNAME;
    kDNSServiceType_SOA        :: SOA;
    kDNSServiceType_MB         :: MB;
    kDNSServiceType_MG         :: MG;
    kDNSServiceType_MR         :: MR;
    kDNSServiceType_NULL       :: NULL;
    kDNSServiceType_WKS        :: WKS;
    kDNSServiceType_PTR        :: PTR;
    kDNSServiceType_HINFO      :: HINFO;
    kDNSServiceType_MINFO      :: MINFO;
    kDNSServiceType_MX         :: MX;
    kDNSServiceType_TXT        :: TXT;
    kDNSServiceType_RP         :: RP;
    kDNSServiceType_AFSDB      :: AFSDB;
    kDNSServiceType_X25        :: X25;
    kDNSServiceType_ISDN       :: ISDN;
    kDNSServiceType_RT         :: RT;
    kDNSServiceType_NSAP       :: NSAP;
    kDNSServiceType_NSAP_PTR   :: NSAP_PTR;
    kDNSServiceType_SIG        :: SIG;
    kDNSServiceType_KEY        :: KEY;
    kDNSServiceType_PX         :: PX;
    kDNSServiceType_GPOS       :: GPOS;
    kDNSServiceType_AAAA       :: AAAA;
    kDNSServiceType_LOC        :: LOC;
    kDNSServiceType_NXT        :: NXT;
    kDNSServiceType_EID        :: EID;
    kDNSServiceType_NIMLOC     :: NIMLOC;
    kDNSServiceType_SRV        :: SRV;
    kDNSServiceType_ATMA       :: ATMA;
    kDNSServiceType_NAPTR      :: NAPTR;
    kDNSServiceType_KX         :: KX;
    kDNSServiceType_CERT       :: CERT;
    kDNSServiceType_A6         :: A6;
    kDNSServiceType_DNAME      :: DNAME;
    kDNSServiceType_SINK       :: SINK;
    kDNSServiceType_OPT        :: OPT;
    kDNSServiceType_APL        :: APL;
    kDNSServiceType_DS         :: DS;
    kDNSServiceType_SSHFP      :: SSHFP;
    kDNSServiceType_IPSECKEY   :: IPSECKEY;
    kDNSServiceType_RRSIG      :: RRSIG;
    kDNSServiceType_NSEC       :: NSEC;
    kDNSServiceType_DNSKEY     :: DNSKEY;
    kDNSServiceType_DHCID      :: DHCID;
    kDNSServiceType_NSEC3      :: NSEC3;
    kDNSServiceType_NSEC3PARAM :: NSEC3PARAM;

    kDNSServiceType_HIP        :: HIP;

    kDNSServiceType_SPF        :: SPF;
    kDNSServiceType_UINFO      :: UINFO;
    kDNSServiceType_UID        :: UID;
    kDNSServiceType_GID        :: GID;
    kDNSServiceType_UNSPEC     :: UNSPEC;

    kDNSServiceType_TKEY       :: TKEY;
    kDNSServiceType_TSIG       :: TSIG;
    kDNSServiceType_IXFR       :: IXFR;
    kDNSServiceType_AXFR       :: AXFR;
    kDNSServiceType_MAILB      :: MAILB;
    kDNSServiceType_MAILA      :: MAILA;
    kDNSServiceType_ANY        :: ANY;
}

kDNSServiceErr :: enum s32 {
    NoError                   :: 0;
    Unknown                   :: -65537;
    NoSuchName                :: -65538;
    NoMemory                  :: -65539;
    BadParam                  :: -65540;
    BadReference              :: -65541;
    BadState                  :: -65542;
    BadFlags                  :: -65543;
    Unsupported               :: -65544;
    NotInitialized            :: -65545;
    AlreadyRegistered         :: -65547;
    NameConflict              :: -65548;
    Invalid                   :: -65549;
    Firewall                  :: -65550;
    Incompatible              :: -65551;
    BadInterfaceIndex         :: -65552;
    Refused                   :: -65553;
    NoSuchRecord              :: -65554;
    NoAuth                    :: -65555;
    NoSuchKey                 :: -65556;
    NATTraversal              :: -65557;
    DoubleNAT                 :: -65558;
    BadTime                   :: -65559;
    BadSig                    :: -65560;
    BadKey                    :: -65561;
    Transient                 :: -65562;
    ServiceNotRunning         :: -65563;
    NATPortMappingUnsupported :: -65564;
    NATPortMappingDisabled    :: -65565;
    NoRouter                  :: -65566;
    PollingMode               :: -65567;
    Timeout                   :: -65568;
    DefunctConnection         :: -65569;

    kDNSServiceErr_NoError                   :: NoError;
    kDNSServiceErr_Unknown                   :: Unknown;
    kDNSServiceErr_NoSuchName                :: NoSuchName;
    kDNSServiceErr_NoMemory                  :: NoMemory;
    kDNSServiceErr_BadParam                  :: BadParam;
    kDNSServiceErr_BadReference              :: BadReference;
    kDNSServiceErr_BadState                  :: BadState;
    kDNSServiceErr_BadFlags                  :: BadFlags;
    kDNSServiceErr_Unsupported               :: Unsupported;
    kDNSServiceErr_NotInitialized            :: NotInitialized;
    kDNSServiceErr_AlreadyRegistered         :: AlreadyRegistered;
    kDNSServiceErr_NameConflict              :: NameConflict;
    kDNSServiceErr_Invalid                   :: Invalid;
    kDNSServiceErr_Firewall                  :: Firewall;
    kDNSServiceErr_Incompatible              :: Incompatible;
    kDNSServiceErr_BadInterfaceIndex         :: BadInterfaceIndex;
    kDNSServiceErr_Refused                   :: Refused;
    kDNSServiceErr_NoSuchRecord              :: NoSuchRecord;
    kDNSServiceErr_NoAuth                    :: NoAuth;
    kDNSServiceErr_NoSuchKey                 :: NoSuchKey;
    kDNSServiceErr_NATTraversal              :: NATTraversal;
    kDNSServiceErr_DoubleNAT                 :: DoubleNAT;
    kDNSServiceErr_BadTime                   :: BadTime;
    kDNSServiceErr_BadSig                    :: BadSig;
    kDNSServiceErr_BadKey                    :: BadKey;
    kDNSServiceErr_Transient                 :: Transient;
    kDNSServiceErr_ServiceNotRunning         :: ServiceNotRunning;
    kDNSServiceErr_NATPortMappingUnsupported :: NATPortMappingUnsupported;
    kDNSServiceErr_NATPortMappingDisabled    :: NATPortMappingDisabled;
    kDNSServiceErr_NoRouter                  :: NoRouter;
    kDNSServiceErr_PollingMode               :: PollingMode;
    kDNSServiceErr_Timeout                   :: Timeout;
    kDNSServiceErr_DefunctConnection         :: DefunctConnection;
}

DNSServiceFlags :: u32;
DNSServiceProtocol :: u32;
DNSServiceErrorType :: s32;

DNSServiceGetProperty :: (property: *u8, result: *void, size: *u32) -> DNSServiceErrorType #foreign libdnssd;

DNSServiceRefSockFD :: (sdRef: DNSServiceRef) -> dnssd_sock_t #foreign libdnssd;

DNSServiceProcessResult :: (sdRef: DNSServiceRef) -> DNSServiceErrorType #foreign libdnssd;

DNSServiceRefDeallocate :: (sdRef: DNSServiceRef) -> void #foreign libdnssd;

DNSServiceDomainEnumReply :: #type (a0: DNSServiceRef, a1: DNSServiceFlags, a2: u32, a3: DNSServiceErrorType, a4: *u8, a5: *void) -> void #c_call;

DNSServiceEnumerateDomains :: (sdRef: *DNSServiceRef, flags: DNSServiceFlags, interfaceIndex: u32, callBack: DNSServiceDomainEnumReply, _context: *void) -> DNSServiceErrorType #foreign libdnssd;

DNSServiceRegisterReply :: #type (a0: DNSServiceRef, a1: DNSServiceFlags, a2: DNSServiceErrorType, a3: *u8, a4: *u8, a5: *u8, a6: *void) -> void #c_call;

DNSServiceRegister :: (sdRef: *DNSServiceRef, flags: DNSServiceFlags, interfaceIndex: u32, name: *u8, regtype: *u8, domain: *u8, host: *u8, port: u16, txtLen: u16, txtRecord: *void, callBack: DNSServiceRegisterReply, _context: *void) -> DNSServiceErrorType #foreign libdnssd;

DNSServiceAddRecord :: (sdRef: DNSServiceRef, RecordRef: *DNSRecordRef, flags: DNSServiceFlags, rrtype: u16, rdlen: u16, rdata: *void, ttl: u32) -> DNSServiceErrorType #foreign libdnssd;

DNSServiceUpdateRecord :: (sdRef: DNSServiceRef, RecordRef: DNSRecordRef, flags: DNSServiceFlags, rdlen: u16, rdata: *void, ttl: u32) -> DNSServiceErrorType #foreign libdnssd;

DNSServiceRemoveRecord :: (sdRef: DNSServiceRef, RecordRef: DNSRecordRef, flags: DNSServiceFlags) -> DNSServiceErrorType #foreign libdnssd;

DNSServiceBrowseReply :: #type (a0: DNSServiceRef, a1: DNSServiceFlags, a2: u32, a3: DNSServiceErrorType, a4: *u8, a5: *u8, a6: *u8, a7: *void) -> void #c_call;

DNSServiceBrowse :: (sdRef: *DNSServiceRef, flags: DNSServiceFlags, interfaceIndex: u32, regtype: *u8, domain: *u8, callBack: DNSServiceBrowseReply, _context: *void) -> DNSServiceErrorType #foreign libdnssd;

DNSServiceResolveReply :: #type (a0: DNSServiceRef, a1: DNSServiceFlags, a2: u32, a3: DNSServiceErrorType, a4: *u8, a5: *u8, a6: u16, a7: u16, a8: *u8, a9: *void) -> void #c_call;

DNSServiceResolve :: (sdRef: *DNSServiceRef, flags: DNSServiceFlags, interfaceIndex: u32, name: *u8, regtype: *u8, domain: *u8, callBack: DNSServiceResolveReply, _context: *void) -> DNSServiceErrorType #foreign libdnssd;

DNSServiceQueryRecordReply :: #type (a0: DNSServiceRef, a1: DNSServiceFlags, a2: u32, a3: DNSServiceErrorType, a4: *u8, a5: u16, a6: u16, a7: u16, a8: *void, a9: u32, a10: *void) -> void #c_call;

DNSServiceQueryRecord :: (sdRef: *DNSServiceRef, flags: DNSServiceFlags, interfaceIndex: u32, fullname: *u8, rrtype: u16, rrclass: u16, callBack: DNSServiceQueryRecordReply, _context: *void) -> DNSServiceErrorType #foreign libdnssd;

DNSServiceGetAddrInfoReply :: #type (a0: DNSServiceRef, a1: DNSServiceFlags, a2: u32, a3: DNSServiceErrorType, a4: *u8, a5: *sockaddr, a6: u32, a7: *void) -> void #c_call;

DNSServiceGetAddrInfo :: (sdRef: *DNSServiceRef, flags: DNSServiceFlags, interfaceIndex: u32, protocol: DNSServiceProtocol, hostname: *u8, callBack: DNSServiceGetAddrInfoReply, _context: *void) -> DNSServiceErrorType #foreign libdnssd;

DNSServiceCreateConnection :: (sdRef: *DNSServiceRef) -> DNSServiceErrorType #foreign libdnssd;

DNSServiceRegisterRecordReply :: #type (a0: DNSServiceRef, a1: DNSRecordRef, a2: DNSServiceFlags, a3: DNSServiceErrorType, a4: *void) -> void #c_call;

DNSServiceRegisterRecord :: (sdRef: DNSServiceRef, RecordRef: *DNSRecordRef, flags: DNSServiceFlags, interfaceIndex: u32, fullname: *u8, rrtype: u16, rrclass: u16, rdlen: u16, rdata: *void, ttl: u32, callBack: DNSServiceRegisterRecordReply, _context: *void) -> DNSServiceErrorType #foreign libdnssd;

DNSServiceReconfirmRecord :: (flags: DNSServiceFlags, interfaceIndex: u32, fullname: *u8, rrtype: u16, rrclass: u16, rdlen: u16, rdata: *void) -> DNSServiceErrorType #foreign libdnssd;

PeerConnectionRelease :: (flags: DNSServiceFlags, name: *u8, regtype: *u8, domain: *u8) -> DNSServiceErrorType #foreign libdnssd;

DNSServiceNATPortMappingReply :: #type (a0: DNSServiceRef, a1: DNSServiceFlags, a2: u32, a3: DNSServiceErrorType, a4: u32, a5: DNSServiceProtocol, a6: u16, a7: u16, a8: u32, a9: *void) -> void #c_call;

DNSServiceNATPortMappingCreate :: (sdRef: *DNSServiceRef, flags: DNSServiceFlags, interfaceIndex: u32, protocol: DNSServiceProtocol, internalPort: u16, externalPort: u16, ttl: u32, callBack: DNSServiceNATPortMappingReply, _context: *void) -> DNSServiceErrorType #foreign libdnssd;

DNSServiceConstructFullName :: (fullName: *u8, service: *u8, regtype: *u8, domain: *u8) -> DNSServiceErrorType #foreign libdnssd;

_TXTRecordRef_t :: union {
    PrivateData:           [16] u8;
    ForceNaturalAlignment: *u8;
}
TXTRecordRef :: _TXTRecordRef_t;

TXTRecordCreate :: (txtRecord: *TXTRecordRef, bufferLen: u16, buffer: *void) -> void #foreign libdnssd;

TXTRecordDeallocate :: (txtRecord: *TXTRecordRef) -> void #foreign libdnssd;

TXTRecordSetValue :: (txtRecord: *TXTRecordRef, key: *u8, valueSize: u8, value: *void) -> DNSServiceErrorType #foreign libdnssd;

TXTRecordRemoveValue :: (txtRecord: *TXTRecordRef, key: *u8) -> DNSServiceErrorType #foreign libdnssd;

TXTRecordGetLength :: (txtRecord: *TXTRecordRef) -> u16 #foreign libdnssd;

TXTRecordGetBytesPtr :: (txtRecord: *TXTRecordRef) -> *void #foreign libdnssd;

TXTRecordContainsKey :: (txtLen: u16, txtRecord: *void, key: *u8) -> s32 #foreign libdnssd;

TXTRecordGetValuePtr :: (txtLen: u16, txtRecord: *void, key: *u8, valueLen: *u8) -> *void #foreign libdnssd;

#scope_file

libdnssd :: #foreign_system_library "libSystem";
#scope_file

#if OS == .WINDOWS {
    libdnssd :: #foreign_library "win/glfw";
} else #if OS == .LINUX {
    libdnssd :: #foreign_library "linux/libglfw.so";
} else #if OS == .MACOS {
    libdnssd :: #foreign_library "mac/libglfw.dylib";
}
