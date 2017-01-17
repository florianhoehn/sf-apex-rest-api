/**
* RestResponseMVN.cls
* Created By: Florian Hoehn
* Created On: January 17th, 2017
* Description: defines the structure of callout responses aligned with SF standard 
**/
global with sharing virtual class RestResponseMVN extends RestWrapperMVN{
    /**
    * @author Florian Hoehn
    * @date January 17th, 2017
    * @group integration
    * @description defines the structure of integration errors
    */
    public with sharing class RestErrorMVN {
        public String errorCode { get; set; }
        public String message { get; set; }
    
        /**
        * @description constructor
        * @date January 17th, 2017
        */
        public RestErrorMVN() {}
        
        /**
        * @description constructor which leverages the parents constructor
        * @date January 17th, 2017
        * @param String errorCode
        * @param String message
        */
        public RestErrorMVN(String errorCode, String message) {
            this.errorCode = errorCode;
            this.message = message;
        }
    }
    
    public List<RestErrorMVN> errors { get; set; }
    public Boolean success { get; set; }

    /**
    * @description constructor
    * @date January 17th, 2017
    */
    public RestResponseMVN() {
        this.errors = new List<RestErrorMVN>();
    }

    /**
    * @description constructor which leverages the parents constructor
    * @date January 17th, 2017
    * @param Object obj
    */
    public RestResponseMVN(Object obj) { super(obj); }

    /**
    * @description overrides the mapFields method to initiate the empty error list
    * @date January 17th, 2017
    * @param Object obj
    */    
    private void mapFields(Object obj) {
        this.errors = new List<RestErrorMVN>();
    }
}