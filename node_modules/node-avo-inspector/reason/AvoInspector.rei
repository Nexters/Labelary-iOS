type t; 

type env = [
  | `Dev
  | `Staging
  | `Prod
];

let make: (~apiKey: string, ~env: env, ~version: string, , ~appName: string, unit) => t;

let trackSchemaFromEvent: t => string => Js.Json.t => Js.Promise.t(unit);
