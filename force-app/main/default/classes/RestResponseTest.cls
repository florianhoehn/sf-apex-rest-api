/**
* RestResponseTest.cls
* Created By: Florian Hoehn
* Created On: January 17th, 2017
* Description: tests RestResponse
**/
@isTest
private class RestResponseTest {
    /**
    * @description tests constructor
    */
    @isTest
    private static void it_should_Instantiate() {
        Test.startTest();
            RestResponse actualRestResponse = new RestResponse();
        Test.stopTest();

        System.assertNotEquals(null, actualRestResponse);
        System.assertNotEquals(null, actualRestResponse.errors);
        System.assertEquals(true, actualRestResponse.errors.isEmpty());
        System.assertEquals(null, actualRestResponse.success);
    }

    /**
    * @description tests constructor with object
    */
    @isTest
    private static void it_should_InstantiateWithObject() {
        Test.startTest();
            RestResponse actualRestResponse = new RestResponse('testObject');
        Test.stopTest();

        System.assertNotEquals(null, actualRestResponse);
        System.assertNotEquals(null, actualRestResponse.errors);
        System.assertEquals(true, actualRestResponse.errors.isEmpty());
        System.assertEquals(null, actualRestResponse.success);
    }

    /**
    * @description tests error wrapper constructor
    */
    @isTest
    private static void it_should_InstantiateRestError() {
        Test.startTest();
            RestResponse.RestError actualRestError = new RestResponse.RestError();
        Test.stopTest();

        System.assertNotEquals(null, actualRestError);
        System.assertEquals(null, actualRestError.errorCode);
        System.assertEquals(null, actualRestError.message);
    }

    /**
    * @description tests error wrapper constructor with parameters
    */
    @isTest
    private static void it_should_InstantiateRestErrorWithParameters() {
        String expectedErrorCode = '404';
        String expectedMessage = 'NOT FOUND';

        Test.startTest();
            RestResponse.RestError actualRestError = new RestResponse.RestError(expectedErrorCode, expectedMessage);
        Test.stopTest();

        System.assertNotEquals(null, actualRestError);
        System.assertEquals(expectedErrorCode, actualRestError.errorCode);
        System.assertEquals(expectedMessage, actualRestError.message);
    }

    /**
    * @description tests to json inherited from RestWrapper
    */
    @isTest
    private static void it_should_ReturnJSON() {
        RestResponse actualRestResponse = new RestResponse('testObject');
        actualRestResponse.success = true;

        Test.startTest();
            String actualJson = actualRestResponse.toJson();
        Test.stopTest();

        System.assertNotEquals(null, actualJson);
        System.assert(actualJson.contains('true'));
    }

    /**
    * @description tests convert inherited from RestWrapper
    */
    @isTest
    private static void it_should_ConvertToObject() {
        RestResponse actualRestResponse = new RestResponse('testObject');
        actualRestResponse.success = true;

        Test.startTest();
            Object actualNewObject = actualRestResponse.convert();
        Test.stopTest();

        System.assertEquals(null, actualNewObject);
    }

}