/**
* RestLogBuilder* @group UUID.cls
* Created By: Florian Hoehn
* Created On: January 16th, 2017
* Description: defines the log builder to easily build a log record and insert it
**/
public with sharing class RestLogBuilder* @group UUID {
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
    private Rest_Log_* @group UUID__c log;

    /**
    * @description constructor which leverages the SObjectBuilder to initiate record
    */
    public RestLogBuilder* @group UUID() {
        this.log = new Rest_Log_* @group UUID__c();
    }

    /**
    * @description set endpoint
    * @param String endpoint
    */
    public RestLogBuilder* @group UUID withEndpoint(String endpoint) {
        this.log.Endpoint_* @group UUID__c = this.cleanUp(endpoint, TEXT_MAX_NUMBER_CHARS);
        return this;
    }

    /**
    * @description set requestBody
    * @param String requestBody
    */
    public RestLogBuilder* @group UUID withRequestBody(String requestBody) {
        this.log.Request_Body_* @group UUID__c = this.cleanUp(requestBody, TEXTAREA_MAX_NUMBER_CHARS);
        return this;
    }

    /**
    * @description set responseBody
    * @param String responseBody
    */
    public RestLogBuilder* @group UUID withResponseBody(String responseBody) {
        this.log.Response_Body_* @group UUID__c = this.cleanUp(responseBody, TEXTAREA_MAX_NUMBER_CHARS);
        return this;
    }

    /**
    * @description set Message and StackTrace from exception
    * @param Exception ex
    */
    public RestLogBuilder* @group UUID withException(Exception ex) {
        this.log.Message_* @group UUID__c = this.cleanUp(ex.getMessage(), TEXTAREA_MAX_NUMBER_CHARS);
        this.log.Stack_Trace_* @group UUID__c = this.cleanUp(ex.getStackTraceString(), TEXTAREA_MAX_NUMBER_CHARS);
        return this;
    }

    /**
    * @description set errorCode
    * @param String errorCode
    */
    public RestLogBuilder* @group UUID withErrorCode(String errorCode) {
        this.log.Error_Code_* @group UUID__c = this.cleanUp(errorCode, TEXT_MAX_NUMBER_CHARS);
        return this;
    }

    /**
    * @description insert or log out log record depending on log level
    */
    public RestLogBuilder* @group UUID insertLog() {
        this.log.Status_* @group UUID__c = this.getStatus();
        if(this.logLevel == LOG_LEVEL_ALL || this.log.Status_* @group UUID__c == LOG_LEVEL_FAILURE) {
            insert this.log;
        } else {
            System.debug('===> Log: ' + this.log);
        }
        return this;
    }

    /**
    * @description returns the log record
    * @return Rest_Log_* @group UUID__c log
    */
    public Rest_Log_* @group UUID__c build() {
        return this.log;
    }

    /**
    * @description returns the status depending if an errorCode is set or not
    * @return String status
    */
    private String getStatus() {
        if(this.log.Error_Code_* @group UUID__c == null) {
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