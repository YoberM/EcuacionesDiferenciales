
close all
clear h

graphics_toolkit qt

h.ax = axes ("position", [0.05 0.42 0.5 0.5]);
h.fcn = @(x) polyval([-0.1 0.5 3 0], x);

funcAux = "@"

% Metodo de Euler para Sistemas de ecuaciones
% 2 ecuaciones
function [tt, yy1,yy2] = eulersistemas(f,f2,x0,xf,y00,y10,h)
 k = ceil((xf - x0)/h)+1;
 tt = zeros(k,1);
 yy1 = zeros(k,1);
 yy2 = zeros(k,1);
 tt(1) = x0;
 yy1(1) = y00;
 yy2(1) = y10;
 for i = 2:k
   tt(i) = tt(i-1) + h;
   m = f(tt(i-1),yy1(i-1),yy2(i-1));
   n = f2(tt(i-1),yy1(i-1),yy2(i-1));
   yy1(i) = yy1(i-1) + h*m;
   yy2(i) = yy2(i-1) + h*n;
 end
end



function update_plot (obj, init = false)

  h = guidata (obj);  
  recalc = false;
  switch (gcbo)
    case {h.print_pushbutton}
      recalc = true;
    case {h.noise_slider}
      recalc = true;
  endswitch

  if (recalc || init)
    x0 = str2num(get(h.plot_datox).string);
    xf = str2num(get(h.plot_datoxf).string);
    y0 = str2num(get(h.plot_datoy).string);
    z0 = str2num(get(h.plot_datoz).string);
    noise = get(h.noise_slider).value;
    noise = round(noise*10)/10;
    step = noise;
    tam = ceil((xf - x0)/0.1);
    x = ([0:tam])*0.1+x0;
    f1 = inline(get(h.plot_title_edit).string,'x','y','z');
    f2 = inline(get(h.plot_title_editDeriv).string,'x','y','z');
    
    [xs, y1,y2] = eulersistemas(f1,f2,x0,xf,y0,z0,step);
    xs
    y1
    y2
    set (h.noise_label, "string", sprintf ("h = %.1f", noise));
    if (init)
      h.plot = plot (xs,y1,"r",xs,y2,"g");
      grid on;
      guidata (obj, h);
    else
      h.plot = plot (xs,y1,"r",xs,y2,"g");
      grid on;
    endif
    "Cambio"
  endif
endfunction


##Ecuacion 1 Texto
h.plot_title_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "Ecuacion y'",
                                "horizontalalignment", "left",
                                "position", [0.6 0.85 0.35 0.08]);
#Ecuacion 1
h.plot_title_edit = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "2 * y - 3 * z",
                               "callback", @update_plot,
                               "position", [0.6 0.80 0.35 0.06]);
                               
#Ecuacion 2 Texto
h.plot_title_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "Ecuacion z'",
                                "horizontalalignment", "left",
                                "position", [0.6 0.75 0.35 0.04]);
#Ecuacion 2
h.plot_title_editDeriv = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "4 * y - 5 * z",
                               "callback", @update_plot,
                               "position", [0.6 0.68 0.35 0.06]);



#y0 Texto
h.plot_title_labely = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "y0",
                                "horizontalalignment", "left",
                                "position", [0.6 0.63 0.10 0.04]);
## y #######
h.plot_datoy= uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "2",
                               "callback", @update_plot,
                               "position", [0.6 0.56 0.10 0.06]);
#z0 Texto
h.plot_title_labelz = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "z0",
                                "horizontalalignment", "left",
                                "position", [0.7250 0.63 0.10 0.04]);
## z #########
h.plot_datoz= uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "3",
                               "callback", @update_plot,
                               "position", [0.7250 0.56 0.10 0.06]);
                               
                               
#x0 Texto
h.plot_title_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "x0",
                                "horizontalalignment", "left",
                                "position", [0.6 0.47 0.35 0.08]);
## x ######
h.plot_datox= uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "0",
                               "callback", @update_plot,
                               "position", [0.6 0.43  0.10 0.06]);                               
                               

#xf Texto
h.plot_title_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "xf",
                                "horizontalalignment", "left",
                                "position", [0.7250 0.47 0.35 0.08]);
## xf
h.plot_datoxf= uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "2",
                               "callback", @update_plot,
                               "position", [0.7250 0.43 0.10 0.06]);

## Boton Generar Grafica
h.print_pushbutton = uicontrol ("style", "pushbutton",
                                "units", "normalized",
                                "string", "Generar Grafica",
                                "callback", @update_plot,
                                "position", [0.6 0.25 0.35 0.09]);
## noise
h.noise_label = uicontrol ("style", "text",
                           "units", "normalized",
                           "string", "h = ",
                           "horizontalalignment", "left",
                           "position", [0.05 0.3 0.35 0.08]);

h.noise_slider = uicontrol ("style", "slider",
                            "units", "normalized",
                            "string", "slider",
                            "min", 0.01,
                            "callback", @update_plot,
                            
                            "value", 0.05,
                            "position", [0.05 0.25 0.35 0.06]);


set (gcf, "color", get(0, "defaultuicontrolbackgroundcolor"))
guidata (gcf, h)
update_plot (gcf, true);