import { AvoNetworkCallsHandler } from "./AvoNetworkCallsHandler";
import { AvoInspector } from "./AvoInspector";
import { AvoGuid } from "./AvoGuid";

export interface AvoBatcherType {
  handleTrackSchema(
    eventName: string,
    schema: Array<{
      propertyName: string;
      propertyType: string;
      children?: any;
    }>,
    eventId: string | null,
    eventHash: string | null
  ): Promise<void>;
}

export class AvoBatcher implements AvoBatcherType {
  private networkCallsHandler: AvoNetworkCallsHandler;

  constructor(networkCallsHandler: AvoNetworkCallsHandler) {
    this.networkCallsHandler = networkCallsHandler;
  }

  handleTrackSchema(
    eventName: string,
    schema: Array<{
      propertyName: string;
      propertyType: string;
      children?: any;
    }>,
    eventId: string | null,
    eventHash: string | null
  ): Promise<void> {
    const seeionId = AvoGuid.newGuid();
    return this.networkCallsHandler
      .callInspectorWithBatchBody([
        this.networkCallsHandler.bodyForSessionStartedCall(seeionId),
      ])
      .then(() => {
        if (AvoInspector.shouldLog) {
          console.log("Avo Inspector: schema sent successfully.");
        }
        this.networkCallsHandler.callInspectorWithBatchBody([
          this.networkCallsHandler.bodyForEventSchemaCall(
            seeionId,
            eventName,
            schema,
            eventId,
            eventHash
          ),
        ]);
      })
      .catch((err) => {
        if (AvoInspector.shouldLog) {
          console.log("Avo Inspector: schema sending failed: " + err + ".");
        }
      });
  }
}
