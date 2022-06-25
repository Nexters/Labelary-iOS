import { AvoBatcher } from "../AvoBatcher";
import { AvoInspector } from "../AvoInspector";
import { AvoNetworkCallsHandler } from "../AvoNetworkCallsHandler";

import { defaultOptions } from "./constants";

const inspectorVersion = process.env.npm_package_version || "";

jest.mock("../AvoBatcher");

describe("Batcher", () => {
  let inspector: AvoInspector;

  const { apiKey, env, version } = defaultOptions;
  let networkHandler = new AvoNetworkCallsHandler(
    apiKey,
    env,
    "my-test-app",
    version,
    inspectorVersion
  );

  beforeAll(() => {
    inspector = new AvoInspector(defaultOptions);
    inspector.enableLogging(false);

    jest
      .spyOn(AvoBatcher.prototype as any, "handleTrackSchema")
      .mockImplementation(() => {
        return Promise.resolve();
      });
  });

  afterEach(() => {
    jest.clearAllMocks();
    // @ts-ignore
    inspector.avoDeduplicator._clearEvents();
  });

  test("Batcher is initialized on Inspector init", () => {
    expect(AvoBatcher).toHaveBeenCalledTimes(1);
    expect(AvoBatcher).toHaveBeenCalledWith(networkHandler);
  });

  test("handleTrackSchema is called on trackSchemaFromEvent", () => {
    const eventName = "event name";
    const properties = {
      prop0: "",
      prop2: false,
      prop3: 0,
      prop4: 0.0,
    };

    const schema = inspector.extractSchema(properties);

    inspector.trackSchemaFromEvent(eventName, properties);

    expect(inspector.avoBatcher.handleTrackSchema).toHaveBeenCalledTimes(1);
    expect(inspector.avoBatcher.handleTrackSchema).toBeCalledWith(
      eventName,
      schema,
      null,
      null
    );
  });

  test("handleTrackSchema is called on _avoFunctionTrackSchemaFromEvent", () => {
    const eventName = "event name";
    const properties = {
      prop0: "",
      prop2: false,
      prop3: 0,
      prop4: 0.0,
    };
    const eventId = "testId";
    const eventHash = "testHash";

    const schema = inspector.extractSchema(properties);

    // @ts-ignore
    inspector._avoFunctionTrackSchemaFromEvent(
      eventName,
      properties,
      eventId,
      eventHash
    );

    expect(inspector.avoBatcher.handleTrackSchema).toHaveBeenCalledTimes(1);
    expect(inspector.avoBatcher.handleTrackSchema).toBeCalledWith(
      eventName,
      schema,
      eventId,
      eventHash
    );
  });
});
