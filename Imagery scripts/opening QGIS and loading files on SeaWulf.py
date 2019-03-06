#Open a Terminal
ssh -Y NAME@login.seawulf.stonybrook.edu

#Once logged in
module load shared
module load torque/6.1.1 #The torque module may change versions, try hitting tab to autocomplete
qsub -I -X -q debug

#Now open a SECOND terminal and login as before
#Once you log into the head node, you are now going to login to the compute node just assigned to you in the other terminal
ssh -X sn146     #use whatever is on the prompt in the original Terminal window
module load shared
module load torque/6.1.1   #The torque module may change versions, try hitting tab to autocomplete
module load qgis
qgis     #this should launch qgis

#If you are in QGIS you can just browse for an image like usual, but if you want to pull in all the images associated with a #particular MAPPPD site, this code should work. Note that the first chunk only needs to be run once and not a second time if #you want to choose a second location.

#Run this first time
import processing
MAPPPD = QgsVectorLayer("/gpfs/projects/LynchGroup/Footprints/MAPPPD_sites.shp", "MAPPPD_sites", "ogr")
footprint = QgsVectorLayer("/gpfs/projects/LynchGroup/Footprints/orthoed.shp", "orthoed", "ogr")
#MAPPPD = qgis.utils.iface.activeLayer()
QgsMapLayerRegistry.instance().addMapLayer(MAPPPD)
QgsMapLayerRegistry.instance().addMapLayer(footprint)

#Run this every time you want to load the scenes that overlap with a particular ASI site
query = "site_id = 'ACTI'"
selection = MAPPPD.getFeatures(QgsFeatureRequest().setFilterExpression(query))
MAPPPD.setSelectedFeatures([k.id() for k in selection])
processing.runalg("qgis:selectbylocation","/gpfs/projects/LynchGroup/Footprints/orthoed.shp","/gpfs/projects/LynchGroup/Footprints/MAPPPD_sites.shp",['contains'],0,0)
selected_features = footprint.selectedFeatures()
for feature in selected_features:
    rlayer=iface.addRasterLayer(feature["location"],feature["id"])
    if rlayer.renderer().type()=='multibandcolor':
      rlayer.renderer().setRedBand(4)
      rlayer.renderer().setGreenBand(3)
      rlayer.renderer().setBlueBand(2)
      legend = qgis.utils.iface.legendInterface()
    legend.setLayerVisible(rlayer, False)
