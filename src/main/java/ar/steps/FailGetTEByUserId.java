package ar.steps;

import ar.services.getTEByUserIdService;
import io.cucumber.java.en.And;

public class FailGetTEByUserId {
    @And("generate an empty variable for the corresponding case")
    public void generateAnEmptyVariable() {
        getTEByUserIdService.generateingEmptyVariable();
    }
}
