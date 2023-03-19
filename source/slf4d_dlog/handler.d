/** 
 * This module contains the SLF4D-DLog handler implementation.
 */
module slf4d_dlog.handler;

import slf4d.handler;
import slf4d.logger;
import dlog;
import slf4d_dlog.provider;

/**
 * An SLF4D LogHandler implementation for DLog, which just maps all log calls
 * to an internal `dlog.Logger`. Note that because DLog's Logger class does not
 * support shared methods (which are needed to ensure safe operation from
 * multiple threads), this handler synchronizes calls to handle log messages. 
 */
class DLogHandler : LogHandler {
    private shared dlog.Logger dlogLogger;

    /** 
     * Constructs this handler with DLog's `DefaultLogger`.
     */
    public shared this() {
        this(new DefaultLogger());
    }

    /** 
     * Constructs this handler with DLog's `DefaultLogger`, configured with the
     * given message transform.
     * Params:
     *   messageTransform = The message transform to use.
     */
    public shared this(dlog.MessageTransform messageTransform) {
        // TODO: Implement this once it is done in DLog.
        import std.stdio;
        stderr.writeln("Warning: Constructing a DLogHandler with a MessageTransform is not supported.");
        this(new DefaultLogger());
    }

    /** 
     * Constructs this handler with the given DLog Logger.
     * Params:
     *   logger = The logger to use.
     */
    public shared this(dlog.Logger logger) {
        this.dlogLogger = cast(shared) logger;
    }

    /** 
     * Handles messages using the internal DLog Logger.
     * Params:
     *   msg = The message to handle.
     */
    public shared void handle(immutable LogMessage msg) {
        Context ctx = new Context();
        ctx.setLevel(DLogProvider.mapLevelToDLog(msg.level));
        synchronized(this.dlogLogger) {
            auto unsharedLogger = cast(dlog.Logger) this.dlogLogger;
            unsharedLogger.logc(
                ctx,
                msg.message,
                "",
                msg.sourceContext.fileName,
                cast (ulong) msg.sourceContext.lineNumber,
                msg.sourceContext.moduleName.dup,
                "",
                msg.sourceContext.functionName.dup
            );
        }
    }
}
