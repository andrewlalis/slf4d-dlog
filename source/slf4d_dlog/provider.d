module slf4d_dlog.provider;

import slf4d.provider;
import slf4d.factory;
import slf4d.level;
import slf4d.default_provider : DefaultLoggerFactory;
import dlog;
import slf4d_dlog.handler;

class DLogProvider : LoggingProvider {
    private shared DefaultLoggerFactory loggerFactory;

    public shared this(dlog.Logger logger, Level loggingLevel = Levels.INFO) {
        this.loggerFactory = new shared DefaultLoggerFactory(
            new shared DLogHandler(logger),
            loggingLevel
        );
    }

    public shared this(Level loggingLevel = Levels.INFO) {
        this.loggerFactory = new shared DefaultLoggerFactory(
            new shared DLogHandler(),
            loggingLevel
        );
    }

    public shared shared(DefaultLoggerFactory) getLoggerFactory() {
        return this.loggerFactory;
    }
}
