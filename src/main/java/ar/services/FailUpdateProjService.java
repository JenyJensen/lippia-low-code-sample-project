package ar.services;

import io.lippia.api.lowcode.variables.VariablesManager;

import static io.lippia.api.lowcode.JsonKeysProcessor.set;

public class FailUpdateProjService {
    public static void generatingUpdateTestBody(String updateBody) {
        String base = "{\n" +
                "  \"archived\": true,\n" +
                "  \"billable\": true,\n" +
                "  \"color\": \"#000000\",\n" +
                "  \"isPublic\": true,\n" +
                "  \"name\": \"Software Development\",\n" +
                "  \"note\": \"This is a sample note for the project.\"\n" +
                "}";

        if (updateBody.equals("no body in request")) {
            VariablesManager.setVariable("updateTestBody", "");
            return;
        }

        VariablesManager.setVariable("updateTestBody", base);

        switch (updateBody) {

            case "project name with less than two characters":
                set("A", "name", "$(var.updateTestBody)");
                break;

            case "project name with more than 250 characters":
                String largo = "diluir a 1:100.000 = 0.01 mg/ml (0.1 ml más 10 ml de SF).Administrar en 5-10 minutos.Pacientes en tratamiento con inhibidores de la monoaminooxidasa (bloquean el metabolismo de la adrenalina), antidepresivos tricíclicos (prolongan la vida media de la adrenalina), bloqueantes beta (respuesta parcial de la adrenalina), aminofilina, salbutamol IV u otros fármacos vasoconstrictoresdiluir a 1:100.000 = 0.01 mg/ml (0.1 ml más 10 ml de SF).Administrar en 5-10 minutos.Pacientes en tratamiento con inhibidores de la monoaminooxidasa (bloquean el metabolismo de la adrenalina), antidepresivos tricíclicos (prolongan la vida media de la adrenalina), bloqueantes beta (respuesta parcial de la adrenalina), aminofilina, salbutamol IV u otros fármacos vasoconstrictoresdiluir a 1:100.000 = 0.01 mg/ml (0.1 ml más 10 ml de SF).Administrar en 5-10 minutos.Pacientes en tratamiento con inhibidores de la monoaminooxidasa (bloquean el metabolismo de la adrenalina), antidepresivos tricíclicos (prolongan la vida media de la adrenalina), bloqueantes beta (respuesta parcial de la adrenalina), aminofilina, salbutamol IV u otros fármacos vasoconstrictoresdiluir a 1:100.000 = 0.01 mg/ml (0.1 ml más 10 ml de SF).Administrar en 5-10 minutos.Pacientes en tratamiento con inhibidores de la monoaminooxidasa (bloquean el metabolismo de la adrenalina), antidepresivos tricíclicos (prolongan la vida media de la adrenalina), bloqueantes beta (respuesta parcial de la adrenalina), aminofilina, salbutamol IV u otros fármacos vasoconstrictoresdiluir a 1:100.000 = 0.01 mg/ml (0.1 ml más 10 ml de SF).Administrar en 5-10 minutos.Pacientes en tratamiento con inhibidores de la monoaminooxidasa (bloquean el metabolismo de la adrenalina), antidepresivos tricíclicos (prolongan la vida media de la adrenalina), bloqueantes beta (respuesta parcial de la adrenalina), aminofilina, salbutamol IV u otros fármacos vasoconstrictoresyunosmascaracteres";
                set(largo, "name", "$(var.updateTestBody)");
                break;

            default:
                break;
        }
    }
}

