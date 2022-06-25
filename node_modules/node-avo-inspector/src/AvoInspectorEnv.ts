export const AvoInspectorEnv = {
  Prod: "prod",
  Dev: "dev",
  Staging: "staging",
} as const;

export type AvoInspectorEnvType = typeof AvoInspectorEnv;
export type AvoInspectorEnvValueType = AvoInspectorEnvType[keyof AvoInspectorEnvType];
