package ar.services;

import io.lippia.api.lowcode.variables.VariablesManager;

import static io.lippia.api.lowcode.JsonKeysProcessor.delete;
import static io.lippia.api.lowcode.JsonKeysProcessor.set;

public class FailUpdateTEService {
    public static void createUpdateRequestBody(String updateBody) {
        String base = "jsons/bodies/bodyFailUpdateTE.json";

        if (updateBody.equals("no body in request")) {
            VariablesManager.setVariable("updateRequestBody", "");
            return;
        }

        VariablesManager.setVariable("updateRequestBody", base);

        switch (updateBody) {

            case "without start key":
                delete("start", "$(var.updateRequestBody)");
                break;

            case "with null start value":
                VariablesManager.setVariable("updateRequestBody","jsons/bodies/bodyTENullStart.json");
                break;

            case "without start hour":
                set("2025-12-18T", "start", "$(var.updateRequestBody)");
                break;

            case "without start date":
                set("T07:00:00-03:00", "start", "$(var.updateRequestBody)");
                break;

            case "with invalid start hour value":
                set("2025-12-18T30:00:00-03:00", "start", "$(var.updateRequestBody)");
                break;

            case "with invalid start date value":
                set("2025-15-18T07:00:00-03:00", "start", "$(var.updateRequestBody)");
                break;

            default:
                break;
        }
    }
}
