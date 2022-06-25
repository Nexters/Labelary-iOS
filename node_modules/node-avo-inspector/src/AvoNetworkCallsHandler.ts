import { AvoGuid } from "./AvoGuid";
import { AvoInspector } from "./AvoInspector";

export interface BaseBody {
  apiKey: string;
  appName: string;
  appVersion: string;
  libVersion: string;
  env: string;
  libPlatform: "node";
  messageId: string;
  trackingId: string;
  createdAt: string;
  sessionId: string;
  samplingRate: number;
}

export interface SessionStartedBody extends BaseBody {
  type: "sessionStarted";
}

export interface EventSchemaBody extends BaseBody {
  type: "event";
  eventName: string;
  eventProperties: Array<{
    propertyName: string;
    propertyType: string;
    children?: any;
  }>;
  avoFunction: boolean;
  eventId: string | null;
  eventHash: string | null;
}

export class AvoNetworkCallsHandler {
  private apiKey: string;
  private envName: string;
  private appName: string;
  private appVersion: string;
  private libVersion: string;
  private samplingRate: number = 1.0;

  private static trackingEndpoint = "/inspector/v1/track";

  constructor(
    apiKey: string,
    envName: string,
    appName: string,
    appVersion: string,
    libVersion: string
  ) {
    this.apiKey = apiKey;
    this.envName = envName;
    this.appName = appName;
    this.appVersion = appVersion;
    this.libVersion = libVersion;
  }

  callInspectorWithBatchBody(
    inEvents: Array<SessionStartedBody | EventSchemaBody>
  ): Promise<void> {
    const events = inEvents.filter((x) => x != null);

    if (events.length === 0) {
      return Promise.resolve();
    }

    if (Math.random() > this.samplingRate) {
      if (AvoInspector.shouldLog) {
        console.log(
          "Avo Inspector: last event schema dropped due to sampling rate."
        );
      }
      return Promise.resolve();
    }

    if (AvoInspector.shouldLog) {
      events.forEach(function (event) {
        if (event.type === "sessionStarted") {
          console.log("Avo Inspector: sending session started event.");
        } else if (event.type === "event") {
          let schemaEvent: EventSchemaBody = event;
          console.log(
            "Avo Inspector: sending event " +
              schemaEvent.eventName +
              " with schema " +
              JSON.stringify(schemaEvent.eventProperties)
          );
        }
      });
    }

    return new Promise(function (resolve, reject) {
      const data = JSON.stringify(events);
      var options = {
        hostname: "api.avo.app",
        port: 443,
        path: AvoNetworkCallsHandler.trackingEndpoint,
        method: "POST",
        headers: {
          "Content-Type": "text/plain",
          "Content-Length": Buffer.byteLength(data),
        },
      };
      var req = require("https").request(options, (res: any) => {
        const chunks: any = [];
        res.on("data", (data: any) => chunks.push(data));
        res.on("end", () => {
          try {
            // @ts-ignore
            const data = JSON.parse(Buffer.concat(chunks).toString());
            // @ts-ignore
            this.samplingRate = data.samplingRate;
          } catch (e) {}
          resolve();
        });
      });
      req.write(data);
      req.on("error", () => {
        reject("Request failed");
      });
      req.on("timeout", () => {
        reject("Request timed out");
      });
      req.end();
    });
  }

  bodyForSessionStartedCall(sessionId: string): SessionStartedBody {
    let sessionBody = this.createBaseCallBody(sessionId) as SessionStartedBody;
    sessionBody.type = "sessionStarted";
    return sessionBody;
  }

  bodyForEventSchemaCall(
    sessionId: string,
    eventName: string,
    eventProperties: Array<{
      propertyName: string;
      propertyType: string;
      children?: any;
    }>,
    eventId: string | null,
    eventHash: string | null
  ): EventSchemaBody {
    let eventSchemaBody = this.createBaseCallBody(sessionId) as EventSchemaBody;
    eventSchemaBody.type = "event";
    eventSchemaBody.eventName = eventName;
    eventSchemaBody.eventProperties = eventProperties;

    if (eventId != null) {
      eventSchemaBody.avoFunction = true;
      eventSchemaBody.eventId = eventId;
      eventSchemaBody.eventHash = eventHash;
    } else {
      eventSchemaBody.avoFunction = false;
      eventSchemaBody.eventId = null;
      eventSchemaBody.eventHash = null;
    }

    return eventSchemaBody;
  }

  private createBaseCallBody(sessionId: string): BaseBody {
    return {
      apiKey: this.apiKey,
      appName: this.appName,
      appVersion: this.appVersion,
      libVersion: this.libVersion,
      env: this.envName,
      libPlatform: "node",
      messageId: AvoGuid.newGuid(),
      trackingId: "",
      createdAt: new Date().toISOString(),
      sessionId: sessionId,
      samplingRate: this.samplingRate,
    };
  }
}
