# SLF4D-DLog

An [SLF4D](https://code.dlang.org/packages/slf4d) provider for the [DLog](https://code.dlang.org/packages/dlog) logging library.

## Getting Started

The following snippet shows all that's needed to start logging with the DLog provider for SLF4D:

```d
import slf4d;
import slf4d_dlog;

auto dlogProvider = new shared DLogProvider();
configureLoggingProvider(dlogProvider);

auto log = getLogger();
log.info("This message will be handled by DLog.");
```

You can customize DLog's behavior by providing a custom `Logger` or `MessageTransform` when constructing the DLogProvider:
```d
auto customizedProvider = new shared DLogProvider(myCustomLogger);
auto otherProvider = new shared DLogProvider(myCustomMessageTransform);
```

### Thread-Safety

Because DLog is designed for single-threaded use only, this provider synchronizes access to the underlying DLog logger such that only one thread may access it at a time.
