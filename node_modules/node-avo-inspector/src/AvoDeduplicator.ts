import { deepEquals } from "./utils";

export class AvoDeduplicator {
  avoFunctionsEvents: { [time: number]: string } = {};
  manualEvents: { [time: number]: string } = {};
  private msToConsiderOld = 500;

  avoFunctionsEventsParams: {
    [eventName: string]: { [propName: string]: any };
  } = {};
  manualEventsParams: { [eventName: string]: { [propName: string]: any } } = {};

  shouldRegisterEvent(
    eventName: string,
    params: { [propName: string]: any },
    fromAvoFunction: boolean
  ): boolean {
    this.clearOldEvents();

    if (fromAvoFunction) {
      this.avoFunctionsEvents[Date.now()] = eventName;
      this.avoFunctionsEventsParams[eventName] = params;
    } else {
      this.manualEvents[Date.now()] = eventName;
      this.manualEventsParams[eventName] = params;
    }

    let checkInAvoFunctions = !fromAvoFunction;

    return !this.hasSameEventAs(eventName, params, checkInAvoFunctions);
  }

  private hasSameEventAs(
    eventName: string,
    params: { [propName: string]: any },
    checkInAvoFunctions: boolean
  ): boolean {
    let result = false;

    if (checkInAvoFunctions) {
      if (
        this.lookForEventIn(eventName, params, this.avoFunctionsEventsParams)
      ) {
        result = true;
      }
    } else {
      if (this.lookForEventIn(eventName, params, this.manualEventsParams)) {
        result = true;
      }
    }

    if (result) {
      delete this.avoFunctionsEventsParams[eventName];
      delete this.manualEventsParams[eventName];
    }

    return result;
  }

  private lookForEventIn(
    eventName: string,
    params: { [propName: string]: any },
    eventsStorage: { [eventName: string]: { [propName: string]: any } }
  ): boolean {
    for (const otherEventName in eventsStorage) {
      if (eventsStorage.hasOwnProperty(otherEventName)) {
        if (otherEventName === eventName) {
          const otherParams = eventsStorage[eventName];
          if (otherParams && deepEquals(params, otherParams)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  hasSeenEventParams(
    params: { [propName: string]: any },
    checkInAvoFunctions: boolean
  ) {
    let result = false;

    if (checkInAvoFunctions) {
      if (this.lookForEventParamsIn(params, this.avoFunctionsEventsParams)) {
        result = true;
      }
    } else {
      if (this.lookForEventParamsIn(params, this.manualEventsParams)) {
        result = true;
      }
    }

    return result;
  }

  private lookForEventParamsIn(
    params: { [propName: string]: any },
    eventsStorage: { [eventName: string]: { [propName: string]: any } }
  ): boolean {
    for (const otherEventName in eventsStorage) {
      if (eventsStorage.hasOwnProperty(otherEventName)) {
        const otherParams = eventsStorage[otherEventName];
        if (otherParams && deepEquals(params, otherParams)) {
          return true;
        }
      }
    }
    return false;
  }

  private clearOldEvents() {
    const now = Date.now();

    for (const time in this.avoFunctionsEvents) {
      if (this.avoFunctionsEvents.hasOwnProperty(time)) {
        const timestamp = Number(time) || 0;
        if (now - timestamp > this.msToConsiderOld) {
          const eventName = this.avoFunctionsEvents[time];
          delete this.avoFunctionsEvents[time];
          delete this.avoFunctionsEventsParams[eventName];
        }
      }
    }

    for (const time in this.manualEvents) {
      if (this.manualEvents.hasOwnProperty(time)) {
        const timestamp = Number(time) || 0;
        if (now - timestamp > this.msToConsiderOld) {
          const eventName = this.manualEvents[time];
          delete this.manualEvents[time];
          delete this.manualEventsParams[eventName];
        }
      }
    }
  }

  // used in tests
  private _clearEvents() {
    this.avoFunctionsEvents = {};
    this.manualEvents = {};

    this.avoFunctionsEventsParams = {};
    this.manualEventsParams = {};
  }
}
