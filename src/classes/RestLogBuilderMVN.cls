/**
* RestLogBuilderMVN.cls
* Created By: Florian Hoehn
* Created On: January 16th, 2017
* Description: defines the log builder to easily build a log record and insert it
**/
public with sharing class RestLogBuilderMVN {
    /**
    * @description Constants used in the log builder
    */
    @TestVisible private final String LOGLEVEL_ALL = 'All';
    @TestVisible private final String LOGLEVEL_FAILURE = 'Failure';
    @TestVisible private final String SUCCESS = 'Success';
    @TestVisible private final String FAILURE = 'Failure';
    
    /**
    * @description defines log level (create a setting for this)
    */
    @TestVisible private String logLevel = LOGLEVEL_ALL;
    
    /**
    * @description defines log record that will be inserted or logged out
    */
    private Rest_Log_MVN__c log;

    /**
    * @description constructor which leverages the SObjectBuilder to initiate record
    */
    public RestLogBuilderMVN() {
        this.log = new Rest_Log_MVN__c();
    }

    /**
    * @description set endpoint
    * @date January 16th, 2017
    * @param String endpoint
    */
    public RestLogBuilderMVN withEndpoint(String endpoint) {
        this.log.Endpoint_MVN__c = this.cleanUp(endpoint, 255);
        return this;
    }

    /**
    * @description set requestPayload
    * @date January 16th, 2017
    * @param String requestPayload
    */
    public RestLogBuilderMVN withRequestPayload(String requestPayload) {
        this.log.Request_Payload_MVN__c = this.cleanUp(requestPayload, 131072);
        return this;
    }

    /**
    * @description set responsePayload
    * @date January 16th, 2017
    * @param String responsePayload
    */
    public RestLogBuilderMVN withResponsePayload(String responsePayload) {
        this.log.Response_Payload_MVN__c = this.cleanUp(responsePayload, 131072);
        return this;
    }
    /**
    * @description set Message and StackTrace from exception
    * @date January 16th, 2017
    * @param Exception ex
    */
    public RestLogBuilderMVN withException(Exception ex) {
        this.log.Message_MVN__c = this.cleanUp(ex.getMessage(), 131072);
        this.log.Stack_Trace_MVN__c = this.cleanUp(ex.getStackTraceString(), 131072);
        return this;
    }

    /**
    * @description set errorCode
    * @date January 16th, 2017
    * @param String errorCode
    */
    public RestLogBuilderMVN withErrorCode(String errorCode) {
        this.log.Error_Code_MVN__c = this.cleanUp(errorCode, 255);
        return this;
    }

    /**
    * @description insert or log out log record depending on log level
    * @date January 16th, 2017
    */
    public RestLogBuilderMVN insertLog() {
        this.log.Status_MVN__c = this.getStatus();
        if(this.logLevel == LOGLEVEL_ALL || this.log.Status_MVN__c == LOGLEVEL_FAILURE) {
            insert this.log;
        } else {
            System.debug('===> Log: ' + this.log);
        }
        return this;
    }

    /**
    * @description returns the log record
    * @date January 16th, 2017
    * @return Rest_Log_MVN__c log
    */
    public Rest_Log_MVN__c build() {
        return this.log;
    }
    
    /**
    * @description returns the status depending if an errorCode is set or not
    * @date January 16th, 2017
    * @return String status
    */
    private String getStatus() {
        if(this.log.Error_Code_MVN__c == null) {
            return SUCCESS;
        } else {
            return FAILURE;
        }
    }
    
    /**
    * @description returns a cleaned up string, not null and length cut
    * @date January 16th, 2017
    * @param String stringToCleanUp
    * @param Integer stringMaxLength
    * @return String cleanedString
    */
    private String cleanUp(String stringToCleanUp, Integer stringMaxLength) {
        return (stringToCleanUp != null && stringToCleanUp.length() > stringMaxLength ? stringToCleanUp.left(stringMaxLength) : stringToCleanUp);
    }

}