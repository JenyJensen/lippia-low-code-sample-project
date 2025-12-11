package ar.services;

import io.lippia.api.lowcode.variables.VariablesManager;
import static io.lippia.api.lowcode.JsonKeysProcessor.set;
import static io.lippia.api.lowcode.JsonKeysProcessor.delete;


public class FailAddProjectService {

    public static void generateTestBody(String bodyRequest) {
        String base = "jsons/bodies/bodyAddProject.json";

        // Si no hay body
        if (bodyRequest.equals("no body in request")) {
            VariablesManager.setVariable("testBody", "");
            return;
        }

        // En todos los demás casos usamos el body base
        VariablesManager.setVariable("testBody", base);

        // Aplicamos transformaciones según el caso
        switch (bodyRequest) {

            case "no project name in request":
                delete("name", "$(var.testBody)");
                break;

            case "null project name":
                VariablesManager.setVariable("testBody", "jsons/bodies/bodyNullNameAddProj.json");
                break;

            case "project name with less than two characters":
                set("A", "name", "$(var.testBody)");
                break;

            case "project name with more than 250 characters":
                String largo = "diluir a 1:100.000 = 0.01 mg/ml (0.1 ml más 10 ml de SF).Administrar en 5-10 minutos.Pacientes en tratamiento con inhibidores de la monoaminooxidasa (bloquean el metabolismo de la adrenalina), antidepresivos tricíclicos (prolongan la vida media de la adrenalina), bloqueantes beta (respuesta parcial de la adrenalina), aminofilina, salbutamol IV u otros fármacos vasoconstrictoresdiluir a 1:100.000 = 0.01 mg/ml (0.1 ml más 10 ml de SF).Administrar en 5-10 minutos.Pacientes en tratamiento con inhibidores de la monoaminooxidasa (bloquean el metabolismo de la adrenalina), antidepresivos tricíclicos (prolongan la vida media de la adrenalina), bloqueantes beta (respuesta parcial de la adrenalina), aminofilina, salbutamol IV u otros fármacos vasoconstrictoresdiluir a 1:100.000 = 0.01 mg/ml (0.1 ml más 10 ml de SF).Administrar en 5-10 minutos.Pacientes en tratamiento con inhibidores de la monoaminooxidasa (bloquean el metabolismo de la adrenalina), antidepresivos tricíclicos (prolongan la vida media de la adrenalina), bloqueantes beta (respuesta parcial de la adrenalina), aminofilina, salbutamol IV u otros fármacos vasoconstrictoresdiluir a 1:100.000 = 0.01 mg/ml (0.1 ml más 10 ml de SF).Administrar en 5-10 minutos.Pacientes en tratamiento con inhibidores de la monoaminooxidasa (bloquean el metabolismo de la adrenalina), antidepresivos tricíclicos (prolongan la vida media de la adrenalina), bloqueantes beta (respuesta parcial de la adrenalina), aminofilina, salbutamol IV u otros fármacos vasoconstrictoresdiluir a 1:100.000 = 0.01 mg/ml (0.1 ml más 10 ml de SF).Administrar en 5-10 minutos.Pacientes en tratamiento con inhibidores de la monoaminooxidasa (bloquean el metabolismo de la adrenalina), antidepresivos tricíclicos (prolongan la vida media de la adrenalina), bloqueantes beta (respuesta parcial de la adrenalina), aminofilina, salbutamol IV u otros fármacos vasoconstrictoresyunosmascaracteres";
                set(largo, "name", "$(var.testBody)");
                break;

            default:
                break;
        }
    }
}

