/***
 -------------------------------------------------------------------------------
 |                                                                             |
 | NASA Glenn Research Center                                                  |
 | 21000 Brookpark Rd 		                                                     |
 | Cleveland, OH 44135 	                                                       |
 |                                                                             |
 | File Name:     IOUtils.int                                                  |
 | Author(s):     Jonathan Fuzaro Alencar                                      |
 | Date(s):       February 2020                                                |
 |                                                                             |
 -------------------------------------------------------------------------------
***/

#ifndef __IO_UTILS__
#define __IO_UTILS__

// Prints an array as an enumerated list.
void printList(string list[]) {
  int i;
  for (i = 0; i < list.entries(); i++) {
    cout << " " << i+1 << ".) " << list[i] << endl;
  }
}

// Prints an array as an enumerated list with values.
void printValues(string list[]) {
  int i;
  for (i = 0; i < list.entries(); i++) {
    cout << " " << i+1 << ".) " << list[i] << " = " << list[i]->value << endl;
  }
}

// Prints enumerated list of elements of certain type.
void printElements(string type, int recursive) {
  string elements[] = list(type, recursive);

  int i;
  for (i = 0; i < elements.entries(); i++) {
    cout << i+1 << ".) " << elements[i] << ": " << elements[i]->isA() << endl;
  }
}

// Prints enumerated list of elements of certain type with values.
void printElementValues(string type, int recursive) {
  string elements[] = list(type, recursive);

  int i;
  for (i = 0; i < elements.entries(); i++) {
    cout << i+1 << ".) " << elements[i] << ": " << elements[i]->isA()
         << " = " << list[i]->value << endl;
  }
}

// Prints solver independents and depedents.
void printSolverSetup(string solverName, int recursive) {

  int i;
  string indeps[] = solverName->list("Independent", recursive);
  string deps[] = solverName->list("Dependent", recursive);

  cout << "==== " << solverName << " ====\n";

  cout << "\n Independent Components: \n";
  for (i = 0; i < indeps.entries(); i++) {
    cout << "  " << i+1 << ".) " << indeps[i] << ": " << indeps[i]->varName << endl;
  }

  cout << "\n Dependent Components: \n";
  for (i = 0; i < deps.entries(); i++) {
    cout << "  " << i+1 << ".) " << deps[i] << ": " << deps[i]->eq_lhs
         << " = " << deps[i]->eq_rhs << endl;
  }

  // cout << "\nSequence: \n";
  // printList(solverName->solverSequence);
  cout << endl;
}

// Prints information from a solver case run.
void printCaseStats(string solverName) {
  cout << "===== CASE: " << solverName->CASE << " ====="
       << "\nIterations: " << solverName->iterationCounter
       << "\nPasses: " << solverName->passCounter
       << "\nJacobians: " << solverName->numJacobians
       << "\nBroydens: " << solverName->numBroydens
       << "\nConverged?: " << solverName->converged
       << "\n===================\n\n";
}

// Prints on / off design banner.
void printDesignBanner(string des) {
  if (des == "on" || des == "ON") {
    cout << "\n=======================\n"
         <<   "====== On-Design ======\n"
         <<   "=======================\n\n";
  } else if (des == "off" || des == "OFF") {
    cout << "\n=======================\n"
         <<   "====== Off-Design =====\n"
         <<   "=======================\n\n";
  } else {
    cout << "[ERROR]: Not a valid design parameter.\n";
  }
}

// Prints enumerated list of electrical ports and their respective power type.
void printPortPowerTypes() {

  string ports[] = list("ElectricPort", TRUE);

  int i;
  for (i = 0; i < ports.entries(); i++) {
    cout << i+1 << ".) " << ports[i] << ": " << ports[i]->ElectricPowerType << endl;
  }
}

// Opens new CSV file stream with fileName and prints variables list at top.
void populateCSV(string file, string fileName, string vars[]) {

  int i;

  file->open(fileName);

  if (vars.entries() != 0) {
    file->print("CASE, ");
    for (i = 0; i < vars.entries()-1; i++) {
      file->print(vars[i]->getPathName() + ", ");
    }
    file->print(vars[i]->getPathName());
    file->println();
  } else {
    cerr << "[ERROR]: populateCSV variable list empty!\n";
  }
}

// Prints to file stream a line of values derived from variables (vars) array.
void fillCSVLine(string file, string vars[]) {

  int i;

  if (file->fileExists(file->filename)) {
    if (vars.entries() != 0) {
      file->print(toStr(CASE) + ", ");
      for (i = 0; i < vars.entries()-1; i++) {
        file->print(toStr(vars[i]->value) + ", ");
      }
      file->print(vars[i]->value);
      file->println();
    } else {
      cerr << "[ERROR]: fillCSVLine variable list empty!\n";
    }
  } else {
    cerr << "[ERROR]: fillCSVLine file does not exist!\n";
  }
}

#endif