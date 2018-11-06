% Script to call the independent projection function from EpiTools
% ------------------------------------------------------------------------------
%
%   Example script to 
%   (1) load an image stack through the ImageJ interface
%   (2) pass it to the matlab createProjection script
%   (3) send it back to the ImageJ for saving
%
% AUTHOR:   Davide Martin Heller (davide.heller@imls.uzh.ch)
%
% VERSION:  v0.1 2016/02/28
% 
% LICENSE:
%   License to use and modify this code is granted freely without any warranty
% ------------------------------------------------------------------------------

%% 1. Add MIJ interface and ImageJ to javapath

javaaddpath('./mij.jar');
javaaddpath('./ij.jar');

%% 2. Start the ImageJ from Matlab (make sure to allocate enough memory)

MIJ.start()

%% 3. Load Image Stack through ImageJ GUI

%% 4. Import image volume to Matlab

vol = MIJ.getCurrentImage;
MIJ.run('Close');

%% 5. verify data type and convert if necessary
%     createProjection only supports 8 or 16-bit images

vol = uint8(vol);

%% 6. slice volume to individual time point if needed
%     createProjection can only process one time point at a time

time_point = vol;

%% 7. create projection

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

%% (Optional) 3D inspection

figure('Name','Surface Estimation');
surf(xg2,yg2,-zg2) 
zlim([0,s(3)]);
shading interp
colormap(jet(256))
camlight right
lighting phong
title 'Tiled gridfit'

%% 8. reimport projection to ImageJ to visualize and/or save

MIJ.createImage('projection', ProjIm, true);


%% 9. Close all windows and exit MIJ

MIJ.closeAllWindows;
MIJ.exit;

%% 10. Various export methods for the 3D surface

do_export = 3; %0 for no export
if do_export
    %output vtk file
    vtk_frame_path = 'gridfit_surface.vtk';
    
    
    switch do_export
        case 1
            %method 1: Polydata with triangulation (large file size!)
            triangulation = delaunay(xg2,yg2);
            vtkwrite(vtk_frame_path,'polydata','triangle',...
                xg2,yg2,zg2,triangulation);
        case 2
            %method 2: Structured_Grid with Image Data (intermediate)
            vtkwrite(vtk_frame_path,'structured_grid',xg2,yg2,zg2,'scalars','intensity',im);
        case 3
            %method 3: XYZ coordinate file (small)
            vtk_frame_file = fopen(vtk_frame_path, 'w');
            fprintf(vtk_frame_file,'%d %d %f\n',[xg2(:),yg2(:),zg2(:)]');
            fclose(vtk_frame_file);
    end 
end





