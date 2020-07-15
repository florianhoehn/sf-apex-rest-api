/**
* @author Florian Hoehn
* defines the log builder to easily build a log record and insert it
**/
public with sharing class RestLogBuilder {
    /**
    * Constants used in the log builder
    */
    @TestVisible private static final String LOG_LEVEL_ALL = 'All';
    @TestVisible private static final String LOG_LEVEL_FAILURE = 'Failure';
    @TestVisible private static final String STATUS_SUCCESS = 'Success';
    @TestVisible private static final String STATUS_FAILURE = 'Failure';
    private static final Integer TEXT_MAX_NUMBER_CHARS = 255;
    private static final Integer TEXTAREA_MAX_NUMBER_CHARS = 131072;

    /**
    * defines log level (create a setting for this)
    */
    @TestVisible private String logLevel = LOG_LEVEL_ALL;

    /**
    * defines log record that will be inserted or logged out
    */
    private Rest_Log__c log;

    /**
    * constructor which leverages the SObjectBuilder to initiate record
    */
    public RestLogBuilder() {
        this.log = new Rest_Log__c();
    }

    /**
    * set endpoint
    * @param String endpoint
    */
    public RestLogBuilder withEndpoint(String endpoint) {
        this.log.Endpoint__c = this.cleanUp(endpoint, TEXT_MAX_NUMBER_CHARS);
        return this;
    }

    /**
    * set requestBody
    * @param String requestBody
    */
    public RestLogBuilder withRequestBody(String requestBody) {
        this.log.Request_Body__c = this.cleanUp(requestBody, TEXTAREA_MAX_NUMBER_CHARS);
        return this;
    }

    /**
    * set responseBody
    * @param String responseBody
    */
    public RestLogBuilder withResponseBody(String responseBody) {
        this.log.Response_Body__c = this.cleanUp(responseBody, TEXTAREA_MAX_NUMBER_CHARS);
        return this;
    }

    /**
    * set Message and StackTrace from exception
    * @param Exception ex
    */
    public RestLogBuilder withException(Exception ex) {
        this.log.Message__c = this.cleanUp(ex.getMessage(), TEXTAREA_MAX_NUMBER_CHARS);
        this.log.Stack_Trace__c = this.cleanUp(ex.getStackTraceString(), TEXTAREA_MAX_NUMBER_CHARS);
        return this;
    }

    /**
    * set errorCode
    * @param String errorCode
    */
    public RestLogBuilder withErrorCode(String errorCode) {
        this.log.Error_Code__c = this.cleanUp(errorCode, TEXT_MAX_NUMBER_CHARS);
        return this;
    }

    /**
    * insert or log out log record depending on log level
    */
    public RestLogBuilder insertLog() {
        this.log.Status__c = this.getStatus();
        if(this.logLevel == LOG_LEVEL_ALL || this.log.Status__c == LOG_LEVEL_FAILURE) {
            insert this.log;
        } else {
            System.debug('===> Log: ' + this.log);
        }
        return this;
    }

    /**
    * returns the log record
    * @return Rest_Log__c log
    */
    public Rest_Log__c build() {
        return this.log;
    }

    /**
    * returns the status depending if an errorCode is set or not
    * @return String status
    */
    private String getStatus() {
        if(this.log.Error_Code__c == null) {
            return STATUS_SUCCESS;
        } else {
            return STATUS_FAILURE;
        }
    }

    /**
    * returns a cleaned up string, not null and length cut
    * @param String stringToCleanUp
    * @param Integer stringMaxLength
    * @return String cleanedString
    */
    private String cleanUp(String stringToCleanUp, Integer stringMaxLength) {
        return (stringToCleanUp != null && stringToCleanUp.length() > stringMaxLength ? stringToCleanUp.left(stringMaxLength) : stringToCleanUp);
    }
}