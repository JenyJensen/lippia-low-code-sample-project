package ar.steps;

import ar.services.GetTimeEntriesService;
import io.cucumber.java.en.And;
import io.lippia.api.lowcode.steps.StepsInCommon;

public class GetTimeEntriesSteps {
    @And("validate all time entries belong to same user (.*)")
    public void validateAllTimeEntriesByUserId(String userId) {
       GetTimeEntriesService.validateTimeEntriesUserId(userId);
    }
}
