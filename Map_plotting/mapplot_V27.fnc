//
// NPSS function used for turbomachinery component map plotting
// a PYTHON script file, "mapplot.py", is also required 
//
// createMapDataFiles() - creates map data files, to be called after design point is run
// saveOpPoints() - creates OP points, to be called after an off design point is run,
// input should be a desired point name, final point should be saveOpPoints("DONE")


//-------------------------------------------------------------------------
// declare DATA streams and variables that reference the components
//-------------------------------------------------------------------------

OutFileStream COMPONENT_FILE { }    // list of turbomachinery components
OutFileStream DATA_MAP { }          // component map data stream

string COMPONENT_NAMES[];  // array of turbomachine components in the model
string map;                // reference to map subelement
string mapType;            // turbomachine map type - Rline or Turbine

int firstCall[];           // array to track the first time an op point is saved


void saveOpPoints( string info ) {

   int n;                  // index number for turbomachinery maps

   //-----------------------------------------------------------------------
   // for each component, write the operating point at the time this
   // function was called
   //-----------------------------------------------------------------------
   for ( n=0; n < COMPONENT_NAMES.entries(); ++n ) {

      // get the map name and map type again
      if ( ( COMPONENT_NAMES[n] + ".S_map" )->child.isA() == "CompressorRlineMap" ) {
         map = "parent." + COMPONENT_NAMES[n] + ".S_map";
         mapType = "RLINE";
      }
      else if ( ( COMPONENT_NAMES[n] + ".S_map" )->child.isA() == "TurbinePRmap3D" ) { 
         map = "parent." + COMPONENT_NAMES[n] + ".S_map";
         mapType = "TURBINEPR3D";
      }
      else if ( ( COMPONENT_NAMES[n] + ".S_map" )->child.isA() == "TurbinePRmap" ) { 
         map = "parent." + COMPONENT_NAMES[n] + ".S_map";
         mapType = "TURBINEPR";
      }
      else if ( ( COMPONENT_NAMES[n] + ".S_map" )->child.isA() == "MotorGeneratorMap" ) { 
         map = "parent." + COMPONENT_NAMES[n] + ".S_map";
         mapType = "MOTORGENERATOR";
      }
      else {
         cerr << "I don't have logic for this kind of map \n";
      }


      DATA_MAP.open( "Map_plotting/mapData" + COMPONENT_NAMES[n] + ".txt" );
      DATA_MAP.width = 0;

      if ( firstCall[n] == 1 ) {

         // OPTION to plot the operating point
         if ( exists( map+".PLOT_OP_POINTS" ) && ( map+".PLOT_OP_POINTS" )->value == 1 ) { 
            DATA_MAP << endl;
            DATA_MAP << "plot_op_points=1" << endl;
         }
         else {
            DATA_MAP << endl;
            DATA_MAP << "plot_op_points=0" << endl;
         }

         DATA_MAP << "op_points=[ \n";
         firstCall[n] = 0;
      } 


      // write the data based on map type
      if ( mapType == "RLINE" ) {
         DATA_MAP << "  [ \"" << info << "\", ";
         DATA_MAP << COMPONENT_NAMES[n]->Wc << ", ";
         DATA_MAP << COMPONENT_NAMES[n]->PR << ", ";
         DATA_MAP << COMPONENT_NAMES[n]->eff << ", ";
         DATA_MAP << " ], \n";
      }
      else if (( mapType == "TURBINEPR" ) || ( mapType == "TURBINEPR3D" )) {
         DATA_MAP << "  [ \"" << info << "\", ";
         DATA_MAP << COMPONENT_NAMES[n]->Wp << ", ";
         DATA_MAP << COMPONENT_NAMES[n]->PR << ", ";
         DATA_MAP << COMPONENT_NAMES[n]->eff << ", ";
         DATA_MAP << " ], \n";
      }
      else if ( mapType == "MOTORGENERATOR" ) {
         DATA_MAP << "  [ \"" << info << "\", ";
         DATA_MAP << COMPONENT_NAMES[n]->S_map.trqMap << ", ";
         DATA_MAP << COMPONENT_NAMES[n]->S_map.Nmap << ", ";
         DATA_MAP << COMPONENT_NAMES[n]->S_map.effMap << ", ";
         DATA_MAP << " ], \n";
      }

      if ( info == "DONE" ) {
         DATA_MAP << "]" << endl;
      }

   }  // end component loop
}


void createMapDataFiles() {


   //-------------------------------------------------------------------------
   // declare variables that reference turbomachinery maps
   //-------------------------------------------------------------------------
   string Tbl_flow;           // reference to map subelement flow table
   string Tbl_PR;             // reference to map subelement PR table
   string Tbl_eff;            // reference to map subelement efficiency table
   string indepNames[];       // reference to flow table independents

   int n;                     // index number for turbomachinery maps
   int i,j,k;                 // indices for table looping

   real alphaVals[];          // array of map table alpha values
   real speedVals[];          // array of map table speed values
   real trqVals[];            // array of map table torque values
   real indexVals[];          // array of map table index (rline/PR) values
   real dataFlow, dataPR, dataEff;   // map dependent data values


   //-------------------------------------------------------------------------
   // create a list of all compressors and turbines in this model
   //-------------------------------------------------------------------------
   string COMPRESSOR_NAMES[] = list( "Compressor", TRUE ); 
   string TURBINE_NAMES[] = list( "Turbine", TRUE ); 
   string MOTOR_NAMES[] = list( "Motor", TRUE ); 
   string GENERATOR_NAMES[] = list( "Generator", TRUE ); 
   COMPONENT_NAMES = COMPRESSOR_NAMES;
   COMPONENT_NAMES.append( TURBINE_NAMES );
   COMPONENT_NAMES.append( MOTOR_NAMES );
   COMPONENT_NAMES.append( GENERATOR_NAMES );


   //-------------------------------------------------------------------------
   // write a list of all the components to a file as a PYTHON variable
   //-------------------------------------------------------------------------
   COMPONENT_FILE.filename = "Map_plotting/mapCompList.txt";
   COMPONENT_FILE << "component_list=[ ";

   for ( n=0; n < COMPONENT_NAMES.entries(); ++n ) {
      COMPONENT_FILE << "\"" << "Map_plotting/mapData" + COMPONENT_NAMES[n] + ".txt" << "\", ";
   } 

   COMPONENT_FILE << " ]";
   COMPONENT_FILE.close();



   //-------------------------------------------------------------------------
   // for each component, write its map data to a file in PYTHON format
   //-------------------------------------------------------------------------
   for ( n=0; n < COMPONENT_NAMES.entries(); ++n ) {
      //cout << "component name is " << COMPONENT_NAMES[n] << endl;
      firstCall.append( 1 );  // initialize this array

      // set the map data filename
      DATA_MAP.width = 0;
      DATA_MAP.filename = "Map_plotting/mapData" + COMPONENT_NAMES[n] + ".txt";
      DATA_MAP << "mapname = '" << COMPONENT_NAMES[n] << "'" << endl;

      // determine if the component map is a COMPRESSOR or TURBINE
      if ( ( COMPONENT_NAMES[n] + ".S_map" )->child.isA() == "CompressorRlineMap" ) {
         mapType = "RLINE";
         map = "parent." + COMPONENT_NAMES[n] + ".S_map";
         Tbl_flow = map + ".TB_Wc";
         Tbl_PR   = map + ".TB_PR";
         Tbl_eff  = map + ".TB_eff";
         indepNames = Tbl_flow->getIndependentNames(); 
      } 
      else if ( ( COMPONENT_NAMES[n] + ".S_map" )->child.isA() == "TurbinePRmap3D" ) { 
         mapType = "TURBINEPR3D";
         map = "parent." + COMPONENT_NAMES[n] + ".S_map";
         Tbl_flow = map + ".TB_Wp";
         Tbl_eff  = map + ".TB_eff";
         indepNames = Tbl_flow->getIndependentNames(); 
      }
      else if ( ( COMPONENT_NAMES[n] + ".S_map" )->child.isA() == "TurbinePRmap" ) { 
         mapType = "TURBINEPR";
         map = "parent." + COMPONENT_NAMES[n] + ".S_map";
         Tbl_flow = map + ".TB_Wp";
         Tbl_eff  = map + ".TB_eff";
         indepNames = Tbl_flow->getIndependentNames(); 
      }
      else if ( ( COMPONENT_NAMES[n] + ".S_map" )->child.isA() == "MotorGeneratorMap" ) { 
         mapType = "MOTORGENERATOR";
         map = "parent." + COMPONENT_NAMES[n] + ".S_map";
         Tbl_eff  = map + ".TB_eff";
         indepNames = Tbl_eff->getIndependentNames(); 
      }
      else {
         cerr << "I don't have logic for this kind of map.\n";
         quit();
      } 


      // write the map type and dependent variable headers to the file
      DATA_MAP << "maptype = '" << mapType << "'" << endl << endl;

      if ( ( mapType == "RLINE" ) ||
           ( mapType == "TURBINEPR3D" ) ||
           ( mapType == "TURBINEPR" ) )  {
         DATA_MAP << "#  alpha " << endl;
         DATA_MAP << "#    speed " << endl;
         DATA_MAP << "#       index (R-line or PR)" << endl;
         DATA_MAP << "#       Wc " << endl;
         DATA_MAP << "#       PR " << endl;
         DATA_MAP << "#       eff " << endl;
      }
      else if ( ( mapType == "MOTORGENERATOR" ) )  {
         DATA_MAP << "#  torque " << endl;
         DATA_MAP << "#    speed " << endl;
         DATA_MAP << "#       eff " << endl;
      }


      //----------------------------------------------------------------------
      // write the data to the file in nested loops of i, j, and k
      //----------------------------------------------------------------------
      DATA_MAP.showpoint = TRUE;
      DATA_MAP.precision = 6;

      DATA_MAP << "mapdata=["; DATA_MAP << endl;

      // This block handles a motor or generator map
      if ( mapType == "MOTORGENERATOR" ) {

         DATA_MAP << "[0.0," << endl << "[ " << endl; // first alpha always zero

         trqVals = Tbl_eff->getValues( indepNames[0] );
	     
         // for each torque value in the map
         for ( j=0; j < trqVals.entries(); ++j ) {
            DATA_MAP << "[ " << trqVals[j] << "," << endl << "[ ";
            speedVals = Tbl_eff->getValues( indepNames[1], trqVals[j] );
            // use the indexes associated with the second speed value for non-square data
            if ( exists( map+".NON_SQUARE" ) ) {  
               speedVals = Tbl_eff->getValues( indepNames[1], trqVals[1] );
            }
	     
            // for each speed value in the map write the eff
            for ( k=0; k < speedVals.entries(); ++k ) {
               DATA_MAP << speedVals[k] << ",";
            } 
            DATA_MAP << "]," << endl;
	     
            // eff
            DATA_MAP << "[ ";
            for ( k=0; k < speedVals.entries(); ++k ) {
               dataEff = Tbl_eff->eval( trqVals[j], speedVals[k] );
               DATA_MAP << dataEff << ",";
            } 
            DATA_MAP << "]," << endl;
	     
	     
            DATA_MAP << "], " << endl;
         }
         DATA_MAP << "], " << endl;
         DATA_MAP << "], " << endl;
         DATA_MAP << "] " << endl;
	  }
      // This block handles a 2D turbine-PR map
      else if ( mapType == "TURBINEPR" ) {
         alphaVals = {0.0};
         // for each alpha value in the map
         for ( i=0; i < alphaVals.entries(); ++i ) {
            DATA_MAP << "[" << alphaVals[i] << "," << endl << "[ " << endl;
            speedVals = Tbl_flow->getValues( indepNames[0] );
	     
            // for each speed value in the map
            for ( j=0; j < speedVals.entries(); ++j ) {
               DATA_MAP << "[ " << speedVals[j] << "," << endl << "[ ";
               indexVals = Tbl_flow->getValues( indepNames[1], speedVals[j] );
               // use the indexes associated with the second speed value for non-square data
               if ( exists( map+".NON_SQUARE" ) ) {  
                  indexVals = Tbl_flow->getValues( indepNames[1], speedVals[1] );
               }
	     
               // for each index value in the map write the index, flow, PR, and eff
               for ( k=0; k < indexVals.entries(); ++k ) {
                  DATA_MAP << indexVals[k] << ",";
               } 
               DATA_MAP << "]," << endl;
	     
               // flow
               DATA_MAP << "[ ";
               for ( k=0; k < indexVals.entries(); ++k ) {
                  dataFlow = Tbl_flow->eval( speedVals[j], indexVals[k] );
                  DATA_MAP << dataFlow << ",";
               } 
               DATA_MAP << "]," << endl;
	     
               // pressure ratio
               DATA_MAP << "[ ";
               for ( k=0; k < indexVals.entries(); ++k ) {
                  if (( mapType == "TURBINEPR" ) || ( mapType == "TURBINEPR3D" )) {
                     dataPR = indexVals[k];
                  }
				  else {
                     dataPR = Tbl_PR->eval( speedVals[j], indexVals[k] );
				  }
                  DATA_MAP << dataPR << ",";
               } 
               DATA_MAP << "]," << endl;
	     
               // adiabatic efficiency
               DATA_MAP << "[ ";
               for ( k=0; k < indexVals.entries(); ++k ) {
                  dataEff = Tbl_eff->eval( speedVals[j], indexVals[k] );
                  DATA_MAP << dataEff << ",";
               } 
               DATA_MAP << "], " << endl;
	     
               DATA_MAP << "], " << endl;
            }
            DATA_MAP << "], " << endl;
            DATA_MAP << "], " << endl;
	     
         }  // end map data for loop
         DATA_MAP << "] " << endl;
	  }
	  // Otherwise, we're doing a 3D map (turbine or compressor)
	  else {
         alphaVals = Tbl_flow->getValues( indepNames[0] );
		 
         // for each alpha value in the map
         for ( i=0; i < alphaVals.entries(); ++i ) {
            DATA_MAP << "[" << alphaVals[i] << "," << endl << "[ " << endl;
            speedVals = Tbl_flow->getValues( indepNames[1], alphaVals[i] );
	     
            // for each speed value in the map
            for ( j=0; j < speedVals.entries(); ++j ) {
               DATA_MAP << "[ " << speedVals[j] << "," << endl << "[ ";
               indexVals = Tbl_flow->getValues( indepNames[2], alphaVals[i], speedVals[j] );
               // use the indexes associated with the second speed value for non-square data
               if ( exists( map+".NON_SQUARE" ) ) {  
                  indexVals = Tbl_flow->getValues( indepNames[2], alphaVals[i], speedVals[1] );
               }
	     
               // for each index value in the map write the index, flow, PR, and eff
               for ( k=0; k < indexVals.entries(); ++k ) {
                  DATA_MAP << indexVals[k] << ",";
               } 
               DATA_MAP << "]," << endl;
	     
               // flow
               DATA_MAP << "[ ";
               for ( k=0; k < indexVals.entries(); ++k ) {
                  dataFlow = Tbl_flow->eval( alphaVals[i], speedVals[j], indexVals[k] );
                  DATA_MAP << dataFlow << ",";
               } 
               DATA_MAP << "]," << endl;
	     
               // pressure ratio
               DATA_MAP << "[ ";
               for ( k=0; k < indexVals.entries(); ++k ) {
                  if (( mapType == "TURBINEPR" ) || ( mapType == "TURBINEPR3D" )) {
                     dataPR = indexVals[k];
                  }
				  else {
                     dataPR = Tbl_PR->eval( alphaVals[i], speedVals[j], indexVals[k] );
				  }
                  DATA_MAP << dataPR << ",";
               } 
               DATA_MAP << "]," << endl;
	     
               // adiabatic efficiency
               DATA_MAP << "[ ";
               for ( k=0; k < indexVals.entries(); ++k ) {
                  dataEff = Tbl_eff->eval( alphaVals[i], speedVals[j], indexVals[k] );
                  DATA_MAP << dataEff << ",";
               } 
               DATA_MAP << "], " << endl;
	     
               DATA_MAP << "], " << endl;
            }
            DATA_MAP << "], " << endl;
            DATA_MAP << "], " << endl;
	     
         }  // end map data for loop
         DATA_MAP << "] " << endl;
	  }



      //-----------------------------------------------------------------------
      // for each component, write the map plotting options to the file
      //-----------------------------------------------------------------------
      DATA_MAP << endl;
      DATA_MAP << "# map plotting options " << endl;

      real user_array[];        // used for specific axes or contour levels
      int count;                // the number of user input values 

      // OPTION for scaled maps, write the map scalars regardless
      if ( exists( map+".SCALED_MAP" ) && ( map+".SCALED_MAP" )->value == 0 ) { 
         DATA_MAP << "scaled_map=0" << endl;
      } 
      else { 
         DATA_MAP << "scaled_map=1" << endl;
      }
      if (( mapType == "RLINE" ) || ( mapType == "TURBINEPR" ) || ( mapType == "TURBINEPR3D" )) {
         DATA_MAP << "scalars=[ ";
         DATA_MAP.width=7; 
         if ( mapType == "RLINE" ) { DATA_MAP << map->s_WcDes; }
         if (( mapType == "TURBINEPR" ) || ( mapType == "TURBINEPR3D" )) { DATA_MAP << map->s_WpDes; }
         DATA_MAP.width=2; DATA_MAP << ", ";
         DATA_MAP.width=7; DATA_MAP << map->s_PRdes;
         DATA_MAP.width=2; DATA_MAP << ", ";
         DATA_MAP.width=7; DATA_MAP << map->s_effDes;
         DATA_MAP.width=2; DATA_MAP << ", ";
         DATA_MAP.width=7; DATA_MAP << "1.00000";      //map->s_NcDes;
         DATA_MAP.width=2; DATA_MAP << " ]";
         DATA_MAP << endl;
	  }
	  else if ( mapType == "MOTORGENERATOR" ) {
         DATA_MAP << "scalars=[ ";
         DATA_MAP.width=7; DATA_MAP << map->s_trqDes;
         DATA_MAP.width=2; DATA_MAP << ", ";
         DATA_MAP.width=7; DATA_MAP << map->s_Ndes;
         DATA_MAP.width=2; DATA_MAP << ", ";
         DATA_MAP.width=7; DATA_MAP << map->s_effDes;
         DATA_MAP.width=2; DATA_MAP << ", ";
         DATA_MAP.width=7; DATA_MAP << "1.00000";      //map->s_NcDes;
         DATA_MAP.width=2; DATA_MAP << " ]";
         DATA_MAP << endl;
      }

      // OPTION for multiple alpha plots      
      if ( exists( map+".MULTIPLE_ALPHAS" ) && ( map+".MULTIPLE_ALPHAS" )->value == 1 ) { 
         DATA_MAP << "multiple_alphas=1" << endl;
      } 
      else { 
         DATA_MAP << "multiple_alphas=0" << endl;
      }


      // OPTION to overlay plots of multiple alphas
      if ( exists( map+".OVERLAY" ) && ( map+".OVERLAY" )->value == 1 ) { 
         DATA_MAP << "overlay=1" << endl;
      } 
      else {
         DATA_MAP << "overlay=0" << endl;
      }


      // OPTION for showing lines of constant Beta or Rline value
      if ( exists( map+".SHOW_LINES" ) && ( map+".SHOW_LINES" )->value == 0 ) { 
         DATA_MAP << "show_lines=0" << endl;
      } 
      else { 
         DATA_MAP << "show_lines=1" << endl;
      }


      // OPTION to add label values to the index contours
      if ( exists( map+".INDEX_LABELS" ) && ( map+".INDEX_LABELS" )->value == 1 ) { 
         DATA_MAP << "index_labels=1" << endl;
      }
      else {
         DATA_MAP << "index_labels=0" << endl;
      }

/*
      // OPTION to specify index contour levels
      if ( exists( map+".CONTOUR_IND" ) && ( map+".CONTOUR_IND" )->entries() > 2 ) { 
         user_array = ( map+".CONTOUR_IND" )->value;
         DATA_MAP << "Vindex=[ ";
         for ( count=0; count < user_array.entries()-1; ++count ) {
            DATA_MAP << user_array[count] << ", ";
         } 
         DATA_MAP << user_array[count] << " ]" << endl;
      } 


      // OPTION to specify speed contour levels
      if ( exists( map+".CONTOUR_SPD" ) && ( map+".CONTOUR_SPD" )->entries() > 2 ) { 
         user_array = ( map+".CONTOUR_SPD" )->value;
         DATA_MAP << "Vspd=[ ";
         for ( count=0; count < user_array.entries()-1; ++count ) {
            DATA_MAP << user_array[count] << ", ";
         } 
         DATA_MAP << user_array[count] << " ]" << endl;
      } 
*/

      // OPTION to specify efficiency contour values
      if ( exists( map+".CONTOUR_EFF" ) && ( map+".CONTOUR_EFF" )->entries() > 2 ) { 
         user_array = ( map+".CONTOUR_EFF" )->value;
         DATA_MAP << "Veff=[ ";
         for ( count=0; count < user_array.entries()-1; ++count ) {
            DATA_MAP << user_array[count] << ", ";
         } 
         DATA_MAP << user_array[count] << " ]" << endl;
      } 
      else { 
         DATA_MAP << "Veff=[ 0.00,0.20,0.40,0.60,0.70,0.80,0.85,0.90,0.92,0.94,0.96,0.98 ]" << endl;
      }


      // OPTION to specify plot boundaries
      if ( exists( map+".AXES" )  && ( map+".AXES" )->entries() == 4 ) { 
         user_array = ( map+".AXES" )->value;
         DATA_MAP << "axes=[ ";
         for ( count=0; count < user_array.entries()-1; ++count ) {
            DATA_MAP << user_array[count] << ", ";
         } 
         DATA_MAP << user_array[count] << " ]" << endl;
      } 


      // close the file
      DATA_MAP.close();
      

   }  // end component iteration loop

   // allow the operating point data to be appended to each map file
   DATA_MAP.append = TRUE;

}

