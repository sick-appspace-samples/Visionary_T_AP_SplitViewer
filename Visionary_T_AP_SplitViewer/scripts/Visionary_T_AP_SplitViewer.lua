--[[----------------------------------------------------------------------------

  Application Name: Visionary_T_AP_SplitViewer
    
  Summary:
  Show the image and pointcloud that the camera acquiered
  
  Description:
  Set up the camera to take live images continuously. React to the "OnNewImage"
  event and display the distance image in a 2D and 3D viewer
  
  How to run:
  Start by running the app (F5) or debugging (F7+F10).
  Set a breakpoint on the first row inside the main function to debug step-by-step.
  See the results in the different image viewer on the DevicePage.
  
  More Information:
  If you want to run this app on an emulator some changes are needed to get images.
    
------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------
-- Variables, constants, serves etc. should be declared here.

-- Setup the camera and get the camera model
local camera = Image.Provider.Camera.create()
Image.Provider.Camera.stop(camera)
local cameraModel = Image.Provider.Camera.getInitialCameraModel(camera)

-- Setup the  viewers
local viewer2D = View.create("viewer2D")
local viewer3D = View.create("viewer3D")

-- Setup the view decoration
local decoration = View.ImageDecoration.create()
decoration:setRange(0, 6500)

-- Setup the pointcloud converter
local pointCloudConverter = Image.PointCloudConverter.create(cameraModel)

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------
local function main()
  Image.Provider.Camera.start(camera)
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register("Engine.OnStarted", main)

--@handleOnNewImage(image:Image,sensordata:SensorData)
local function handleOnNewImage(image)
  --Adds the image, [1] is the distance image, [2] is intensity and [3] is confidence
  View.addImage(viewer2D, image[1], decoration) --change decoration if changing image
  View.present(viewer2D)

  --Convert the images, first argument is the distance image, second one is the intensity image
  local pc = pointCloudConverter:convert(image[1],image[2])
  --Show the pointcloud in the viewer
  View.clear(viewer3D)
  View.addPointCloud(viewer3D, pc)
  View.present(viewer3D)
end
Image.Provider.Camera.register(camera, "OnNewImage", handleOnNewImage)
--End of Function and Event Scope-----------------------------------------------