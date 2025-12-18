package ar.steps;

import ar.services.AddNewTimeEntryService;
import io.cucumber.java.en.And;

public class AddNewTimeEntrySteps {
    @And("se crea una descripcion random para el time entry")
    public void createRandomDescriptionForTimeEntry(){
        AddNewTimeEntryService.createRandomDescription();
    }
}
