/**
* @author Florian Hoehn
* tests RestResponse
**/
@isTest
private class RestResponseTest {
    /**
    * tests constructor
    */
    @isTest
    private static void instantiate() {
        Test.startTest();
            RestResponse actualRestResponse = new RestResponse();
        Test.stopTest();

        System.assertNotEquals(null, actualRestResponse, 'Response is not set');
        System.assertNotEquals(null, actualRestResponse.errors, 'Errors are not set');
        System.assertEquals(true, actualRestResponse.errors.isEmpty(), 'Errors do not match');
        System.assertEquals(null, actualRestResponse.success, 'Success does not match');
    }

    /**
    * tests constructor with object
    */
    @isTest
    private static void instantiateWithObject() {
        Test.startTest();
            RestResponse actualRestResponse = new RestResponse('testObject');
        Test.stopTest();

        System.assertNotEquals(null, actualRestResponse, 'Response is not set');
        System.assertNotEquals(null, actualRestResponse.errors, 'Errors are not set');
        System.assertEquals(true, actualRestResponse.errors.isEmpty(), 'Errors do not match');
        System.assertEquals(null, actualRestResponse.success, 'Success does not match');
    }

    /**
    * tests error wrapper constructor
    */
    @isTest
    private static void instantiateRestError() {
        Test.startTest();
            RestResponse.RestError actualRestError = new RestResponse.RestError();
        Test.stopTest();

        System.assertNotEquals(null, actualRestError, 'Error is not set');
        System.assertEquals(null, actualRestError.errorCode, 'Error Code is not set');
        System.assertEquals(null, actualRestError.message, 'Error Message is not set');
    }

    /**
    * tests error wrapper constructor with parameters
    */
    @isTest
    private static void instantiateRestErrorWithParameters() {
        String expectedErrorCode = '404';
        String expectedMessage = 'NOT FOUND';

        Test.startTest();
            RestResponse.RestError actualRestError = new RestResponse.RestError(expectedErrorCode, expectedMessage);
        Test.stopTest();

        System.assertNotEquals(null, actualRestError, 'Error is not set');
        System.assertEquals(expectedErrorCode, actualRestError.errorCode, 'Error Code does not match');
        System.assertEquals(expectedMessage, actualRestError.message, 'Error Message does not match');
    }

    /**
    * tests to json inherited from RestWrapper
    */
    @isTest
    private static void returnJSON() {
        RestResponse actualRestResponse = new RestResponse('testObject');
        actualRestResponse.success = true;

        Test.startTest();
            String actualJson = actualRestResponse.toJson();
        Test.stopTest();

        System.assertNotEquals(null, actualJson, 'JSON is not set');
        System.assert(actualJson.contains('true'), 'JSON does not contain TRUE');
    }

    /**
    * tests convert inherited from RestWrapper
    */
    @isTest
    private static void convertToObject() {
        RestResponse actualRestResponse = new RestResponse('testObject');
        actualRestResponse.success = true;

        Test.startTest();
            Object actualNewObject = actualRestResponse.convert();
        Test.stopTest();

        System.assertEquals(null, actualNewObject, 'New Object is not set');
    }

}