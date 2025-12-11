package ar.steps.steps;

import ar.services.FailAddProjectService;
import com.crowdar.core.PageSteps;
import io.cucumber.java.en.And;


public class MyStepdefs {

    @And("generate test body (.*)$")
        public void bodyError(String bodyRequest) {
            FailAddProjectService.generateTestBody(bodyRequest);
        }
    }


