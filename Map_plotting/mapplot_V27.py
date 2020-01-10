#
# =============================================================================
#               TEST PYTHON SCRIPT FOR PLOTTING NPSS V2.7 maps
# =============================================================================

import pylab
import numpy
import scipy
import matplotlib

# http://w3schools.com/html/html_colornames.asp


linecolors = [ 'red', 'green', 'blue', 'orange', 'magenta', 'cyan',
   'saddlebrown', 'skyblue', 'olivedrab', 'yellowgreen', 'black' ]

'''
cdict = {'red': ( (0.0, 0.0, 0.0),
                  (0.9, 0.5, 0.5),
                  (1.0, 1.0, 1.0) ),
        'green':( (0.0, 0.0, 0.0),
                  (0.9, 0.5, 0.5),
                  (1.0, 1.0, 1.0) ),
         'blue':( (0.0, 0.0, 0.0),
                  (0.5, 0.5, 0.5),
                  (1.0, 1.0, 1.0) ) }

my_cmap = matplotlib.colors.LinearSegmentedColormap('my_colormap',cdict,256)
'''

# execfile("Map_plotting/mapCompList.txt")
exec(open("Map_plotting/mapCompList.txt").read())




# map options:
#    plot scaled or unscaled map
#    input values for axes range
#    input values for efficiency contour levels
#    show contours for the index variable (R-line/PR)

def plot_submap():

   WC=[]
   PR=[]
   EFF=[]
   NC=[]
   INDEX=[]


   s_Wc = 1.0000
   s_PR = 1.0000
   s_Eff= 1.0000

   if scaled_map == 1:
      s_Wc = scalars[0]
      s_PR = scalars[1]
      s_Eff = scalars[2]


   Vspd=[]
   Vindex=[]
   #Veff =[]
   #Veff = [ 0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.85, 0.90, 0.92, 0.94, 0.95 ]


   for spd in submap[1]:
      x=[]
      y=[]
      z=[]
      w=[]

      for entry in spd[2]:
         x.append( entry*s_Wc )
         w.append( spd[0] )
      for entry in spd[3]:
         y.append( (entry-1.)*s_PR + 1. )
      for entry in spd[4]:
         z.append( entry*s_Eff )

      WC.append( x )
      PR.append( y )
      EFF.append( z )
      NC.append( w )
      INDEX.append( spd[1] )


      # set speed and index contour levels
      Vspd.append( spd[0] )
      Vindex = spd[1]


   WC = numpy.array( WC )
   PR = numpy.array( PR )
   EFF = numpy.array( EFF )
   NC = numpy.array( NC )
   INDEX = numpy.array( INDEX )


   # explicitly set the axes if the user set them
   if axes != []:
      pylab.axis( axes )


   # plot efficiency contours
   if overlay != 1:
      pylab.contourf( WC, PR, EFF, Veff )
      #pylab.contourf( WC, PR, EFF, Veff, cmap=pylab.cm.spectral )
      #pylab.contourf( WC, PR, EFF, Veff, colors=linecolors )
      pylab.colorbar( ticks=Veff )


   # plot speed lines, adjust the first and last contour values slightly
   Vspd[0] = Vspd[0]*1.0001
   Vspd[-1] = Vspd[-1]*0.9999
   if overlay != 1:
      CS = pylab.contour( WC, PR, NC, Vspd, colors='black' )
   else:
      CS = pylab.contour( WC, PR, NC, Vspd, colors=linecolors[mapColor] )

   if  Vspd[1] > 2.:
      pylab.clabel( CS, inline=1, fontsize=10, fmt = '%3.0f' )
   else:
      pylab.clabel( CS, inline=1, fontsize=10, fmt = '%3.3f' )


   # plot index lines (R-line or PR)
   Vindex[0]  = Vindex[0]*1.0001
   Vindex[-1] = Vindex[-1]*0.9999
   if show_lines != 0:
      if overlay != 1:
         CS = pylab.contour( WC, PR, INDEX, Vindex, colors='green' )
      else:
         CS = pylab.contour( WC, PR, INDEX, Vindex, colors=linecolors[mapColor] )
      if index_labels == 1:
         pylab.clabel( CS, inline=1, fontsize=10, fmt = '%2.2f' )


   # plot operating points
   if plot_op_points == 1:
      for pnt in op_points:
         if scaled_map == 1:
            plot_x = pnt[1]
            plot_y = pnt[2]
         else:
            plot_x = pnt[1]/scalars[0]
            plot_y = (pnt[2]-1.)/scalars[1] + 1.

         pylab.plot( plot_x, plot_y, color='black', marker='o', markersize=8. )


   # add text, axis labels, and a title to the plot
   axesMinMax=pylab.axis()
   xMin = axesMinMax[0]
   xMax = axesMinMax[1]
   yMin = axesMinMax[2]
   yMax = axesMinMax[3]

   xloc = xMin + ( xMax - xMin )*0.20
   yloc = yMin + ( yMax - yMin )*0.90
   if scaled_map == 0:
      pylab.text( xloc, yloc, 'UNSCALED MAP', color='blue' )

   pylab.xlabel('corrected flow, lbm/s')
   pylab.ylabel('pressure ratio')

   if overlay == 0:
      pylab.title( mapname + ' map characteristics, alpha = ' + str(submap[0]) )
   else:
      pylab.title( mapname + ' map characteristics' )
      xloc = xMin + ( xMax - xMin )*0.10
      yloc = yMin + ( yMax - yMin )*(mapColor/10. + 0.5 )
      pylab.text( xloc, yloc, 'ALPHA = '+str(submap[0]), color=linecolors[mapColor] )



   pylab.minorticks_on()
   pylab.grid()


def plot_motorgenerator_submap():

   TRQ=[]
   SPD=[]
   EFF=[]
   NC=[]
   INDEX=[]


   s_trq = 1.0000
   s_N = 1.0000
   s_Eff= 1.0000

   if scaled_map == 1:
      s_trq = scalars[0]
      s_N = scalars[1]
      s_Eff = scalars[2]


   Vtrq=[]
   Vindex=[]
   #Veff =[]
   #Veff = [ 0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.85, 0.90, 0.92, 0.94, 0.95 ]


   for trq in submap[1]:
      w=[]
      x=[]
      y=[]

      w.append( trq[0]*s_trq )
      for entry in trq[1]:
         x.append( entry*s_N )
      for entry in trq[2]:
         y.append( entry*s_Eff )
	 
	 
      #print(w)
      #print(x)
      #print(y)

      TRQ.append( w )
      #SPD.append( x )
      SPD = x
      EFF.append( y )
      INDEX.append( trq[1] )


   TRQ = numpy.array( TRQ )
   SPD = numpy.array( SPD )
   EFF = numpy.array( EFF )
   effSize = numpy.shape(EFF);
   #print(effSize)
   #print(effSize[0])
   #print(effSize[1])
   TRQ = numpy.tile( TRQ, effSize[1] )
   SPD = numpy.tile( SPD, (effSize[0],1 ) )
   #TRQSize = numpy.shape(TRQ);
   #print(TRQSize)
   #SPDSize = numpy.shape(SPD);
   #print(SPDSize)
   #NC = numpy.array( NC )
   #INDEX = numpy.array( INDEX )

	 
   #print(TRQ)
   #print(SPD)
   #print(EFF)
   #print(NC)
   #print(INDEX)
   print('plot_op_points stuff')
   print(plot_op_points)
   print(op_points)
	  

   # explicitly set the axes if the user set them
   if axes != []:
      pylab.axis( axes )


   # plot efficiency contours
   if overlay != 1:
      pylab.contourf( TRQ, SPD, EFF )
      pylab.colorbar()
      #pylab.contourf( TRQ, SPD, EFF, Veff, cmap=pylab.cm.spectral )
      #pylab.contourf( TRQ, SPD, EFF, Veff, colors=linecolors )
      #pylab.colorbar( ticks=Veff )

   # plot operating points
   if plot_op_points == 1:
      for pnt in op_points:
         if scaled_map == 1:
            plot_x = pnt[1]
            plot_y = pnt[2]
         else:
            plot_x = pnt[1]/scalars[0]
            plot_y = (pnt[2]-1.)/scalars[1] + 1.

         pylab.plot( plot_x, plot_y, color='black', marker='o', markersize=8. )


   # add text, axis labels, and a title to the plot
   axesMinMax=pylab.axis()
   xMin = axesMinMax[0]
   xMax = axesMinMax[1]
   yMin = axesMinMax[2]
   yMax = axesMinMax[3]

   xloc = xMin + ( xMax - xMin )*0.20
   yloc = yMin + ( yMax - yMin )*0.90
   if scaled_map == 0:
      pylab.text( xloc, yloc, 'UNSCALED MAP', color='blue' )

   pylab.xlabel('machine torque, per-unit')
   pylab.ylabel('machine speed, per-unit')

   if overlay == 0:
      pylab.title( mapname + ' map characteristics, alpha = ' + str(submap[0]) )
   else:
      pylab.title( mapname + ' map characteristics' )
      xloc = xMin + ( xMax - xMin )*0.10
      yloc = yMin + ( yMax - yMin )*(mapColor/10. + 0.5 )
      pylab.text( xloc, yloc, 'ALPHA = '+str(submap[0]), color=linecolors[mapColor] )



   pylab.minorticks_on()
   pylab.grid()


# =============================================================================
#  CREATE THE PLOTS FOR EACH COMPONENT MAP IN TURN
# =============================================================================
for component in range(0,len(component_list) ):


   # ==========================================================================
   #  READ THE DATA AND OPTIONS FOR THIS MAP
   # ==========================================================================
   axes=[]

   # execfile( component_list[component] )
   exec(open(component_list[component]).read())


   if maptype == 'MOTORGENERATOR':
      # ==========================================================================
      #  Motor/generator maps are just one alpha
      # ==========================================================================
         pylab.figure(figsize=(10,10), dpi=80, facecolor='w', edgecolor='b')
         pylab.linewidth = 2
         submap = mapdata[0]
         plot_motorgenerator_submap()
   else:
      # ==========================================================================
      #  for 2-D maps: one figure (the first alpha)
      #  for 3-D maps: one figure with all alphas, no efficiency contours
      #                one figure for each alpha (OVERLAY = FALSE)
      # ==========================================================================
      if multiple_alphas == 0:
         pylab.figure(figsize=(10,10), dpi=80, facecolor='w', edgecolor='b')
         pylab.linewidth = 2
         submap = mapdata[0]
         plot_submap()
      
      if multiple_alphas == 1 and overlay == 0:
         for submap in mapdata:
            pylab.figure(figsize=(10,10), dpi=80, facecolor='w', edgecolor='b')
            pylab.linewidth = 2
            plot_submap()
      
      if multiple_alphas == 1 and overlay == 1:
         pylab.figure(figsize=(10,10), dpi=80, facecolor='w', edgecolor='b')
         pylab.linewidth = 2
         mapColor = 0
         for submap in mapdata:
            plot_submap()
            mapColor = mapColor+1
      
      
      
pylab.show()
