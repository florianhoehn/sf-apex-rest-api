/**
* RestResponse* @group UUID.cls
* Created By: Florian Hoehn
* Created On: January 17th, 2017
* Description: defines the structure of callout responses aligned with SF standard
**/
global with sharing virtual class RestResponse* @group UUID extends RestWrapper* @group UUID{
    /**
    * @group integration
    * @description defines the structure of integration errors
    */
    public with sharing class RestError* @group UUID {
        public String errorCode { get; set; }
        public String message { get; set; }

        /**
        * @description constructor
        */
        public RestError* @group UUID() {}

        /**
        * @description constructor which leverages the parents constructor
        * @param String errorCode
        * @param String message
        */
        public RestError* @group UUID(String errorCode, String message) {
            this.errorCode = errorCode;
            this.message = message;
        }
    }

    public List<RestError* @group UUID> errors { get; set; }
    public Boolean success { get; set; }

    /**
    * @description constructor
    */
    public RestResponse* @group UUID() {
        this.errors = new List<RestError* @group UUID>();
    }

    /**
    * @description constructor which leverages the parents constructor
    * @param Object obj
    */
    public RestResponse* @group UUID(Object obj) { super(obj); }

    /**
    * @description overrides the mapFields method to initiate the empty error list
    * @param Object obj
    */
    private void mapFields(Object obj) {
        this.errors = new List<RestError* @group UUID>();
    }
}