function guifunc(filename)
%function to load the file, put B in the workspace. 
B= load (filename) 
assignin ('base','B', B)
end

