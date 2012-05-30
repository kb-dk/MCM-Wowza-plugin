package dk.statsbiblioteket.chaos.wowza.plugin.statistic.logger;

public interface StreamingEventLoggerIF {

	public abstract MCMPortalStreamingStatisticsSessionIDPair getStreamingLogSessionID(String mcmObjectID);
	public abstract void logEvent(StreamingStatLogEntry logEntry);

	public abstract StreamingStatLogEntry getLogEntryLatest();

}