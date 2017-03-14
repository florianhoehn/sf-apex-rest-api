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
    @TestVisible private static final String LOG_LEVEL_ALL = 'All';
    @TestVisible private static final String LOG_LEVEL_FAILURE = 'Failure';
    @TestVisible private static final String STATUS_SUCCESS = 'Success';
    @TestVisible private static final String STATUS_FAILURE = 'Failure';
    private static final Integer TEXT_MAX_NUMBER_CHARS = 255;
    private static final Integer TEXTAREA_MAX_NUMBER_CHARS = 131072;

    /**
    * @description defines log level (create a setting for this)
    */
    @TestVisible private String logLevel = LOG_LEVEL_ALL;
    
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
    * @param String endpoint
    */
    public RestLogBuilderMVN withEndpoint(String endpoint) {
        this.log.Endpoint_MVN__c = this.cleanUp(endpoint, TEXT_MAX_NUMBER_CHARS);
        return this;
    }

    /**
    * @description set requestBody
    * @param String requestBody
    */
    public RestLogBuilderMVN withRequestBody(String requestBody) {
        this.log.Request_Body_MVN__c = this.cleanUp(requestBody, TEXTAREA_MAX_NUMBER_CHARS);
        return this;
    }

    /**
    * @description set responseBody
    * @param String responseBody
    */
    public RestLogBuilderMVN withResponseBody(String responseBody) {
        this.log.Response_Body_MVN__c = this.cleanUp(responseBody, TEXTAREA_MAX_NUMBER_CHARS);
        return this;
    }

    /**
    * @description set Message and StackTrace from exception
    * @param Exception ex
    */
    public RestLogBuilderMVN withException(Exception ex) {
        this.log.Message_MVN__c = this.cleanUp(ex.getMessage(), TEXTAREA_MAX_NUMBER_CHARS);
        this.log.Stack_Trace_MVN__c = this.cleanUp(ex.getStackTraceString(), TEXTAREA_MAX_NUMBER_CHARS);
        return this;
    }

    /**
    * @description set errorCode
    * @param String errorCode
    */
    public RestLogBuilderMVN withErrorCode(String errorCode) {
        this.log.Error_Code_MVN__c = this.cleanUp(errorCode, TEXT_MAX_NUMBER_CHARS);
        return this;
    }

    /**
    * @description insert or log out log record depending on log level
    */
    public RestLogBuilderMVN insertLog() {
        this.log.Status_MVN__c = this.getStatus();
        if(this.logLevel == LOG_LEVEL_ALL || this.log.Status_MVN__c == LOG_LEVEL_FAILURE) {
            insert this.log;
        } else {
            System.debug('===> Log: ' + this.log);
        }
        return this;
    }

    /**
    * @description returns the log record
    * @return Rest_Log_MVN__c log
    */
    public Rest_Log_MVN__c build() {
        return this.log;
    }
    
    /**
    * @description returns the status depending if an errorCode is set or not
    * @return String status
    */
    private String getStatus() {
        if(this.log.Error_Code_MVN__c == null) {
            return STATUS_SUCCESS;
        } else {
            return STATUS_FAILURE;
        }
    }
    
    /**
    * @description returns a cleaned up string, not null and length cut
    * @param String stringToCleanUp
    * @param Integer stringMaxLength
    * @return String cleanedString
    */
    private String cleanUp(String stringToCleanUp, Integer stringMaxLength) {
        return (stringToCleanUp != null && stringToCleanUp.length() > stringMaxLength ? stringToCleanUp.left(stringMaxLength) : stringToCleanUp);
    }
}