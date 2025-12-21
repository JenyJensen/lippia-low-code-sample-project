package ar.services;

import io.lippia.api.lowcode.variables.VariablesManager;
import org.mozilla.javascript.ast.StringLiteral;

public class getTEByUserIdService {
    public static void generateingEmptyVariable() {
        String empty = null;
        VariablesManager.setVariable("emptyVariable", empty);
    }
}
