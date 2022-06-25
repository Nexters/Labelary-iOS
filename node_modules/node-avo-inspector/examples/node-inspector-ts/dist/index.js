"use strict";
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const Inspector = __importStar(require("node-avo-inspector"));
const inspector = new Inspector.AvoInspector({
    apiKey: "My Api Key",
    env: Inspector.AvoInspectorEnv.Prod,
    version: "1.0.0",
    appName: "My App"
});
let eventName = "App Launched";
let eventParams = {
    "userId": "odsbet455d",
    "isAdmin": true,
    "answer": 42,
    "pi": 3.14,
    "void": null,
    "shoppingList": ["Bread", "Butter", "Salt"],
    "birthdayGift": {
        "name": "pool",
        "radius": 7,
        "depth": 2.1
    }
};
inspector.enableLogging(true); // default is true for dev and false for prod
inspector.trackSchemaFromEvent(eventName, eventParams).then((eventSchema) => {
    console.log("Event schema sent to Avo Inspector", eventSchema);
});
