package dk.statsbiblioteket.chaos.wowza.plugin.statistic.logger;

public class MCMPortalStreamingStatisticsSessionIDPair {
	
	// ID pair for MCM statistics logging
	public String sessionID;
	public String objectSessionID;

	public MCMPortalStreamingStatisticsSessionIDPair(String sessionID,
			String objectSessionID) {
		this.sessionID = sessionID;
		this.objectSessionID = objectSessionID;
	}

	public String getSessionID() {
		return sessionID;
	}

	public String getObjectSessionID() {
		return objectSessionID;
	}
}
