function mask = buildMask(MAXSCALES, hVert, hHorz, hDiag)
mask = cell(4, MAXSCALES);
for j = 1:MAXSCALES
    jplus = j + 1; 
    sze = 2*j + 1; 
    template = zeros(2*j + 1); 

    m = template;
    m(1, jplus) = 1; m(jplus, jplus) = -2; m(sze, jplus) = 1;
    mask{1, j} = m ./ (j*hVert);
    
    m = template;
    m(jplus, 1) = 1; m(jplus, jplus) = -2;  m(jplus, sze) = 1;
    mask{2, j} = m ./ (j*hHorz);
    
    m = template;
    m(1) = 1; m(jplus, jplus) = -2;  m(end) = 1;
    mask{3, j} = m ./ (j*hDiag);
    
    m = template;
    m(1, sze) = 1; m(jplus, jplus) = -2;  m(sze, 1) = 1;
    mask{4, j} = m ./ (j*hDiag);   
end