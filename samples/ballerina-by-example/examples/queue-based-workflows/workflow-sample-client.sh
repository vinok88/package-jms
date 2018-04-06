# This depends on the ballerina v0.970.0-alpha0.
# Start the server with ballerina run workflow-sample.bal
curl http://localhost:9090/loanService/requestLoan
# Will be waiting for the loan approval
#Open another console
curl http://localhost:9090/loanService/approve
# Approval sent..
# The first console, will receive the response
# Approval Received!!
