package ar.steps;

import ar.services.GetTimeEntriesService;
import io.cucumber.java.en.And;

public class GetTimeEntriesSteps {
    @And("validate all time entries belong to same user")
    public void validateAllTimeEntriesByUserId() {
       GetTimeEntriesService.validateTimeEntriesUserId();
    }
}
