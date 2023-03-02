/** 
 * This module contains the main SLF4D provider implementation that you should
 * use if you're configuring SLF4D to use DLog.
 */
module slf4d_dlog.provider;

import slf4d.provider;
import slf4d.factory;
import slf4d.level;
import slf4d.default_provider : DefaultLoggerFactory;
import dlog;
import slf4d_dlog.handler;

/** 
 * An SLF4D provider implementation for the DLog logging library.
 */
class DLogProvider : LoggingProvider {
    /** 
     * The internal logger factory that this provider uses. We just use SLF4D's
     * default factory, since it's good enough for our use case.
     */
    private shared DefaultLoggerFactory loggerFactory;

    /** 
     * Constructs the DLog provider with a standard `DefaultLogger`.
     */
    public shared this() {
        this.loggerFactory = new shared DefaultLoggerFactory(new shared DLogHandler());
    }

    /** 
     * Constructs the DLog provider with the given Logger.
     * Params:
     *   logger = The logger to use.
     */
    public shared this(dlog.Logger logger) {
        this.loggerFactory = new shared DefaultLoggerFactory(
            new shared DLogHandler(logger),
            slf4d.level.Levels.TRACE
        );
    }

    public shared shared(DefaultLoggerFactory) getLoggerFactory() {
        return this.loggerFactory;
    }

    /** 
     * Maps an SLF4D logging level to its DLog equivalent.
     * Params:
     *   slf4dLevel = The SLF4D logging level.
     * Returns: The equivalent DLog level.
     */
    public static dlog.context.Level mapLevelToDLog(slf4d.level.Level slf4dLevel) {
        if (slf4dLevel.value >= slf4d.level.Levels.ERROR.value) {
            return dlog.context.Level.ERROR;
        } else if (slf4dLevel.value >= slf4d.level.Levels.WARN.value) {
            return dlog.context.Level.WARN;
        } else if (slf4dLevel.value <= slf4d.level.Levels.DEBUG.value) {
            return dlog.context.Level.DEBUG;
        }
        return dlog.context.Level.INFO;
    }

    unittest {
        assert(DLogProvider.mapLevelToDLog(Levels.INFO) == dlog.context.Level.INFO);
        assert(DLogProvider.mapLevelToDLog(Levels.ERROR) == dlog.context.Level.ERROR);
        assert(DLogProvider.mapLevelToDLog(Levels.WARN) == dlog.context.Level.WARN);
        assert(DLogProvider.mapLevelToDLog(Levels.DEBUG) == dlog.context.Level.DEBUG);
        assert(DLogProvider.mapLevelToDLog(Levels.TRACE) == dlog.context.Level.DEBUG);
        assert(DLogProvider.mapLevelToDLog(slf4d.level.Level(45, "Slightly bad warning")) == dlog.context.Level.WARN);
    }

    /** 
     * Maps a DLog logging level to its SLF4D equivalent.
     * Params:
     *   dlogLevel = The DLog level.
     * Returns: The equivalent SLF4D level.
     */
    public static slf4d.level.Level mapLevelToSlf4d(dlog.context.Level dlogLevel) {
        if (dlogLevel == dlog.context.Level.ERROR) {
            return slf4d.level.Levels.ERROR;
        } else if (dlogLevel == dlog.context.Level.WARN) {
            return slf4d.level.Levels.WARN;
        } else if (dlogLevel == dlog.context.Level.DEBUG) {
            return slf4d.level.Levels.DEBUG;
        }
        return slf4d.level.Levels.INFO;
    }

    unittest {
        assert(DLogProvider.mapLevelToSlf4d(dlog.context.Level.ERROR) == Levels.ERROR);
        assert(DLogProvider.mapLevelToSlf4d(dlog.context.Level.WARN) == Levels.WARN);
        assert(DLogProvider.mapLevelToSlf4d(dlog.context.Level.INFO) == Levels.INFO);
        assert(DLogProvider.mapLevelToSlf4d(dlog.context.Level.DEBUG) == Levels.DEBUG);
    }
}

unittest {
    import slf4d;

    shared DLogProvider provider = new shared DLogProvider();
    configureLoggingProvider(provider);

    auto log = getLogger();
    log.info("Testing");

    // TODO: Add more comprehensive testing.
}
