%% Fred's Toolbox: Keep vector graphics support of 'Renderer', 'painters'
%
% Use: patch2ind(figure_h);
%
% This will change all patch objects in figure_h to an indexed colormap containing all the unique colors
%
% Fred Hasselman - September 2014
% Contact: me#fredhasselman#com | AT DOT

function patch2ind(figure_h)
try
objects = findall(figure_h,'Type','patch');
catch err
 warning('p2i:findall','No patch objects in figure handle.')
 return;
end
cmapID=-1*ones(1,3);
for o = 1:numel(objects)
 if size(get(objects(o),'EdgeColor'),2)==3
  cmapID = [cmapID;get(objects(o),'EdgeColor')];
 elseif get(objects(o),'MarkerEdgeColor')=='auto'
  try
  cmapID = [cmapID;get(get(get(objects(o),'Parent'),'Parent'),'ColorOrder')];
  catch err
   warning('p2i:ColOrder','No ColotOrder in parent object')
  end
 else
  cmapID = [cmapID;get(figure_h,'ColorMap')];
 end
end
cmapID = [cmapID; get(figure_h,'ColorMap')];
[Y,newmap] = cmunique(cmapID(cmapID>-1));
ind = 1:size(newmap,1);

for o = 1:numel(objects)
 fv = get(objects(o),'FaceVertexCData');
 if size(fv,2)==3
  if any(ismember(newmap,fv,'rows'))
   set(objects(o),'CDataMapping','direct','FaceVertexCData',ind(ismember(newmap,fv,'rows')))
  end
  
  if size(get(objects(o),'EdgeColor'),2)==3
   ec = get(objects(o),'EdgeColor');
   if any(ismember(newmap,ec,'rows'))
    set(objects(o),'CDataMapping','direct','FaceVertexCData',ind(ismember(newmap,ec,'rows')))
   end
  end
 end
 set(figure_h,'ColorMap',newmap,'Renderer','painters');
end
