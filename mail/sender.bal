import ballerina/http;
import ballerina/io;
import wso2/gmail;
import ballerina/config;

gmail:GmailConfiguration gmailConfig = {
    clientConfig: {
        auth: {
            scheme: http:OAUTH2,
            config: {
                grantType: http:DIRECT_TOKEN,
                config: {
                    accessToken: config:getAsString("ACCESS_TOKEN"),
                    refreshConfig: {
                        refreshUrl: gmail:REFRESH_URL,
                        refreshToken: config:getAsString("REFRESH_TOKEN"),
                        clientId: config:getAsString("CLIENT_ID"),
                        clientSecret: config:getAsString("CLIENT_SECRET")
                    }
                }
            }
        }
    }
};

gmail:Client gmailClient = new(gmailConfig);

public function main(string... args) {
    gmail:MessageRequest messageRequest = {};
    messageRequest.recipient = "shehane@wso2.com";
    messageRequest.sender = "shehane@wso2.com";
    messageRequest.subject = "Email-Subject";
    messageRequest.messageBody = "Email Message Body Text";
    // Set the content type of the mail as TEXT_PLAIN or TEXT_HTML.
    messageRequest.contentType = gmail:TEXT_PLAIN;
    string userId = "me";
    // Send the message.
    var sendMessageResponse = gmailClient->sendMessage(userId, messageRequest);
    if (sendMessageResponse is (string, string)) {
        // If successful, print the message ID and thread ID.
        (string, string) (messageId, threadId) = sendMessageResponse;
        io:println("Sent Message ID: " + messageId);
        io:println("Sent Thread ID: " + threadId);
    } else {
        // If unsuccessful, print the error returned.
        io:println("Error: ", sendMessageResponse);
    }
}