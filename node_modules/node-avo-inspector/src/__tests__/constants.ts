import { AvoInspectorEnv } from "../AvoInspectorEnv";

const defaultOptions = {
  apiKey: "api-key-xxx",
  env: AvoInspectorEnv.Dev,
  version: "1",
  shouldLog: true,
  appName: "my-test-app",
};

const error = {
  API_KEY:
    "[Avo Inspector] No API key provided. Inspector can't operate without API key.",
  VERSION:
    "[Avo Inspector] No version provided. Many features of Inspector rely on versioning. Please provide comparable string version, i.e. integer or semantic.",
};

const mockedReturns = {
  INSTALLATION_ID: "avo-instalation-id",
  GUID: "generated-guid",
  SESSION_ID: "session-id",
};

const networkCallType = {
  EVENT: "event",
  SESSION_STARTED: "sessionStarted",
};

const requestMsg = {
  ERROR: "Request failed",
  TIMEOUT: "Request timed out",
};

const trackingEndpoint = "https://api.avo.app/inspector/v1/track";

const sessionTimeMs = 5 * 60 * 1000;

const type = {
  STRING: "string",
  INT: "int",
  OBJECT: "object",
  FLOAT: "float",
  LIST: "list",
  BOOL: "boolean",
  NULL: "null",
  UNKNOWN: "unknown",
};

export {
  defaultOptions,
  error,
  mockedReturns,
  networkCallType,
  requestMsg,
  sessionTimeMs,
  type,
  trackingEndpoint,
};
