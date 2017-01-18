/**
* RestWrapperMVN.cls
* Created By: Florian Hoehn
* Created On: 09/15/2016
* Description: defines the core functionality of all wrapper classes
*              should be extended: mapFields & convertFields needs to be overridden
**/
public with sharing abstract class RestWrapperMVN {
    /**
    * @description constructor
    */
    public RestWrapperMVN() {}
    
    /**
    * @description constructor, calls mapFields method (overridden one if extended)
    * @param Object obj
    */
    public RestWrapperMVN(Object obj) {
      this.mapFields(obj);
    }

    /**
    * @description serializes the wrapper object into json string without nulls
    * @return String json
    */
    public String toJSON() {
        return System.JSON.serialize(this, true);
    }

    /**
    * @description convert method which calls the (overridden) convertFields method
    * @return Object obj
    */
    public Object convert() {
        return this.convertFields();
    }
    
    /**
    * @description mapFields: MUST be overridden by child classes to extend functionality
    * @param Object obj
    */
    private abstract void mapFields(Object obj);
    
    /**
    * @description convertFields: should be overridden by child classes to extend functionality
    * @return Object obj
    */
    private virtual Object convertFields() { return null; }
}