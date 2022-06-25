export declare class AvoSchemaParser {
    static extractSchema(eventProperties: {
        [propName: string]: any;
    }): Array<{
        propertyName: string;
        propertyType: string;
        children?: any;
    }>;
    private static removeDuplicates;
    private static getPropValueType;
}
