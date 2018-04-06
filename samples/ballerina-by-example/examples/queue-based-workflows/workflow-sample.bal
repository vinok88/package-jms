import ballerina/net.jms;
import ballerina/net.http;
import ballerina/io;

endpoint http:ServiceEndpoint workflowEP {
    port:9090
};

endpoint jms:QueueEndpoint jmsClientEP {
    destination:"testQueue"
};

@http:ServiceConfig {
      basePath:"/loanService"
}
service<http:Service> loanService bind workflowEP {
    
	@http:ResourceConfig {
        methods:["GET"],
        path:"/requestLoan"
    }
    startApproval (endpoint conn, http:Request req) {
        http:Response res = {};
        json jsonmap = {"orderId": 234};
        var result = jmsClientEP->correlate(jsonmap);
	   match result {
            jms:Message message => {    
                res.setStringPayload("Approval Received!!");
                io:println("Message received!!");
                _ = conn -> respond(res);
        }
        any => {
            io:println("No message recieved");
        }
    }
}

	@http:ResourceConfig {
        methods:["GET"],
        path:"/approve"
    }
    sendMsg (endpoint conn, http:Request req) {

        http:Response res = {}; 
        jms:Message queueMessage = jmsClientEP.createTextMessage("Approve");
        json jsonmap = {"orderId": 234};
        queueMessage.setCorrelationID(jsonmap.toString ());
        // Send the Ballerina message to the JMS provider.
        jmsClientEP->send("MyQueue", queueMessage);

        res.setStringPayload("Approval sent..");

        _ = conn -> respond(res);

        }
}
