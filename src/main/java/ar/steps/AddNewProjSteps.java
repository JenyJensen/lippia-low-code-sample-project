package ar.steps;

import ar.services.AddNewProjService;
import io.cucumber.java.en.And;

public class AddNewProjSteps {
    @And("a variable name is generated and stored in a variable")
    public void generatingVariableNameAndStored() {
        AddNewProjService.generatingVariableProjectName();
    }
}
