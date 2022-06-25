import { AvoInspector } from "../AvoInspector";
import { AvoNetworkCallsHandler } from "../AvoNetworkCallsHandler";

import { defaultOptions } from "./constants";

describe("Batcher", () => {
  let inspectorCallSpy: jest.SpyInstance<any, unknown[]>;

  const { apiKey, env, version, shouldLog, appName } = defaultOptions;

  beforeAll(() => {
    inspectorCallSpy = jest.spyOn(
      AvoNetworkCallsHandler.prototype as any,
      "callInspectorWithBatchBody"
    );
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  test("handleTrackSchema sends session to AvoNetworkCallsHandler and then sends event respecting sampling rate", async () => {
    const inspector = new AvoInspector(defaultOptions);
    inspector.enableLogging(false);

    inspectorCallSpy.mockImplementation(() => {
      inspector.avoBatcher["networkCallsHandler"]["samplingRate"] = 0.1;
      return Promise.resolve();
    });

    await inspector.avoBatcher.handleTrackSchema("event name", [], null, null);

    expect(inspectorCallSpy).toHaveBeenCalledTimes(2);
    expect(inspectorCallSpy).toHaveBeenCalledWith([
      expect.objectContaining({
        type: "sessionStarted",
        apiKey: apiKey,
        appName: appName,
        appVersion: version,
        libVersion: expect.anything(),
        env: env,
        libPlatform: "node",
        messageId: expect.anything(),
        trackingId: "",
        createdAt: expect.anything(),
        sessionId: expect.anything(),
        samplingRate: 1,
      }),
    ]);
    expect(inspectorCallSpy).toHaveBeenCalledWith([
      expect.objectContaining({
        type: "event",
        apiKey: apiKey,
        appName: appName,
        appVersion: version,
        libVersion: expect.anything(),
        env: env,
        libPlatform: "node",
        messageId: expect.anything(),
        trackingId: "",
        createdAt: expect.anything(),
        sessionId: expect.anything(),
        samplingRate: 0.1,
      }),
    ]);
  });
});
