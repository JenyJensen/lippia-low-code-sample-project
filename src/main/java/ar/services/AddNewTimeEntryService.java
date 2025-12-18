package ar.services;

import io.lippia.api.lowcode.variables.VariablesManager;

public class AddNewTimeEntryService {

    public static void createRandomDescription() {
        long intentos = Math.round(Math.random()*2000);
        String randomDescription = "Intento numero " + intentos + " de completar el trabajo";
        VariablesManager.setVariable("variableDescription", randomDescription);
    }
}
