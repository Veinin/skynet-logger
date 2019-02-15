# Skynet 日志文件服务

本项目实现了一个独立的 Skynet 日志文件服务，接管了 skynet 内部默认的 C 日志服务，使之更加适应游戏中对日志文件统计的需求。

日志服务需要修改配置文件：

``` lua
logger     = "logger" -- 日志服务名
logservice = "snlua"  -- 现在日志服务用 Lua 实现
logpath    = "./log/" -- 日志输出目录
loggroup   = "test"   -- 日志文件分组名
```

其中新增了 `loggroup` 配置，用于区分各个进程产生的日志文件，并进行分组，如上面分组名为 `test`，则会产生这样的日志文件名：`test_2019-02-15-18.log`。

请注意，该日志服务，每隔一个小时会产生一个新的日志文件，如果你有其他需求，你可以进行修改。

## 日志 API

日志服务默认在每个进程主服务启动之前就会加载，日志分为5个等级，等级描述在 `log.lua` 中：

``` lua
local LOG_LEVEL = {
    DEBUG   = 1, -- 基本调试信息
    INFO    = 2, -- 应用程序运行过程中关键信息
    WARN    = 3, -- 警告信息，表明会出现潜在错误的情形
    ERROR   = 4, -- 错误信息，虽然发生错误事件，但仍然不影响系统的继续运行。
    FATAL   = 5, -- 严重的错误事件将会导致应用程序的退出。
}
```

针对上面不同的日志等级，有一套相应的日志API供你调用，在使用日志API之前，你需要获取到日志模块：

``` lua
local log = require "log"
```

然后可以使用日志模块提供的不同等级API：

``` lua
log.debug(fmt, ...)
log.info(fmt, ...)
log.warn(fmt, ...)
log.error(fmt, ...)
log.fatal(fmt, ...)
```

日志API提供了一套遵循 ISO C 函数 sprintf 的格式化字符串规则，如果你需要格式化输出，你可以这样打印：

``` lua
log.debug("Value of Pi = %f", math.pi)
```

当然如果你不需要格式化字符串，你也可以通过第一个值直接打印输出任何信息：

``` lua
log.debug("Value of Pi = 3.14159")
```
