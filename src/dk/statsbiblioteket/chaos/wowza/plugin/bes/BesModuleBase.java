package dk.statsbiblioteket.chaos.wowza.plugin.bes;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;
import com.wowza.wms.amf.AMFDataList;
import com.wowza.wms.application.IApplicationInstance;
import com.wowza.wms.client.IClient;
import com.wowza.wms.module.IModuleOnApp;
import com.wowza.wms.module.IModuleOnCall;
import com.wowza.wms.module.IModuleOnConnect;
import com.wowza.wms.module.IModuleOnStream;
import com.wowza.wms.module.ModuleBase;
import com.wowza.wms.request.RequestFunction;
import com.wowza.wms.stream.IMediaStream;
import com.wowza.wms.stream.IMediaStreamFileMapper;

import dk.statsbiblioteket.chaos.wowza.plugin.util.ConfigReader;

import java.io.File;
import java.io.IOException;

public class BesModuleBase extends ModuleBase
        implements IModuleOnApp, IModuleOnConnect, IModuleOnStream, IModuleOnCall {

    private static String propertyFilePath = "conf/chaos/chaos-streaming-server-plugin.properties";
    private static String propertyBESRestURL = "GeneralBESServerURL";

    private static String pluginName = "CHAOS Wowza plugin - file location resolver";
    private static String pluginVersion = "2.1.0 SB DOMS file streaming";

    public BesModuleBase() {
        super();
    }

    public void onAppStart(IApplicationInstance appInstance) {
        getLogger().info("onAppStart: " + pluginName + " version " + pluginVersion);
        getLogger().info("onAppStart: VHost home path: " + appInstance.getVHost().getHomePath());
        String vhostDir = appInstance.getVHost().getHomePath();
        String storageDir = appInstance.getStreamStorageDir();
        // Setup file mapper
        try {
            IMediaStreamFileMapper defaultMapper = appInstance.getStreamFileMapper();
            ConfigReader cr = new ConfigReader(new File(vhostDir + "/" + propertyFilePath));
            WebResource besRestApi = Client.create()
                    .resource(cr.get(propertyBESRestURL, "missing-bes-service-location-in-property-file"));
            getLogger().info("onAppStart: Creating DomsShardIdToFileMapper");
            DomsShardIdToFileMapper domsShardIdToFileMapper = new DomsShardIdToFileMapper(defaultMapper, storageDir,
                                                                                          besRestApi);
            // Set File mapper
            appInstance.setStreamFileMapper(domsShardIdToFileMapper);
        } catch (IOException e) {
            getLogger().error("Unable to read configuration file", e);
            throw new RuntimeException("Unable to read configuration file", e);
        }
    }

    public void onConnect(IClient client, RequestFunction function, AMFDataList params) {
        getLogger().info("onConnect (client ID)   : " + client.getClientId());
        client.acceptConnection("CHAOS connection accepted.");
    }

    public void onConnectAccept(IClient client) {
        getLogger().info("onConnectAccept: " + client.getClientId());
    }

    public void onConnectReject(IClient client) {
        getLogger().info("onConnectReject: " + client.getClientId());
    }

    public void onStreamCreate(IMediaStream stream) {
        getLogger().info("onStreamCreate by: " + stream.getClientId());
    }

    public void play(IClient client, RequestFunction function, AMFDataList params) {
        getLogger().info("Play called for client id was " + client.getClientId());
        this.invokePrevious(client, function, params);
    }

    public void onStreamDestroy(IMediaStream stream) {
        getLogger().info("onStreamDestroy by: " + stream.getClientId());
    }

    @Override
    public void onDisconnect(IClient client) {
        getLogger().info("onDisconnect (client ID)   : " + client.getClientId());
    }

    public void onAppStop(IApplicationInstance appInstance) {
        getLogger().info("onAppStop: " + pluginName + " version " + pluginVersion);
    }

    @Override
    public void onCall(String handlerName, IClient client, RequestFunction function, AMFDataList params) {
        getLogger().info("onCall, unimplemented method was called: " + handlerName);
    }
}
