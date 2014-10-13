#import "LoggerClient.h"

// Log level usual usage:
// Level 0: errors only!
// Level 1: important informations, app states…
// Level 2: less important logs, network requests…
// Level 3: network responses, datas and images…
// Level 4: really not important stuff.

#ifdef DEBUG

#define LoggerError(level, ...)         LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Error", level, __VA_ARGS__)
#define LoggerApp(level, ...)           LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"App", level, __VA_ARGS__)
#define LoggerView(level, ...)          LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"View", level, __VA_ARGS__)
#define LoggerService(level, ...)       LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Service", level, __VA_ARGS__)
#define LoggerModel(level, ...)         LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Model", level, __VA_ARGS__)
#define LoggerData(level, ...)          LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Data", level, __VA_ARGS__)
#define LoggerNetwork(level, ...)       LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Network", level, __VA_ARGS__)
#define LoggerLocation(level, ...)      LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Location", level, __VA_ARGS__)
#define LoggerPush(level, ...)          LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Push", level, __VA_ARGS__)
#define LoggerFile(level, ...)          LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"File", level, __VA_ARGS__)
#define LoggerSharing(level, ...)       LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Sharing", level, __VA_ARGS__)
#define LoggerAd(level, ...)            LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Ad and Stat", level, __VA_ARGS__)

#else

#define LoggerError(...)                while(0) {}
#define LoggerApp(level, ...)           while(0) {}
#define LoggerView(...)                 while(0) {}
#define LoggerService(...)              while(0) {}
#define LoggerModel(...)                while(0) {}
#define LoggerData(...)                 while(0) {}
#define LoggerNetwork(...)              while(0) {}
#define LoggerLocation(...)             while(0) {}
#define LoggerPush(...)                 while(0) {}
#define LoggerFile(...)                 while(0) {}
#define LoggerSharing(...)              while(0) {}
#define LoggerAd(...)                   while(0) {}

#endif

#define nslogger_xstr(s) nslogger_str(s)
#define nslogger_str(s) #s

#define LoggerStartForBuildUser() LoggerSetupBonjour(LoggerGetDefaultLogger(), NULL, CFSTR(nslogger_xstr(NSLOGGER_BUILD_USERNAME)))



#define IP @"127.0.0.1"

//初始化日志
#define INIT_LOG(code) do{    \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{\
LoggerSetViewerHost(NULL, (CFStringRef)IP, (UInt32)50000); \
LoggerSetOptions(NULL, kLoggerOption_BufferLogsUntilConnection | kLoggerOption_UseSSL);  \
});    \
code;\
} while(0)

#define DEBUG_//打开日志输出宏

//#define NSLOG_NO_DEBUG_  //关闭NSLog的输出

#define DEBUG_LEVEL_FATAL   0
#define DEBUG_LEVEL_ERROR   1
#define DEBUG_LEVEL_WARNING 2
#define DEBUG_LEVEL_DEBUG   3
#define DEBUG_LEVEL_INFO    4

#define DEBUG_LEVEL DEBUG_LEVEL_INFO//设置日志输出级别

#ifdef DEBUG_

#define DEBUG_INFO_DETAIL_   //是否打开输出info类的详细信息

//原始日志定义
#define LOG_NETWORK(level, ...)     INIT_LOG(LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"network",level,__VA_ARGS__))
#define LOG_GENERAL(level, ...)     INIT_LOG(LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"general",level,__VA_ARGS__))
#define LOG_UI(level, ...)          INIT_LOG(LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"ui",level,__VA_ARGS__))


#ifdef NSLOG_NO_DEBUG_
#define NSLog(...) do{}while(0)
#endif

#else
#define NSLog(...) do{}while(0)
#define LOG_NETWORK(level, ...)     do{}while(0)
#define LOG_GENERAL(level, ...)     do{}while(0)
#define LOG_UI(level, ...)          do{}while(0)
#endif

#define LOG_NETWORK_FATAL(...)      do{if(DEBUG_LEVEL >= DEBUG_LEVEL_FATAL){LOG_NETWORK(DEBUG_LEVEL_FATAL, __VA_ARGS__);}} while(0)
#define LOG_NETWORK_ERROR(...)      do{if(DEBUG_LEVEL >= DEBUG_LEVEL_ERROR){ LOG_NETWORK(DEBUG_LEVEL_ERROR, __VA_ARGS__);}} while(0)
#define LOG_NETWORK_WARNING(...)    do{if(DEBUG_LEVEL >= DEBUG_LEVEL_WARNING){ LOG_NETWORK(DEBUG_LEVEL_WARNING, __VA_ARGS__);}} while(0)
#define LOG_NETWORK_DEBUG(...)      do{if(DEBUG_LEVEL >= DEBUG_LEVEL_DEBUG){ LOG_NETWORK(DEBUG_LEVEL_DEBUG, __VA_ARGS__);}} while(0)
#define LOG_NETWORK_INFO(...)       do{if(DEBUG_LEVEL >= DEBUG_LEVEL_INFO){ LOG_NETWORK(DEBUG_LEVEL_INFO, __VA_ARGS__);}} while(0)


#define LOG_GENERAL_FATAL(...)      do{if(DEBUG_LEVEL >= DEBUG_LEVEL_FATAL){LOG_GENERAL(DEBUG_LEVEL_FATAL, __VA_ARGS__);}} while(0)
#define LOG_GENERAL_ERROR(...)      do{if(DEBUG_LEVEL >= DEBUG_LEVEL_ERROR){ LOG_GENERAL(DEBUG_LEVEL_ERROR, __VA_ARGS__);}} while(0)
#define LOG_GENERAL_WARNING(...)    do{if(DEBUG_LEVEL >= DEBUG_LEVEL_WARNING){ LOG_NETWORK(DEBUG_LEVEL_WARNING, __VA_ARGS__);}} while(0)
#define LOG_GENERAL_DEBUG(...)      do{if(DEBUG_LEVEL >= DEBUG_LEVEL_DEBUG){ LOG_GENERAL(DEBUG_LEVEL_DEBUG, __VA_ARGS__);}} while(0)
#define LOG_GENERAL_INFO(...)       do{if(DEBUG_LEVEL >= DEBUG_LEVEL_INFO){ LOG_GENERAL(DEBUG_LEVEL_INFO, __VA_ARGS__);}} while(0)

#define LOG_UI_FATAL(...)           do{if(DEBUG_LEVEL >= DEBUG_LEVEL_FATAL){LOG_UI(DEBUG_LEVEL_FATAL, __VA_ARGS__);}} while(0)
#define LOG_UI_ERROR(...)           do{if(DEBUG_LEVEL >= DEBUG_LEVEL_ERROR){ LOG_UI(DEBUG_LEVEL_ERROR, __VA_ARGS__);}} while(0)
#define LOG_UI_WARNING(...)         do{if(DEBUG_LEVEL >= DEBUG_LEVEL_WARNING){ LOG_UI(DEBUG_LEVEL_WARNING, __VA_ARGS__);}} while(0)
#define LOG_UI_DEBUG(...)           do{if(DEBUG_LEVEL >= DEBUG_LEVEL_DEBUG){ LOG_UI(DEBUG_LEVEL_DEBUG, __VA_ARGS__);}} while(0)
#define LOG_UI_INFO(...)            do{if(DEBUG_LEVEL >= DEBUG_LEVEL_INFO){ LOG_UI(DEBUG_LEVEL_INFO, __VA_ARGS__);}} while(0)