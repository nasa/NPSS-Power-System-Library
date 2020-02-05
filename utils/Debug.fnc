/***
 -------------------------------------------------------------------------------
 |                                                                             |
 | File Name:     Debug.fnc                                                    |
 | Author(s):     Jonathan Fuzaro Alencar                                      |
 | Date(s):       February 2020                                                |
 |                                                                             |
 | Description:   "Debug" file containing useful functions.                    |
 |                                                                             |
 -------------------------------------------------------------------------------
***/

// prints an array as an enumerated list
void printList(string list[]) {
    int i;
    for (i = 0; i < list.entries(); i++) {
        cout << " " << i+1 << ".) " << list[i] << endl;
    }
}

// prints solver independents, dependents, and sequence
void printSolverSetup(string solverName, int recursive) {

    int i;
    string indeps[] = solverName->list("Independent", recursive);
    string deps[] = solverName->list("Dependent", recursive);

    cout << "\nIndependent Components: \n";
    for (i = 0; i < indeps.entries(); i++) {
        cout << " " << i+1 << ".) " << indeps[i] << ": " << indeps[i]->varName << endl;
    }

    cout << "\nDependent Components: \n";
    for (i = 0; i < deps.entries(); i++) {
        cout << " " << i+1 << ".) " << deps[i] << ": " << deps[i]->eq_lhs << " = " << deps[i]->eq_rhs << endl;
    }

    // cout << "\nSequence: \n";
    // printList(solverName->solverSequence);
    cout << endl;
}

// prints information from a solver case run
void printCaseStats(string solverName) {
    cout << "==== CASE: " << solverName->CASE << " =====\n"
    << "Iterations: " << solverName->iterationCounter << endl
    << "Passes: " << solverName->passCounter << endl
    << "Jacobians: " << solverName->numJacobians << endl
    << "Broydens: " << solverName->numBroydens << endl
    << "==================\n\n";
}
