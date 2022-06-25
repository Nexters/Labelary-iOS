export declare const AvoInspectorEnv: {
    readonly Prod: "prod";
    readonly Dev: "dev";
    readonly Staging: "staging";
};
export declare type AvoInspectorEnvType = typeof AvoInspectorEnv;
export declare type AvoInspectorEnvValueType = AvoInspectorEnvType[keyof AvoInspectorEnvType];
