package ar.services;

import io.lippia.api.lowcode.variables.VariablesManager;

public class AddNewProjService {
    public static void generatingVariableProjectName(){
        String randomName = "AddNewProj" + String.valueOf(Math.random()*10);
        VariablesManager.setVariable("variableProjName", randomName);
    }
}
