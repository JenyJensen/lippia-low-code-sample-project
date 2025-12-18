package ar.services;

import com.crowdar.api.rest.APIManager;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.lippia.api.lowcode.steps.StepsInCommon;
import org.testng.Assert;

public class GetTimeEntriesService {
    public static void validateTimeEntriesUserId(String userId) {
        try {
            Object rawResponse = APIManager.getLastResponse().getResponse();

            String response;
            if (rawResponse instanceof String) {
                response = (String) rawResponse;
            } else {
                response = new ObjectMapper().writeValueAsString(rawResponse);
            }

            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response);

            for (JsonNode entry : root) {
                Assert.assertNotNull(entry.get("userId"), "userId not found in an entry");
                Assert.assertEquals(
                        entry.get("userId").asText(),
                        userId,
                        "Found time entry with different userId"
                );
            }

        } catch (Exception e) {
            Assert.fail("Error validating time entries userId: " + e.getMessage());
        }
    }
}
