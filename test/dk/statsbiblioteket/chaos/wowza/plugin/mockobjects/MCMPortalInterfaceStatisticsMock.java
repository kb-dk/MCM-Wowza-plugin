package dk.statsbiblioteket.chaos.wowza.plugin.mockobjects;

import com.wowza.wms.logging.WMSLogger;

import dk.statsbiblioteket.chaos.wowza.plugin.statistic.logger.MCMPortalInterfaceStatistics;

public class MCMPortalInterfaceStatisticsMock implements MCMPortalInterfaceStatistics {

	private WMSLogger logger;
	
	private int sessionID = 0;
	private int sessionObjectID = 0;
	
	public MCMPortalInterfaceStatisticsMock(WMSLogger logger) {
		super();
		this.logger = logger;
	}

	@Override
	public String getStatisticsSession() {
		String result = "" + sessionID++;
		logger.info("Retrieving session id: " + result);
		return result;
	}

	@Override
	public String getStatisticsObjectSession(String sessionID,
			String mcmObjectID) {
		String result = sessionID + "-" + sessionObjectID++;
		logger.info("Retrieving session object id: " + result);
		return result;
	}

	@Override
	public String logPlayDuration(String sessionID, String objectSessionID,
			long startedAt, long endedAt) {
		logger.info("logging: [" + sessionID + "-" + sessionObjectID + ": " + startedAt + "; " + endedAt + "]");
		return "";
	}

}
