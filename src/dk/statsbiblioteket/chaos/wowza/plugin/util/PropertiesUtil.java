package dk.statsbiblioteket.chaos.wowza.plugin.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import com.wowza.wms.logging.WMSLogger;

public class PropertiesUtil {

	private static final String propertyFilePath = "conf/chaos/chaos-streaming-server-plugin.properties";
	private static Map<String, String> propertiesMap = null;
	private static boolean propertiesRead = false;

	private static String[] propertyKeys = {
		"GeneralMCMServerURL",
		"ValidationMCMValidationMethod",
		"StatisticsLoggingLocallyInDB",
		"StatisticsLoggingJDBCDriver",
		"StatisticsLoggingDBConnectionURL",
		"StatisticsLoggingDBUser",
		"StatisticsLoggingDBPassword",
		"StatisticsLoggingMCMStatisticsMethodCreateStatSession",
		"StatisticsLoggingMCMValueClientSettingID",
		"StatisticsLoggingMCMValueRepositoryID",
		"StatisticsLoggingMCMStatisticsMethodCreateStatObjectSession",
		"StatisticsLoggingMCMValueObjectTypeID",
		"StatisticsLoggingMCMValueChannelTypeID",
		"StatisticsLoggingMCMValueChannelIdentifier",
		"StatisticsLoggingMCMValueObjectTitle",
		"StatisticsLoggingMCMValueEventTypeID",
		"StatisticsLoggingMCMValueObjectCollectionID",
		"StatisticsLoggingMCMStatisticsMethodCreateDurationSession"
	};
	
	public static synchronized void loadPropertiesMap(WMSLogger logger, String vHostRootDir) {
		if (!propertiesRead) {
			readPropertiesFromFile(logger, vHostRootDir);
			propertiesRead = true;
		}
	}

	public static String getProperty(String key) {
		if (!propertiesRead) {
			throw new RuntimeException("Properties not read. Load properties before getting them.");
		}
		String value = propertiesMap.get(key);
		if (value == null) {
			throw new RuntimeException("Fetching unexpected property for key: " + key);
		}
		return value; 
	}

	/**
	 * Reads properties from property file.
	 *
	 * @throws FileNotFoundException if property file is not found
	 * @throws IOException if reading process failed
	 */
	private static void readPropertiesFromFile(WMSLogger logger, String vHostRootDir) {
		try {
			Properties properties = new Properties();
			File propertyFile = new File(vHostRootDir + "/" + propertyFilePath);
			logger.info("Loading properties from file:" + propertyFile.getAbsoluteFile());
			properties.load(new FileInputStream(propertyFile));
			logger.debug("1");
			Set<String> keysLeft = new HashSet<String>();
			for (int i=0; i<propertyKeys.length; i++) {
				keysLeft.add(propertyKeys[i]);
			}
			logger.debug("2");
			propertiesMap = new HashMap<String, String>();
			for (int i=0; i<propertyKeys.length; i++) {
				String key = propertyKeys[i];
				String value = properties.getProperty(key);
				if (value != null) {
					propertiesMap.put(key, value);
					keysLeft.remove(key);
				}
			}
			logger.debug("3");
			if (!keysLeft.isEmpty()) {
				String message = "Missing keys:";
				for (String key:keysLeft) {
					message += " " + key;
				}
				throw new RuntimeException("Missing properties in property file: " + propertyFile.getAbsolutePath() + "\n" + message);
			}
			logger.debug("4");
		} catch (IOException e) {
			throw new RuntimeException("Could not read properties.", e);
		}
	}

}
