package ar.steps;

import ar.services.AddNewTimeEntryService;
import io.cucumber.java.en.And;

public class AddNewTimeEntrySteps {
    @And("a random description is generated and stored in a variable")
    public void createRandomDescriptionForTimeEntry(){
        AddNewTimeEntryService.createRandomDescription();
    }
}
