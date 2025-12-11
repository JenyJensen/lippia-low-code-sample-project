package ar.steps;

import ar.services.FailUpdateProjService;
import cucumber.api.PendingException;
import io.cucumber.java.en.And;

public class FailUpdateProjSteps {
    @And("generate update test body (.*)$")
    public void generateUpdateBody(String updateBody) {
       FailUpdateProjService.generatingUpdateTestBody(updateBody);
    }
}
