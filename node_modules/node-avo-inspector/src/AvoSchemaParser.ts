let isArray = (obj: any): boolean => {
  return Object.prototype.toString.call(obj) === "[object Array]";
};

export class AvoSchemaParser {
  static extractSchema(eventProperties: {
    [propName: string]: any;
  }): Array<{
    propertyName: string;
    propertyType: string;
    children?: any;
  }> {
    if (eventProperties === null || eventProperties === undefined) {
      return [];
    }

    let mapping = (object: any) => {
      if (isArray(object)) {
        let list = object.map((x: any) => {
          return mapping(x);
        });
        return this.removeDuplicates(list);
      } else if (typeof object === "object") {
        let mappedResult: any = [];
        for (var key in object) {
          if (object.hasOwnProperty(key)) {
            let val = object[key];

            let mappedEntry: {
              propertyName: string;
              propertyType: string;
              children?: any;
            } = {
              propertyName: key,
              propertyType: this.getPropValueType(val),
            };

            if (typeof val === "object" && val != null) {
              mappedEntry["children"] = mapping(val);
            }

            mappedResult.push(mappedEntry);
          }
        }

        return mappedResult;
      } else {
        return this.getPropValueType(object);
      }
    };

    var mappedEventProps = mapping(eventProperties);

    return mappedEventProps;
  }

  private static removeDuplicates(array: Array<any>): Array<any> {
    // XXX TODO fix any types
    var primitives: any = { boolean: {}, number: {}, string: {} };
    var objects: Array<any> = [];

    return array.filter((item: any) => {
      var type: string = typeof item;
      if (type in primitives) {
        return primitives[type].hasOwnProperty(item)
          ? false
          : (primitives[type][item] = true);
      } else {
        return objects.indexOf(item) >= 0 ? false : objects.push(item);
      }
    });
  }

  private static getPropValueType(propValue: any): string {
    let propType = typeof propValue;
    if (propValue == null) {
      return "null";
    } else if (propType === "string") {
      return "string";
    } else if (propType === "number" || propType === "bigint") {
      if ((propValue + "").indexOf(".") >= 0) {
        return "float";
      } else {
        return "int";
      }
    } else if (propType === "boolean") {
      return "boolean";
    } else if (propType === "object") {
      if (isArray(propValue)) {
        return "list";
      } else {
        return "object";
      }
    } else {
      return "unknown";
    }
  }
}
