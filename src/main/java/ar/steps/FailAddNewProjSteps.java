package ar.steps;

import ar.services.FailAddProjService;
import io.cucumber.java.en.And;


public class FailAddNewProjSteps {

    @And("generate test body (.*)$")
        public void bodyError(String bodyRequest) {
            FailAddProjService.generateTestBody(bodyRequest);
        }
    }


