# GUI-Independent projection module from EpiTools

this repository contains the projection module from EpiTools-Matlab ([/src/src_analysis/module_projection](https://github.com/epitools/epitools-matlab/tree/master/src/src_analysis/module_projection)) with all the GUI dependencies removed.

The main projection function can be found in `createProjection.m` which calls the surface estimation routine `gridfit.m` from [John D'Errico](https://ch.mathworks.com/matlabcentral/fileexchange/8998-surface-fitting-using-gridfit).

To know more about the projection routine check out our wiki page: [epitools.github.io/wiki/Analysis_Modules/00_projection/](https://epitools.github.io/wiki/Analysis_Modules/00_projection/) or the epitools article [http://dx.doi.org/10.1016/j.devcel.2015.12.012](http://dx.doi.org/10.1016/j.devcel.2015.12.012)

# example execution

```matlab
% @SmoothingRadius - gaussian blur to apply before estimating the surface [0.1 - 5]
s = 0.2;
% @depthThreshold - Cutoff distance in z-planes from the 1st estimated surface [1 - 3]
d = 2;
% @SurfSmoothness1 - Surface smoothness for 1st gridFit(c) estimation, the smaller the smoother [30 - 100]
ss1 = 50;
% @SurfSmoothness1 - Surface smoothness for 3nd gridFit(c) estimation, the smaller the smoother [20 - 50]
ss2 = 20;
% @ShowProcess - Boolean to output intermediate results
v = 0;

[ProjIm,DepthMap,xg2,yg2,zg2] = createProjection(time_point,s,d,ss1,ss2,v);
```

The complete example can be found in `_Run_createProjection.m` which uses `mij.jar` to interface with imageJ to load the test image `test_image.tif`.

Optionally the estimated surface can also be exported as VTK file using the included library `vtkwrite.m` or as x,y,z coordinate cloud like in the included `gridfit_surface.vtk`.
