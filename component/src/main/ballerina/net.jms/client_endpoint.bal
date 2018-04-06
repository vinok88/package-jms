package ballerina.net.jms;


@Description {value:"Represents a JMS client endpoint"}
@Field {value:"epName: The name of the endpoint"}
//@Field {value:"config: The configurations associated with the endpoint"}
public struct QueueEndpoint {
    string queueName;
    ClientEndpointConfiguration config;
}

@Description { value:"JMS Client connector properties to pass JMS client connector configurations"}
//@Field {value:"initialContextFactory: Initial context factory name, specific to the provider"}
//@Field {value:"providerUrl: Connection URL of the provider"}
//@Field {value:"connectionFactoryName: Name of the connection factory"}
//@Field {value:"connectionFactoryType: Type of the connection factory (queue/topic)"}
@Field {value:"acknowledgementMode: Ack mode (auto-ack, client-ack, dups-ok-ack, transacted, xa)"}
@Field {value:"clientCaching: Is client caching enabled (default: enabled)"}
//@Field {value:"connectionUsername: Connection factory username"}
//@Field {value:"connectionPassword: Connection factory password"}
//@Field {value:"configFilePath: Path to be used for locating jndi configuration"}
//@Field {value:"connectionCount: Number of pooled connections to be used in the transport level (default: 5)"}
//@Field {value:"sessionCount: Number of pooled sessions to be used per connection in the transport level (default: 10)"}
@Field {value:"properties: Additional Properties"}
public struct ClientEndpointConfiguration {
    //string initialContextFactory;
    //string providerUrl;
    //string connectionFactoryName;
    string destination;
    string destinationType;
    string acknowledgementMode;
    boolean clientCaching = true;
    //string connectionUsername;
    //string connectionPassword;
    //string configFilePath;
    //int connectionCount;
    //int sessionCount;
    map properties;
}

public function <ClientEndpointConfiguration config> ClientEndpointConfiguration() {
    //config.connectionFactoryName = "QueueConnectionFactory";
    config.destinationType = "queue";
    config.acknowledgementMode = "AUTO_ACKNOWLEDGE";
    config.clientCaching = true;
    config.destination = "MyQueue";
    //config.connectionCount = 5;
    //config.sessionCount = 10;
}

public struct ClientConnector {
    string connectorId;
    ClientEndpointConfiguration config;
}

public function <QueueEndpoint ep> init (ClientEndpointConfiguration config) {
    ep.config = config;
    ep.initEndpoint();
}

public native function<QueueEndpoint ep> initEndpoint ();

public native function<QueueEndpoint ep> createTextMessage (string content) returns (Message);

public function <QueueEndpoint ep> register (typedesc serviceType) {

}

public function <QueueEndpoint ep> start () {

}

@Description { value:"Returns the connector that client code uses"}
@Return { value:"The connector that client code uses" }
public native function <QueueEndpoint ep> getClient () returns (ClientConnector);

@Description { value:"Stops the registered service"}
@Return { value:"Error occured during registration" }
public function <QueueEndpoint ep> stop () {

}

@Description {value:"SEND action implementation of the JMS Connector"}
@Param {value:"destinationName: Destination Name"}
@Param {value:"message: Message"}
public native function<ClientConnector ep> send (string destinationName, Message m);

@Description {value:"POLL action implementation of the JMS Connector"}
@Param {value:"destinationName: Destination Name"}
@Param {value:"time: Timeout that needs to blocked on"}
public native function<ClientConnector ep> receive (string destinationName, int time) returns (Message | null);

@Description {value:"POLL action implementation with selector support of the JMS Connector"}
@Param {value:"destinationName: Destination Name"}
@Param {value:"time: Timeout that needs to blocked on"}
@Param {value:"selector: Selector to filter out messages"}
public native function<ClientConnector ep> receiveWithSelector (string destinationName, int time, string selector)
    returns (Message | null);

@Description {value:"Receive message by correlating with given map"}
@Param {value:"correlationMap: Correlation map"}
public native function<ClientConnector ep> correlate (json correlationMap)
    returns (Message | null);
