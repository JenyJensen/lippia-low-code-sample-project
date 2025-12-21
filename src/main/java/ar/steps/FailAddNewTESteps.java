package ar.steps;

import ar.services.FailAddTEService;
import io.cucumber.java.en.And;


public class FailAddNewTESteps {

    @And("generate request body (.*)$")
        public void bodyError(String bodyRequest) {

        FailAddTEService.generateTestBody(bodyRequest);
        }
    }


