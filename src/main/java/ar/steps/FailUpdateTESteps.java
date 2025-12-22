package ar.steps;

import ar.services.FailUpdateTEService;
import io.cucumber.java.en.And;

public class FailUpdateTESteps {
    @And("generate update request body (.*)")
    public void generateUpdateRequestBody(String updateBody) {
        FailUpdateTEService.createUpdateRequestBody(updateBody);
    }
}
