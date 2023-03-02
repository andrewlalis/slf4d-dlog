module slf4d_dlog.handler;

import slf4d.handler;
import slf4d.logger;
import dlog;

/**
 * An SLF4D LogHandler implementation for DLog, which just maps all log calls
 * to an internal `dlog.Logger`. Note that because DLog's Logger class does not
 * support shared methods (which are needed to ensure safe operation from
 * multiple threads), this handler synchronizes calls to handle log messages. 
 */
class DLogHandler : LogHandler {
    private shared dlog.Logger dlogLogger;

    public shared this() {
        this(new DefaultLogger());
    }

    public shared this(dlog.MessageTransform messageTransform) {
        // TODO: Implement this once it is done in DLog.
        import std.stdio;
        stderr.writeln("Warning: Constructing a DLogHandler with a MessageTransform is not supported.");
        this(new DefaultLogger());
    }

    public shared this(dlog.Logger logger) {
        this.dlogLogger = cast(shared) logger;
    }

    public shared void handle(LogMessage msg) {
        synchronized(this.dlogLogger) {
            auto unsharedLogger = cast(dlog.Logger) this.dlogLogger;
            unsharedLogger.log3!(const(string))(
                msg.message,
                "",
                "",
                0,
                cast(string) msg.sourceContext.moduleName.dup,
                "",
                cast(string) msg.sourceContext.functionName.dup
            );
        }
    }
}
