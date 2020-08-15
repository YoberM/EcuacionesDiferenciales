
close all
clear h

graphics_toolkit qt

h.ax = axes ("position", [0.05 0.42 0.5 0.5]);
h.fcn = @(x) polyval([-0.1 0.5 3 0], x);

funcAux = "@"

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
    y0 = str2num(get(h.plot_datoy).string);
    xf = str2num(get(h.plot_datoxf).string);
    noise = get(h.noise_slider).value;
    noise = round(noise*100)/100;
    step = noise;
    tam = ceil((xf - x0)/0.1);
    x = ([0:tam])*0.1+x0;
    f = inline(get(h.plot_title_edit).string);
    df = inline(get(h.plot_title_editDeriv).string);
    
    [xs, ys] = Euler(f,x0,y0,step,xf);
    xs
    ys
    set (h.noise_label, "string", sprintf ("h = %.1f", noise));
    y =  df(x);
    if (init)
      h.plot = plot (x,y,"r",xs,ys,"g");
      guidata (obj, h);
    else
      h.plot = plot (x,y,"r",xs,ys,"g");
    endif
    "Cambio"
  endif
endfunction


## plot title
h.plot_title_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "Ecuacion",
                                "horizontalalignment", "left",
                                "position", [0.6 0.85 0.35 0.08]);

h.plot_title_edit = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "x.^2",
                               "callback", @update_plot,
                               "position", [0.6 0.80 0.35 0.06]);
                               
#Derivada Texto
h.plot_title_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "Ecuacion Derivada",
                                "horizontalalignment", "left",
                                "position", [0.6 0.58800 0.35 0.08]);
#Derivada
h.plot_title_editDeriv = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "x.^2",
                               "callback", @update_plot,
                               "position", [0.6 0.55 0.35 0.06]);

#x0 Texto
h.plot_title_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "x0",
                                "horizontalalignment", "left",
                                "position", [0.6 0.7 0.35 0.08]);
## x
h.plot_datox= uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "0",
                               "callback", @update_plot,
                               "position", [0.6 0.6550 0.10 0.06]);

#y0 Texto
h.plot_title_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "y0",
                                "horizontalalignment", "left",
                                "position", [0.7250 0.7 0.10 0.08]);
## y
h.plot_datoy= uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "2",
                               "callback", @update_plot,
                               "position", [0.7250 0.655 0.10 0.06]);

#xf Texto
h.plot_title_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "xf",
                                "horizontalalignment", "left",
                                "position", [0.850 0.7 0.35 0.08]);
## xf
h.plot_datoxf= uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "2",
                               "callback", @update_plot,
                               "position", [0.850 0.655 0.10 0.06]);

## Boton Generar Grafica
h.print_pushbutton = uicontrol ("style", "pushbutton",
                                "units", "normalized",
                                "string", "Generar Grafica",
                                "callback", @update_plot,
                                "position", [0.6 0.45 0.35 0.09]);
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
                            
                            "value", 0.1,
                            "position", [0.05 0.25 0.35 0.06]);


set (gcf, "color", get(0, "defaultuicontrolbackgroundcolor"))
guidata (gcf, h)
update_plot (gcf, true);
