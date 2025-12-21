package ar.services;

import io.lippia.api.lowcode.variables.VariablesManager;

import static io.lippia.api.lowcode.JsonKeysProcessor.delete;
import static io.lippia.api.lowcode.JsonKeysProcessor.set;


public class FailAddTEService {

    public static void generateTestBody(String bodyRequest) {
        String base = "jsons/bodies/bodyAddNewTimeEntry.json";

        if (bodyRequest.equals("no body in request")) {
            VariablesManager.setVariable("testBody", "");
            return;
        }

        VariablesManager.setVariable("testBody", base);

        switch (bodyRequest) {

            case "without start key":
                delete("start", "$(var.testBody)");
                break;

            case "with null start value":
                VariablesManager.setVariable("testBody","jsons/bodies/bodyTENullStart.json");
                break;

            case "without start hour":
                set("2025-12-18T", "start", "$(var.testBody)");
                break;

            case "without start date":
                set("T07:00:00-03:00", "start", "$(var.testBody)");
                break;

            case "with invalid start hour value":
                set("2025-12-18T30:00:00-03:00", "start", "$(var.testBody)");
                break;

            case "with invalid start date value":
                set("2025-15-18T07:00:00-03:00", "start", "$(var.testBody)");
                break;

            default:
                break;
        }
    }
}

