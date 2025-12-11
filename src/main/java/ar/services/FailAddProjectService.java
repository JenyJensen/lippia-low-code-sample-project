package ar.services;

import io.lippia.api.lowcode.variables.VariablesManager;
import static io.lippia.api.lowcode.JsonKeysProcessor.set;

public class FailAddProjectService {

    public static void generateTestBody(String bodyRequest) {
        String body = "jsons/bodies/bodyAddProject.json";
        if (bodyRequest.equals("without changes")) {
            VariablesManager.setVariable("testBody", body);
        } else if (bodyRequest.equals("no body in request")) {
            VariablesManager.setVariable("testBody", "");
        } else if (bodyRequest.equals("no project name in request")) {
            VariablesManager.setVariable("testBody", "jsons/bodies/bodyNoNameAddProj.json");
        } else if (bodyRequest.equals("null project name")) {
            VariablesManager.setVariable("testBody", "jsons/bodies/bodyNullNameAddProj.json");
        } else if (bodyRequest.equals("project name with less than two characters")) {
            VariablesManager.setVariable("testBody", "jsons/bodies/bodyOneCharNameAddProj.json");
        } else {
            VariablesManager.setVariable("testBody","jsons/bodies/bodyLongCharNameAddProj.json");
        }
    }
}
