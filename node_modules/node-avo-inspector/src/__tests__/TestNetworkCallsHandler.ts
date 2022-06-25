import { AvoGuid } from "../AvoGuid";
import { AvoNetworkCallsHandler, BaseBody } from "../AvoNetworkCallsHandler";

import {
  defaultOptions,
  mockedReturns,
} from "./constants";

const inspectorVersion = process.env.npm_package_version || "";

describe("NetworkCallsHandler", () => {
  const { apiKey, env, version } = defaultOptions;
  const appName = "";

  let networkHandler: AvoNetworkCallsHandler;
  let baseBody: BaseBody;

  const customCallback = jest.fn();
  const now = new Date();

  beforeAll(() => {
    // @ts-ignore
    jest.spyOn(global, "Date").mockImplementation(() => now);

    jest
      .spyOn(AvoGuid as any, "newGuid")
      .mockImplementation(() => mockedReturns.GUID);

    networkHandler = new AvoNetworkCallsHandler(
      apiKey,
      env,
      "",
      version,
      inspectorVersion
    );

    baseBody = {
      apiKey,
      appName,
      appVersion: version,
      libVersion: inspectorVersion,
      env,
      libPlatform: "node",
      messageId: mockedReturns.GUID,
      trackingId: "",
      createdAt: new Date().toISOString(),
      sessionId: mockedReturns.SESSION_ID,
      samplingRate: 1.0,
    };
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  test("bodyForSessionStartedCall returns base body + session started body used for session started", () => {
    const body = networkHandler.bodyForSessionStartedCall(
      mockedReturns.SESSION_ID
    );

    expect(body).toEqual({
      ...baseBody,
      type: "sessionStarted",
    });
  });

  test("bodyForEventSchemaCall returns base body + event schema used for event sending from non avo functions", () => {
    const eventName = "event name";
    const eventProperties = [{ propertyName: "prop0", propertyType: "string" }];

    const body = networkHandler.bodyForEventSchemaCall(
      mockedReturns.SESSION_ID,
      eventName,
      eventProperties,
      null,
      null
    );

    expect(body).toEqual({
      ...baseBody,
      type: "event",
      eventName,
      eventProperties,
      avoFunction: false,
      eventId: null,
      eventHash: null,
    });
  });

  test("bodyForEventSchemaCall returns base body + event schema used for event sending from avo functions", () => {
    const eventName = "event name";
    const eventId = "event id";
    const eventHash = "event hash";
    const eventProperties = [{ propertyName: "prop0", propertyType: "string" }];

    const body = networkHandler.bodyForEventSchemaCall(
      mockedReturns.SESSION_ID,
      eventName,
      eventProperties,
      eventId,
      eventHash
    );

    expect(body).toEqual({
      ...baseBody,
      type: "event",
      eventName,
      eventProperties,
      avoFunction: true,
      eventId,
      eventHash,
    });
  });
});
