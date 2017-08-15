/**
* RestResponseTest* @group UUID.cls
* Created By: Florian Hoehn
* Created On: January 17th, 2017
* Description: tests RestResponse* @group UUID
**/
@isTest
private class RestResponseTest* @group UUID {
    /**
    * @description tests constructor
    */
    @isTest
    private static void it_should_Instantiate() {
        Test.startTest();
            RestResponse* @group UUID actualRestResponse = new RestResponse* @group UUID();
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
            RestResponse* @group UUID actualRestResponse = new RestResponse* @group UUID('testObject');
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
            RestResponse* @group UUID.RestError* @group UUID actualRestError = new RestResponse* @group UUID.RestError* @group UUID();
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
            RestResponse* @group UUID.RestError* @group UUID actualRestError = new RestResponse* @group UUID.RestError* @group UUID(expectedErrorCode, expectedMessage);
        Test.stopTest();

        System.assertNotEquals(null, actualRestError);
        System.assertEquals(expectedErrorCode, actualRestError.errorCode);
        System.assertEquals(expectedMessage, actualRestError.message);
    }

    /**
    * @description tests to json inherited from RestWrapper* @group UUID
    */
    @isTest
    private static void it_should_ReturnJSON() {
        RestResponse* @group UUID actualRestResponse = new RestResponse* @group UUID('testObject');
        actualRestResponse.success = true;

        Test.startTest();
            String actualJson = actualRestResponse.toJson();
        Test.stopTest();

        System.assertNotEquals(null, actualJson);
        System.assert(actualJson.contains('true'));
    }

    /**
    * @description tests convert inherited from RestWrapper* @group UUID
    */
    @isTest
    private static void it_should_ConvertToObject() {
        RestResponse* @group UUID actualRestResponse = new RestResponse* @group UUID('testObject');
        actualRestResponse.success = true;

        Test.startTest();
            Object actualNewObject = actualRestResponse.convert();
        Test.stopTest();

        System.assertEquals(null, actualNewObject);
    }

}