type t;

[@bs.deriving jsConverter]
type env = [
  | [@bs.as "dev"] `Dev
  | [@bs.as "staging"] `Staging
  | [@bs.as "prod"] `Prod
];

[@bs.deriving abstract]
type options = {
  apiKey: string,
  env: string,
  version: string,
  appName: string,
};

[@bs.new] [@bs.module "node-avo-inspector"]
external make: options => t = "AvoInspector";

let make = (~apiKey, ~env, ~version, ~appName, ()) => {
  make(options(~apiKey, ~env=envToJs(env), ~version, ~appName));
};

[@bs.send]
external trackSchemaFromEvent: (t, string, Js.Json.t) => Js.Promise.t(unit) =
  "trackSchemaFromEvent";
