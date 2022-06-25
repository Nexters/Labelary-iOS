# Avo Inspector SDK for Node.js

This is a quick start guide. For more information about the Inspector project please read [Avo Inspector SDK Reference](https://www.avo.app/docs/implementation/avo-inspector-sdk-reference) and the [Avo Inspector Setup Guide](https://www.avo.app/docs/implementation/setup-inspector-sdk).

# Installation

The library is distributed with npm, install with npm:
```
    npm i node-avo-inspector
```

or yarn:
```
    yarn add node-avo-inspector
```

# Initialization

Obtain the API key from the Inspector tab (Inspector > Manage Sources) in your [Avo workspace](https://www.avo.app/welcome)

```javascript
import * as Inspector from "node-avo-inspector";

let inspector = new Inspector.AvoInspector({
  apiKey: "your api key",
  env: Inspector.AvoInspectorEnv.Dev,
  version: "1.0.0",
  appName: "My app",
});
```

# Sending event schemas

Whenever you send tracking event call the following method:
Read more in the [Avo documentation](https://www.avo.app/docs/implementation/inspector/sdk/node)

This method gets actual tracking event parameters, extracts schema automatically and sends it to the Avo Inspector backend.
It is the easiest way to use the library, just call this method at the same place you call your analytics tools' track methods with the same parameters.

```javascript
inspector.trackSchemaFromEvent("Event name", {
  "String Prop": "Prop Value",
  "Float Prop": 1.0,
  "Boolean Prop": true,
});
```

# Enabling logs

Logs are enabled by default in the dev mode and disabled in prod mode. You can enable and disable logs by calling the `enableLogging` method:

```javascript
inspector.enableLogging(true | false);
```

## Author
Avo (https://www.avo.app), hi@avo.app

## License
AvoInspector is available under the MIT license.
