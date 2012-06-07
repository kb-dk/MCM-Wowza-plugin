package dk.statsbiblioteket.chaos.wowza.plugin.statistic.logger;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.wowza.wms.logging.WMSLogger;

import dk.statsbiblioteket.chaos.wowza.plugin.statistic.logger.StreamingStatLogEntry.Event;

public class StreamingMCMEventLogger implements StreamingEventLoggerIF {

    private final WMSLogger logger;

    private static StreamingMCMEventLogger instance = null;

    /**
     * Reads db connection information from property file and creates connection
     *
     * @param logger
     * @param vHostHomeDirPath
     * @throws FileNotFoundException If property file could not be read
     * @throws IOException           If property file could not be read
     */
    private StreamingMCMEventLogger(WMSLogger logger, String vHostHomeDirPath)
            throws FileNotFoundException, IOException {
        this.logger = logger;
        this.logger.info("Statistics logger " + this.getClass().getName() + " has been created.");
    }

    /** TEST constructor!!! */
    private StreamingMCMEventLogger(WMSLogger logger) {
        super();
        this.logger = logger;
        this.logger.info("Statistics logger " + this.getClass().getName() + " has been created. "
                                 + "ONLY FOR TEST PURPOSE! DB-connection not established in a safe way.");
    }

    /**
     * Creates the singleton objects. Is robust for multiple concurrent requests for create.
     * Only the first request for create, actually creates the object.
     *
     */
    public static synchronized void createInstanceForTestPurpose(WMSLogger logger, Connection connection)
            throws FileNotFoundException, IOException {
        if ((logger == null) || (connection == null)) {
            throw new IllegalArgumentException(
                    "A parameter is null. " + "logger=" + logger + " " + "connection=" + connection);
        }
        if (instance == null) {
            instance = new StreamingMCMEventLogger(logger);
        }
    }

    /**
     * Creates the singleton objects. Is robust for multiple concurrent requests for create.
     * Only the first request for create, actually creates the object.
     */
    public static synchronized void createInstance(WMSLogger logger, String vHostHomeDirPath)
            throws FileNotFoundException, IOException {
        if ((logger == null) || (vHostHomeDirPath == null)) {
            throw new IllegalArgumentException(
                    "A parameter is null. " + "logger=" + logger + " " + "vHostHomeDirPath=" + vHostHomeDirPath);
        }
        if (instance == null) {
            instance = new StreamingMCMEventLogger(logger, vHostHomeDirPath);
        }
    }

    public static synchronized StreamingEventLoggerIF getInstance() {
        return instance;
    }

    @Override
    public MCMPortalStreamingStatisticsSessionIDPair getStreamingLogSessionID(String mcmObjectID) {
        String sessionID = MCMPortalInterfaceStatisticsImpl.getInstance().getStatisticsSession();
        String objectSessionID = MCMPortalInterfaceStatisticsImpl.getInstance()
                .getStatisticsObjectSession(sessionID, mcmObjectID);
        return new MCMPortalStreamingStatisticsSessionIDPair(sessionID, objectSessionID);
    }

    @Override
    public void logEvent(StreamingStatLogEntry logEntry) {
        if (Event.PLAY.equals(logEntry.getEvent()) || Event.PAUSE.equals(logEntry.getEvent())
                || Event.REWIND.equals(logEntry.getEvent()) || Event.STOP.equals(logEntry.getEvent())) {
            logger.info("Streaming statistics logging line: " + logEntry);
            logEventInMCM(logEntry);
        }
    }

    private synchronized void logEventInMCM(StreamingStatLogEntry logEntry) {
        MCMPortalInterfaceStatisticsImpl.getInstance()
                .logPlayDuration(logEntry.getMcmSessionID(), logEntry.getMcmObjectSessionID(), logEntry.getStartedAt(),
                                 logEntry.getEndedAt());
    }

    @Override
    public StreamingStatLogEntry getLogEntryLatest() {
        throw new UnsupportedOperationException("MCM logger does not support queries");
    }

    public List<StreamingStatLogEntry> getLogEntryLatest(int numberOfEntries) {
        throw new UnsupportedOperationException("MCM logger does not support queries");
    }
}
