/***
 -------------------------------------------------------------------------------
 |                                                                             |
 | NASA Glenn Research Center                                                  |
 | 21000 Brookpark Rd 		                                                     |
 | Cleveland, OH 44135 	                                                       |
 |                                                                             |
 | File Name:     PrintUtils.int                                               |
 | Author(s):     Jonathan Fuzaro Alencar                                      |
 | Date(s):       February 2020                                                |
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

// prints list of elements of certain type
void printElements(string type, int recursive) {
  string elements[] = list(type, recursive);

  int i;
  for (i = 0; i < elements.entries(); i++) {
    cout << i+1 << ".) " << elements[i] << ": " << elements[i]->isA() << endl;
  }
}

// prints solver independents and depedents
void printSolverSetup(string solverName, int recursive) {

  int i;
  string indeps[] = solverName->list("Independent", recursive);
  string deps[] = solverName->list("Dependent", recursive);

  cout << "==== " << solverName << " ====\n";

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
  cout << "==== CASE: " << solverName->CASE << " ====="
       << "\nIterations: " << solverName->iterationCounter
       << "\nPasses: " << solverName->passCounter
       << "\nJacobians: " << solverName->numJacobians
       << "\nBroydens: " << solverName->numBroydens
       << "\n==================\n";
}

void printDesignBanner(string des) {
  if (des == "on" || des == "ON") {
    cout << "=======================\n"
         << "====== On-Design ======\n"
         << "=======================\n\n";
  } else if (des == "off" || des == "OFF") {
    cout << "=======================\n"
         << "====== Off-Design =====\n"
         << "=======================\n\n";
  } else {
    cout << "[ERROR]: Not a valid design parameter.\n";
  }
}
