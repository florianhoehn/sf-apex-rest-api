/**
* @author Florian Hoehn
* defines the core functionality of all wrapper classes
* should be extended: mapFields & convertFields needs to be overridden
**/
public with sharing abstract class RestWrapper {
    /**
    * constructor
    */
    public RestWrapper() {}

    /**
    * constructor, calls mapFields method (overridden one if extended)
    * @param Object obj
    */
    public RestWrapper(Object obj) {
      this.mapFields(obj);
    }

    /**
    * serializes the wrapper object into json string without nulls
    * @return String json
    */
    public String toJSON() {
        return System.JSON.serialize(this, true);
    }

    /**
    * convert method which calls the (overridden) convertFields method
    * @return Object obj
    */
    public Object convert() {
        return this.convertFields();
    }

    /**
    * mapFields: MUST be overridden by child classes to extend functionality
    * @param Object obj
    */
    private abstract void mapFields(Object obj);

    /**
    * convertFields: should be overridden by child classes to extend functionality
    * @return Object obj
    */
    private virtual Object convertFields() { return null; }
}